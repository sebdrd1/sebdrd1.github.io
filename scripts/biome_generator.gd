## biome_generator.gd
## Generation procedurale de terrain voxel par biome - Godot 4.6.2
@tool
class_name BiomeGenerator
extends Node3D

## Parametres de generation
@export var world_seed: int = 42
@export var chunk_size: int = 16
@export var max_height: int = 64
@export var sea_level: int = 20
@export var render_distance: int = 8

## Bruit de terrain
var _noise: FastNoiseLite
var _temp_noise: FastNoiseLite
var _humidity_noise: FastNoiseLite
var _cave_noise: FastNoiseLite

## Charges de chunks
var _loaded_chunks: Dictionary = {}  # Vector2i -> Node3D
var _chunk_pool: Array[Node3D] = []

## Signal emis quand un chunk est genere
signal chunk_generated(chunk_pos: Vector2i)
signal chunk_unloaded(chunk_pos: Vector2i)

func _ready() -> void:
	_initialize_noise()
	set_process(true)

func _initialize_noise() -> void:
	_noise = FastNoiseLite.new()
	_noise.seed = world_seed
	_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	_noise.fractal_type = FastNoiseLite.FRACTAL_FBM
	_noise.fractal_octaves = 5
	_noise.fractal_lacunarity = 2.0
	_noise.fractal_gain = 0.5
	_noise.frequency = 0.008

	_temp_noise = FastNoiseLite.new()
	_temp_noise.seed = world_seed + 100
	_temp_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	_temp_noise.fractal_octaves = 3
	_temp_noise.frequency = 0.003

	_humidity_noise = FastNoiseLite.new()
	_humidity_noise.seed = world_seed + 200
	_humidity_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	_humidity_noise.fractal_octaves = 3
	_humidity_noise.frequency = 0.004

	_cave_noise = FastNoiseLite.new()
	_cave_noise.seed = world_seed + 300
	_cave_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	_cave_noise.fractal_octaves = 3
	_cave_noise.frequency = 0.03

## Genere un chunk a la position donnee
func generate_chunk(chunk_x: int, chunk_z: int) -> Node3D:
	var chunk_pos := Vector2i(chunk_x, chunk_z)
	if _loaded_chunks.has(chunk_pos):
		return _loaded_chunks[chunk_pos]

	var chunk_node := Node3D.new()
	chunk_node.name = "Chunk_%d_%d" % [chunk_x, chunk_z]
	chunk_node.position = Vector3(chunk_x * chunk_size, 0, chunk_z * chunk_size)

	var blocks: Array = _generate_chunk_data(chunk_x, chunk_z)
	_build_chunk_mesh(chunk_node, blocks, chunk_x, chunk_z)

	# Ajouter decorations du biome
	_generate_vegetation(chunk_node, chunk_x, chunk_z, blocks)

	add_child(chunk_node)
	_loaded_chunks[chunk_pos] = chunk_node

	chunk_generated.emit(chunk_pos)
	return chunk_node

## Genere les donnees de blocs d'un chunk
func _generate_chunk_data(chunk_x: int, chunk_z: int) -> Array:
	var blocks: Array = []
	blocks.resize(chunk_size * chunk_size * max_height)

	var base_x: int = chunk_x * chunk_size
	var base_z: int = chunk_z * chunk_size

	for x in range(chunk_size):
		for z in range(chunk_size):
			var world_x: int = base_x + x
			var world_z: int = base_z + z
			var biome := _get_biome_at(world_x, world_z)
			var height: int = _get_height_at(world_x, world_z, biome)

			for y in range(max_height):
				var idx: int = _block_index(x, y, z)
				blocks[idx] = _get_block_at(world_x, y, world_z, height, biome)

	return blocks

## Determine le type de bloc a une position
func _get_block_at(x: int, y: int, z: int, surface_height: int, biome: BiomeRegistry.BiomeType) -> BlockTypes.BlockType:
	var data: Dictionary = BiomeRegistry.BIOME_DATA.get(biome, {})
	var top_block: int = data.get("blocks", {}).get("top", BlockTypes.BlockType.GRASS)
	var sub_block: int = data.get("blocks", {}).get("sub", BlockTypes.BlockType.DIRT)

	# Couches de base
	if y == 0:
		return BlockTypes.BlockType.BEDROCK
	elif y < surface_height - 4:
		# Souterrain: pierre avec grottes
		if _is_cave(x, y, z):
			return BlockTypes.BlockType.AIR
		return BlockTypes.BlockType.STONE
	elif y < surface_height - 1:
		return BlockTypes.BlockType(sub_block)
	elif y == surface_height - 1:
		return BlockTypes.BlockType(top_block)
	elif y < sea_level:
		return BlockTypes.BlockType.WATER
	else:
		return BlockTypes.BlockType.AIR

