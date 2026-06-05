## world_config.gd
## Configuration globale du monde voxel.
## Autoload (singleton) — accessible partout via WorldConfig.
## Gère la graine (seed), la taille des chunks, la distance de rendu,
## et la sauvegarde/chargement en JSON.

class_name WorldConfig
extends Node

# ---------------------------------------------------------------------------
# Constantes par défaut
# ---------------------------------------------------------------------------
const DEFAULT_SEED: int = 42
const DEFAULT_CHUNK_SIZE: int = 16
const DEFAULT_WORLD_HEIGHT: int = 64
const DEFAULT_RENDER_DISTANCE: int = 8
const DEFAULT_WORLD_WIDTH: int = 256
const DEFAULT_WORLD_DEPTH: int = 256
const SAVE_DIRECTORY: String = "user://world_saves/"
const SAVE_FILE_EXTENSION: String = ".json"

# ---------------------------------------------------------------------------
# Paramètres du monde (modifiables)
# ---------------------------------------------------------------------------
var world_seed: int = DEFAULT_SEED
var chunk_size: int = DEFAULT_CHUNK_SIZE
var world_height: int = DEFAULT_WORLD_HEIGHT
var render_distance: int = DEFAULT_RENDER_DISTANCE
var world_width: int = DEFAULT_WORLD_WIDTH
var world_depth: int = DEFAULT_WORLD_DEPTH

# Paramètres de génération
var terrain_scale: float = 0.02
var terrain_octaves: int = 4
var terrain_persistence: float = 0.5
var sea_level: int = 12
var snow_level: int = 50

# Paramètres de biome
var biome_scale: float = 0.008
var biome_blend_distance: float = 3.0

# ---------------------------------------------------------------------------
# État interne
# ---------------------------------------------------------------------------
var _current_save_name: String = "default_world"
var _is_loaded: bool = false


# ---------------------------------------------------------------------------
# Initialisation
# ---------------------------------------------------------------------------
func _ready() -> void:
	# Créer le répertoire de sauvegarde si nécessaire
	_ensure_save_directory()


# ---------------------------------------------------------------------------
# Réinitialise la configuration aux valeurs par défaut
# ---------------------------------------------------------------------------
func reset_to_defaults() -> void:
	world_seed = DEFAULT_SEED
	chunk_size = DEFAULT_CHUNK_SIZE
	world_height = DEFAULT_WORLD_HEIGHT
	render_distance = DEFAULT_RENDER_DISTANCE
	world_width = DEFAULT_WORLD_WIDTH
	world_depth = DEFAULT_WORLD_DEPTH
	terrain_scale = 0.02
	terrain_octaves = 4
	terrain_persistence = 0.5
	sea_level = 12
	snow_level = 50
	biome_scale = 0.008
	biome_blend_distance = 3.0
	_is_loaded = false


# ---------------------------------------------------------------------------
# Sauvegarde la configuration actuelle en JSON
# ---------------------------------------------------------------------------
func save_config(save_name: String = "") -> bool:
	if save_name.is_empty():
		save_name = _current_save_name

	var config_data: Dictionary = {
		"world_seed": world_seed,
		"chunk_size": chunk_size,
		"world_height": world_height,
		"render_distance": render_distance,
		"world_width": world_width,
		"world_depth": world_depth,
		"terrain_scale": terrain_scale,
		"terrain_octaves": terrain_octaves,
		"terrain_persistence": terrain_persistence,
		"sea_level": sea_level,
		"snow_level": snow_level,
		"biome_scale": biome_scale,
		"biome_blend_distance": biome_blend_distance,
		"save_timestamp": Time.get_unix_time_from_system(),
		"save_name": save_name,
	}

	var file_path: String = SAVE_DIRECTORY + save_name + SAVE_FILE_EXTENSION
	var file: FileAccess = FileAccess.open(file_path, FileAccess.WRITE)
	if file == null:
		push_error("WorldConfig: impossible d'écrire le fichier de sauvegarde '%s' (erreur %d)" % [file_path, FileAccess.get_open_error()])
		return false

	file.store_string(JSON.stringify(config_data, "\t"))
	file.close()

	print("WorldConfig: configuration sauvegardée dans '%s'" % file_path)
	return true