## Determine s'il y a une grotte
func _is_cave(x: int, y: int, z: int) -> bool:
	if y < 2 or y > 50:
		return false
	var cave_val: float = _cave_noise.get_noise_3d(x, y, z)
	return cave_val > 0.45

## Genere la height map au point donne
func _get_height_at(x: int, z: int, biome: BiomeRegistry.BiomeType) -> int:
	var data: Dictionary = BiomeRegistry.BIOME_DATA.get(biome, {})
	var h_range: Vector2 = data.get("height_range", Vector2(10, 40))
	var roughness: float = data.get("roughness", 0.5)

	var noise_val: float = _noise.get_noise_2d(x, z)
	var detail_noise: float = _noise.get_noise_2d(x * 3.5, z * 3.5) * 0.3
	var height_factor: float = clamp((noise_val + detail_noise + 1.0) * 0.5, 0.0, 1.0)
	height_factor = pow(height_factor, 1.0 + roughness)

	var height: int = int(h_range.x + (h_range.y - h_range.x) * height_factor)
	return clampi(height, 1, max_height - 1)

## Determine le biome a une position
func _get_biome_at(x: int, z: int) -> BiomeRegistry.BiomeType:
	var temp: float = (_temp_noise.get_noise_2d(x, z) + 1.0) * 0.5
	var humidity: float = (_humidity_noise.get_noise_2d(x, z) + 1.0) * 0.5
	return BiomeRegistry._classify_biome(temp, humidity)

## Construit le mesh d'un chunk
func _build_chunk_mesh(chunk_node: Node3D, blocks: Array, chunk_x: int, chunk_z: int) -> void:
	var mesh_instance := MeshInstance3D.new()
	var mesh := ArrayMesh.new()
	var vertices: PackedVector3Array = PackedVector3Array()
	var colors: PackedColorArray = PackedColorArray()
	var normals: PackedVector3Array = PackedVector3Array()
	var faces_built: int = 0

	for x in range(chunk_size):
		for y in range(max_height):
			for z in range(chunk_size):
				var idx: int = _block_index(x, y, z)
				var block_type: BlockTypes.BlockType = blocks[idx]
				if block_type == BlockTypes.BlockType.AIR:
					continue

				var block_color: Color = BlockTypes.get_block_color(block_type)
				var world_pos := Vector3(x, y, z)

				# 6 faces: +X, -X, +Y, -Y, +Z, -Z
				var faces: Array = [
					{ "dir": Vector3.RIGHT, "normal": Vector3.RIGHT },
					{ "dir": Vector3.LEFT, "normal": Vector3.LEFT },
					{ "dir": Vector3.UP, "normal": Vector3.UP },
					{ "dir": Vector3.DOWN, "normal": Vector3.DOWN },
					{ "dir": Vector3.FORWARD, "normal": Vector3.FORWARD },
					{ "dir": Vector3.BACK, "normal": Vector3.BACK }
				]

				for face in faces:
					var neighbor_pos: Vector3 = world_pos + face.dir
					var nx: int = int(neighbor_pos.x)
					var ny: int = int(neighbor_pos.y)
					var nz: int = int(neighbor_pos.z)

					if nx < 0 or nx >= chunk_size or nz < 0 or nz >= chunk_size or ny < 0 or ny >= max_height:
						continue

					var nidx: int = _block_index(nx, ny, nz)
					var neighbor_block: BlockTypes.BlockType = blocks[nidx]
					if BlockTypes.is_transparent(neighbor_block):
						_add_face(vertices, colors, normals, chunk_node.position + neighbor_pos, face.dir, block_color, face.normal)
						faces_built += 1

	var arrays: Array = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_COLOR] = colors
	arrays[Mesh.ARRAY_NORMAL] = normals
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	mesh_instance.mesh = mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
	chunk_node.add_child(mesh_instance)