# ---------------------------------------------------------------------------
# Charge une configuration depuis un fichier JSON
# ---------------------------------------------------------------------------
func load_config(save_name: String) -> bool:
	var file_path: String = SAVE_DIRECTORY + save_name + SAVE_FILE_EXTENSION

	if not FileAccess.file_exists(file_path):
		push_warning("WorldConfig: fichier de sauvegarde introuvable '%s'" % file_path)
		return false

	var file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		push_error("WorldConfig: impossible de lire le fichier '%s' (erreur %d)" % [file_path, FileAccess.get_open_error()])
		return false

	var json_text: String = file.get_as_text()
	file.close()

	var json: JSON = JSON.new()
	var error: Error = json.parse(json_text)
	if error != OK:
		push_error("WorldConfig: erreur de parsing JSON dans '%s'" % file_path)
		return false

	var data: Dictionary = json.data as Dictionary

	# Charger les valeurs avec fallback sur les défauts
	world_seed = data.get("world_seed", DEFAULT_SEED)
	chunk_size = data.get("chunk_size", DEFAULT_CHUNK_SIZE)
	world_height = data.get("world_height", DEFAULT_WORLD_HEIGHT)
	render_distance = data.get("render_distance", DEFAULT_RENDER_DISTANCE)
	world_width = data.get("world_width", DEFAULT_WORLD_WIDTH)
	world_depth = data.get("world_depth", DEFAULT_WORLD_DEPTH)
	terrain_scale = data.get("terrain_scale", 0.02)
	terrain_octaves = data.get("terrain_octaves", 4)
	terrain_persistence = data.get("terrain_persistence", 0.5)
	sea_level = data.get("sea_level", 12)
	snow_level = data.get("snow_level", 50)
	biome_scale = data.get("biome_scale", 0.008)
	biome_blend_distance = data.get("biome_blend_distance", 3.0)

	_current_save_name = save_name
	_is_loaded = true

	print("WorldConfig: configuration chargée depuis '%s' (seed: %d)" % [file_path, world_seed])
	return true


# ---------------------------------------------------------------------------
# Sauvegarde les données de blocs d'un chunk
# ---------------------------------------------------------------------------
func save_chunk_data(chunk_x: int, chunk_z: int, blocks: Dictionary) -> bool:
	var dir_path: String = SAVE_DIRECTORY + _current_save_name + "/chunks/"
	DirAccess.make_dir_recursive_absolute(dir_path)

	var file_path: String = dir_path + "chunk_%d_%d.json" % [chunk_x, chunk_z]
	var file: FileAccess = FileAccess.open(file_path, FileAccess.WRITE)
	if file == null:
		return false

	var chunk_data: Dictionary = {
		"chunk_x": chunk_x,
		"chunk_z": chunk_z,
		"blocks": blocks,
		"timestamp": Time.get_unix_time_from_system(),
	}

	file.store_string(JSON.stringify(chunk_data, "\t"))
	file.close()
	return true


# ---------------------------------------------------------------------------
# Charge les données de blocs d'un chunk
# ---------------------------------------------------------------------------
func load_chunk_data(chunk_x: int, chunk_z: int) -> Dictionary:
	var file_path: String = SAVE_DIRECTORY + _current_save_name + "/chunks/chunk_%d_%d.json" % [chunk_x, chunk_z]

	if not FileAccess.file_exists(file_path):
		return {}

	var file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		return {}

	var json_text: String = file.get_as_text()
	file.close()

	var json: JSON = JSON.new()
	if json.parse(json_text) != OK:
		return {}

	var data: Dictionary = json.data as Dictionary
	return data.get("blocks", {})


# ---------------------------------------------------------------------------
# Liste les sauvegardes disponibles
# ---------------------------------------------------------------------------
func list_saves() -> Array:
	var saves: Array = []
	var dir: DirAccess = DirAccess.open(SAVE_DIRECTORY)
	if dir == null:
		return saves

	dir.list_dir_begin()
	var file_name: String = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(SAVE_FILE_EXTENSION):
			saves.append(file_name.replace(SAVE_FILE_EXTENSION, ""))
		file_name = dir.get_next()
	dir.list_dir_end()

	return saves


# ---------------------------------------------------------------------------
# Supprime une sauvegarde
# ---------------------------------------------------------------------------
func delete_save(save_name: String) -> bool:
	var file_path: String = SAVE_DIRECTORY + save_name + SAVE_FILE_EXTENSION
	var error: Error = DirAccess.remove_absolute(file_path)
	if error != OK:
		push_warning("WorldConfig: impossible de supprimer '%s'" % file_path)
		return false
	return true


# ---------------------------------------------------------------------------
# Retourne la configuration sous forme de dictionnaire
# ---------------------------------------------------------------------------
func get_config_dict() -> Dictionary:
	return {
		"world_seed": world_seed,
		"chunk_size": chunk_size,
		"world_height": world_height,
		"render_distance": render_distance,
		"world_width": world_width,
		"world_depth": world_depth,
		"terrain_scale": terrain_scale,
		"terrain_octaves": terrain_octaves,
		"terrain_persistence": terrain_persistence,
		"sea_level": sea_level,
		"snow_level": snow_level,
		"biome_scale": biome_scale,
		"biome_blend_distance": biome_blend_distance,
	}


# ---------------------------------------------------------------------------
# Utilitaire : crée le répertoire de sauvegarde
# ---------------------------------------------------------------------------
func _ensure_save_directory() -> void:
	DirAccess.make_dir_recursive_absolute(SAVE_DIRECTORY)