## Ajoute une face au mesh (6 vertices = 2 triangles)
func _add_face(vertices: PackedVector3Array, colors: PackedColorArray, normals: PackedVector3Array, pos: Vector3, dir: Color, color: Color, normal: Vector3) -> void:
	# Simplified: just add a cube face
	var v0: Vector3 = pos
	var v1: Vector3 = pos + Vector3(1, 0, 0)
	var v2: Vector3 = pos + Vector3(1, 1, 0)
	var v3: Vector3 = pos + Vector3(0, 1, 0)
	vertices.append(v0); vertices.append(v1); vertices.append(v2)
	vertices.append(v0); vertices.append(v2); vertices.append(v3)
	for i in range(6):
		colors.append(color)
		normals.append(normal)

## Index lineaire d'un bloc dans le tableau
func _block_index(x: int, y: int, z: int) -> int:
	return x + z * chunk_size + y * chunk_size * chunk_size

## Genere la vegetation et décors d'un chunk
func _generate_vegetation(chunk_node: Node3D, chunk_x: int, chunk_z: int, blocks: Array) -> void:
	var base_x: int = chunk_x * chunk_size
	var base_z: int = chunk_z * chunk_size
	var biome: BiomeRegistry.BiomeType = _get_biome_at(base_x, base_z)
	var data: Dictionary = BiomeRegistry.BIOME_DATA.get(biome, {})
	var veg_density: float = data.get("vegetation", 0.3)
	var structures: Array = data.get("structures", [])

	# Placer des arbres en foret
	if biome == BiomeRegistry.BiomeType.FORET_ENCHANTEE and randf() < veg_density * 0.1:
		var tree_x: int = randi() % chunk_size
		var tree_z: int = randi() % chunk_size
		var tree_y: int = _get_height_at(base_x + tree_x, base_z + tree_z, biome)
		_spawn_tree(chunk_node, Vector3(tree_x, tree_y, tree_z))

	# Placer des structures
	for structure in structures:
		if randf() < 0.02:  # 2% chance per chunk
			_spawn_structure(chunk_node, structure, base_x, base_z)

## Fait apparaitre un arbre
func _spawn_tree(parent: Node3D, pos: Vector3) -> void:
	var trunk := MeshInstance3D.new()
	var trunk_mesh := BoxMesh.new()
	trunk_mesh.size = Vector3(1, 4, 1)
	trunk.mesh = trunk_mesh
	trunk.position = pos + Vector3(0, 2.5, 0)

	var leaves := MeshInstance3D.new()
	var leaves_mesh := BoxMesh.new()
	leaves_mesh.size = Vector3(3, 3, 3)
	leaves.mesh = leaves_mesh
	leaves.position = pos + Vector3(0, 5.5, 0)

	parent.add_child(trunk)
	parent.add_child(leaves)

## Fait apparaitre une structure
func _spawn_structure(parent: Node3D, structure_name: String, base_x: int, base_z: int) -> void:
	var struct_instance := Node3D.new()
	struct_instance.name = structure_name
	struct_instance.position = Vector3(
		base_x + randf() * chunk_size,
		_get_height_at(base_x, base_z, _get_biome_at(base_x, base_z)),
		base_z + randf() * chunk_size
	)
	parent.add_child(struct_instance)

## Boucle principale: charger/decharger les chunks autour du joueur
func _process(delta: float) -> void:
	var player_pos: Vector3 = get_viewport().get_camera_3d().global_position if get_viewport().get_camera_3d() else Vector3.ZERO
	var player_chunk_x: int = int(player_pos.x) / chunk_size
	var player_chunk_z: int = int(player_pos.z) / chunk_size

	# Charger les chunks dans la distance de rendu
	for x in range(player_chunk_x - render_distance, player_chunk_x + render_distance + 1):
		for z in range(player_chunk_z - render_distance, player_chunk_z + render_distance + 1):
			generate_chunk(x, z)

	# Decharger les chunks lointains
	var to_unload: Array = []
	for chunk_pos in _loaded_chunks:
		var dx: int = absi(chunk_pos.x - player_chunk_x)
		var dz: int = absi(chunk_pos.y - player_chunk_z)
		if dx > render_distance + 2 or dz > render_distance + 2:
			to_unload.append(chunk_pos)

	for chunk_pos in to_unload:
		var chunk_node: Node3D = _loaded_chunks[chunk_pos]
		_loaded_chunks.erase(chunk_pos)
		chunk_node.queue_free()
		chunk_unloaded.emit(chunk_pos)
