## biome_registry.gd
## Registre central des 16 biomes - Godot 4.6.2
@tool
class_name BiomeRegistry
extends Node

enum BiomeType {
	FORET_ENCHANTEE, DESERT_MYTHIQUE, MONTAGNE_DU_DRAGON, OCEAN_PROFOND,
	VOLCAN_INFERNALE, GLAISE_ET_AURORA, CITE_DOR, RUINES_ANCIENNES,
	ROYAUME_DES_OMBRES, ISLES_DU_CIEL, CRISTALLINE_CAVERNE, VILLAGE_COLONIE,
	FORTERESSE_MECA, DIMENSION_MAGIQUE, ARENE_DE_COMBAT, TEMPLE_LEGENDAIRE
}

const BIOME_DATA: Dictionary = {
	BiomeType.FORET_ENCHANTEE: {
		"name_fr": "Forêt Enchantée", "name_en": "Enchanted Forest",
		"description": "Dense foret magique avec arbres geants, champignons lumineux et clairieres feeriques",
		"primary_color": Color(0.13, 0.55, 0.13),
		"secondary_color": Color(0.30, 0.75, 0.30),
		"height_range": Vector2(20, 45), "roughness": 0.4, "vegetation": 0.85,
		"fog_color": Color(0.60, 0.85, 0.60), "fog_density": 0.015,
		"music": "bgm_forest", "ambient": "amb_forest_birds",
		"temp": 0.65, "humidity": 0.80,
		"blocks": { "top": 3, "sub": 2 },
		"characters": ["Totoro", "Aang", "Bloom_Winx", "Basilisk"],
		"mobs": ["butterfly_fairy", "bunny_spirit", "mushroom_critter", "deer_spirit"],
		"structures": ["totoro_hollow", "fairy_ring", "mushroom_circle", "ancient_oak"],
		"sky_tint": Color(0.7, 0.9, 0.7)
	},
	BiomeType.DESERT_MYTHIQUE: {
		"name_fr": "Desert Mythique", "name_en": "Mythic Desert",
		"description": "Dunes anciennes dissimulant pyramides, temples oublies et oasis mysterieuses",
		"primary_color": Color(0.85, 0.75, 0.45),
		"secondary_color": Color(0.70, 0.55, 0.30),
		"height_range": Vector2(5, 25), "roughness": 0.7, "vegetation": 0.08,
		"fog_color": Color(0.90, 0.82, 0.60), "fog_density": 0.025,
		"music": "bgm_desert", "ambient": "amb_desert_wind",
		"temp": 0.95, "humidity": 0.05,
		"blocks": { "top": 4, "sub": 5 },
		"characters": ["Asterix", "Obelix", "Indiana_Jones", "Leonidas_300"],
		"mobs": ["scorpion_giant", "snake_sphinx", "scarab_swarm", "desert_fox"],
		"structures": ["pyramid", "oasis_temple", "roman_camp", "sphinx_ruin"],
		"sky_tint": Color(1.0, 0.92, 0.75)
	},
	BiomeType.MONTAGNE_DU_DRAGON: {
		"name_fr": "Montagne du Dragon", "name_en": "Dragon Mountain",
		"description": "Sommets vertigneux aux pics enneiges abritant des grottes de dragons",
		"primary_color": Color(0.50, 0.50, 0.55),
		"secondary_color": Color(0.90, 0.92, 0.95),
		"height_range": Vector2(40, 80), "roughness": 0.85, "vegetation": 0.15,
		"fog_color": Color(0.75, 0.80, 0.90), "fog_density": 0.03,
		"music": "bgm_mountain", "ambient": "amb_mountain_wind",
		"temp": 0.20, "humidity": 0.50,
		"blocks": { "top": 8, "sub": 1 },
		"characters": ["Dragon_Feu", "Dragon_Glace", "Thor", "Gandalf", "Smaug"],
		"mobs": ["goat_mountain", "eagle_dragon", "ice_wolf", "thunder_bird"],
		"structures": ["dragon_lair", "thor_peak", "ice_cave", "eagle_nest"],
		"sky_tint": Color(0.75, 0.82, 0.95)
	},
	BiomeType.OCEAN_PROFOND: {
		"name_fr": "Ocean Profond", "name_en": "Deep Ocean",
		"description": "Profondeurs oceaniques avec recifs de corail, temples engloutis et epaves pirates",
		"primary_color": Color(0.10, 0.30, 0.65),
		"secondary_color": Color(0.15, 0.45, 0.75),
		"height_range": Vector2(0, 30), "roughness": 0.5, "vegetation": 0.30,
		"fog_color": Color(0.15, 0.35, 0.55), "fog_density": 0.05,
		"music": "bgm_ocean", "ambient": "amb_ocean_deep",
		"temp": 0.40, "humidity": 1.0,
		"blocks": { "top": 38, "sub": 4 },
		"characters": ["Jack_Sparrow", "Albator", "Poseidon", "Moana"],
		"mobs": ["giant_squid", "shark_white", "jellyfish_luminous", "whale_ancient"],
		"structures": ["pirate_shipwreck", "atlantis_ruin", "coral_temple", "kraken_depth"],
		"sky_tint": Color(0.6, 0.75, 0.9)
	},
	BiomeType.VOLCAN_INFERNALE: {
		"name_fr": "Volcan Infernale", "name_en": "Infernal Volcano",
		"description": "Terreur volcanique avec coulees de lave, obsidienne et flammes eternelles",
		"primary_color": Color(0.60, 0.10, 0.05),
		"secondary_color": Color(0.80, 0.25, 0.05),
		"height_range": Vector2(30, 70), "roughness": 0.9, "vegetation": 0.02,
		"fog_color": Color(0.40, 0.15, 0.08), "fog_density": 0.06,
		"music": "bgm_volcano", "ambient": "amb_volcano_rumble",
		"temp": 1.0, "humidity": 0.02,
		"blocks": { "top": 36, "sub": 1 },
		"characters": ["Dragon_Feu", "Guts_Berserk", "Mustafar_SW", "Ifrit"],
		"mobs": ["lava_elemental", "fire_salamander", "magma_golem", "phoenix_fire"],
		"structures": ["volcano_core", "lava_forge", "obsidian_castle", "fire_temple"],
		"sky_tint": Color(0.9, 0.4, 0.15)
	},
	BiomeType.GLAISE_ET_AURORA: {
		"name_fr": "Glace et Aurore", "name_en": "Ice and Aurora",
		"description": "Terres glacees sous borales boreales et austeres, dragons de glace en plein vol",
		"primary_color": Color(0.75, 0.85, 0.92),
		"secondary_color": Color(0.55, 0.70, 0.82),
		"height_range": Vector2(15, 50), "roughness": 0.5, "vegetation": 0.10,
		"fog_color": Color(0.70, 0.80, 0.90), "fog_density": 0.03,
		"music": "bgm_ice_aurora", "ambient": "amb_ice_wind",
		"temp": 0.05, "humidity": 0.40,
		"blocks": { "top": 8, "sub": 7 },
		"characters": ["Dragon_Glace", "Jon_Snow", "Katara", "Elsa"],
		"mobs": ["ice_wolf", "frost_giant", "polar_bear", "aurora_spirit"],
		"structures": ["ice_palace", "frozen_castle", "aurora_temple", "ice_cave"],
		"sky_tint": Color(0.65, 0.85, 1.0)
	},
	BiomeType.CITE_DOR: {
		"name_fr": "cite d'Or", "name_en": "City of Gold",
		"description": "Cite legendaire aux temples dore et palais majestueux centre de l'empire",
		"primary_color": Color(0.85, 0.70, 0.20),
		"secondary_color": Color(0.70, 0.55, 0.15),
		"height_range": Vector2(10, 35), "roughness": 0.3, "vegetation": 0.25,
		"fog_color": Color(0.85, 0.80, 0.60), "fog_density": 0.02,
		"music": "bgm_city_gold", "ambient": "amb_city_market",
		"temp": 0.70, "humidity": 0.35,
		"blocks": { "top": 34, "sub": 34 },
		"characters": ["Esteban_CiteOr", "AgeOfEmpire_Leaders", "Napoleon", "Cleopatre"],
		"mobs": ["guard_soldier", "merchant_npc", "royal_guard", "court_magician"],
		"structures": ["golden_temple", "royal_palace", "market_square", "aqueduct"],
		"sky_tint": Color(0.95, 0.90, 0.70)
	},
	BiomeType.RUINES_ANCIENNES: {
		"name_fr": "Ruines Anciennes", "name_en": "Ancient Ruins",
		"description": "Temples envahis par la vegetation, pietges mortels et tresors archeologiques",
		"primary_color": Color(0.45, 0.48, 0.38),
		"secondary_color": Color(0.35, 0.38, 0.30),
		"height_range": Vector2(8, 30), "roughness": 0.6, "vegetation": 0.40,
		"fog_color": Color(0.50, 0.52, 0.42), "fog_density": 0.04,
		"music": "bgm_ruins", "ambient": "amb_ruins_echo",
		"temp": 0.55, "humidity": 0.60,
		"blocks": { "top": 1, "sub": 1 },
		"characters": ["Lara_Croft", "Indiana_Jones", "Claire_JP", "Rick_OCONNOR"],
		"mobs": ["temple_guardian", "poison_dart_trap", "rolling_boulder", "undead_warrior"],
		"structures": ["tomb_chamber", "trap_corridor", "artifact_vault", "collapsing_bridge"],
		"sky_tint": Color(0.80, 0.78, 0.70)
	},
	BiomeType.ROYAUME_DES_OMBRES: {
		"name_fr": "Royaume des Ombres", "name_en": "Shadow Realm",
		"description": "Dimensions sombres et terrifiantes royaumes des morts et des ombres eternelles",
		"primary_color": Color(0.10, 0.08, 0.15),
		"secondary_color": Color(0.20, 0.15, 0.28),
		"height_range": Vector2(10, 40), "roughness": 0.7, "vegetation": 0.05,
		"fog_color": Color(0.12, 0.10, 0.18), "fog_density": 0.07,
		"music": "bgm_shadow", "ambient": "amb_shadow_whispers",
		"temp": 0.25, "humidity": 0.30,
		"blocks": { "top": 35, "sub": 35 },
		"characters": ["Dragon_Ombre", "Guts_Berserk", "Sauron_LOTR", "Voldemort"],
		"mobs": ["shadow_wraith", "dark_knight", "void_spider", "death_stalker"],
		"structures": ["shadow_castle", "death_temple", "portal_abyss", "soul_forge"],
		"sky_tint": Color(0.3, 0.2, 0.4)
	},
	BiomeType.ISLES_DU_CIEL: {
		"name_fr": "Iles du Ciel", "name_en": "Sky Islands",
		"description": "Iles flottantes dans les nuages chutes d'eau vers l'infini pegases et dragons aeriens",
		"primary_color": Color(0.55, 0.70, 0.90),
		"secondary_color": Color(0.40, 0.55, 0.75),
		"height_range": Vector2(50, 90), "roughness": 0.6, "vegetation": 0.35,
		"fog_color": Color(0.70, 0.80, 0.95), "fog_density": 0.02,
		"music": "bgm_sky", "ambient": "amb_sky_wind",
		"temp": 0.35, "humidity": 0.60,
		"blocks": { "top": 3, "sub": 1 },
		"characters": ["Dragon_Air", "StarWars_Pilot", "PacificRim_Jaeger", "Aang_flying"],
		"mobs": ["sky_whale", "cloud_serpent", "pegasus", "wind_elemental"],
		"structures": ["floating_castel", "cloud_city", "sky_portal", "windmill_floating"],
		"sky_tint": Color(0.6, 0.8, 1.0)
	},
	BiomeType.CRISTALLINE_CAVERNE: {
		"name_fr": "Caverne Cristalline", "name_en": "Crystal Cavern",
		"description": "Cavernes souterraines remplies de cristaux gemmes luminescents et mineraux precieux",
		"primary_color": Color(0.50, 0.30, 0.70),
		"secondary_color": Color(0.65, 0.45, 0.85),
		"height_range": Vector2(0, 25), "roughness": 0.5, "vegetation": 0.05,
		"fog_color": Color(0.40, 0.25, 0.55), "fog_density": 0.04,
		"music": "bgm_crystal", "ambient": "amb_crystal_hum",
		"temp": 0.30, "humidity": 0.45,
		"blocks": { "top": 17, "sub": 1 },
		"characters": ["Dragon_Emeraude", "Dragon_Saphir", "Dragon_Rubis", "Steven_Universe"],
		"mobs": ["crystal_golem", "gem_spider", "mineral_slime", "diamond_beetle"],
		"structures": ["crystal_chamber", "gem_vein", "underground_lake", "mining_shaft"],
		"sky_tint": Color(0.5, 0.35, 0.65)
	},
	BiomeType.VILLAGE_COLONIE: {
		"name_fr": "Village Colonie", "name_en": "Colony Village",
		"description": "Village colonial avec fermes, maisons, forge et marche centre de la vie sociale",
		"primary_color": Color(0.55, 0.45, 0.30),
		"secondary_color": Color(0.65, 0.55, 0.38),
		"height_range": Vector2(8, 20), "roughness": 0.2, "vegetation": 0.50,
		"fog_color": Color(0.75, 0.72, 0.60), "fog_density": 0.01,
		"music": "bgm_village", "ambient": "amb_village_life",
		"temp": 0.55, "humidity": 0.50,
		"blocks": { "top": 3, "sub": 2 },
		"characters": ["Lucky_Luke", "Marty_McFly", "Colons_MineColonie", "Shrek"],
		"mobs": ["chicken", "cow", "pig", "sheep", "dog", "cat", "horse"],
		"structures": ["farm_house", "blacksmith", "market_stall", "church", "well", "windmill"],
		"sky_tint": Color(0.85, 0.88, 0.80)
	},
	BiomeType.FORTERESSE_MECA: {
		"name_fr": "Forteresse Mecanique", "name_en": "Mechanical Fortress",
		"description": "Cite futuriste avec circuits, robots, armures mecanisees et technologie avancee",
		"primary_color": Color(0.35, 0.38, 0.42),
		"secondary_color": Color(0.50, 0.55, 0.60),
		"height_range": Vector2(15, 45), "roughness": 0.4, "vegetation": 0.03,
		"fog_color": Color(0.30, 0.32, 0.38), "fog_density": 0.03,
		"music": "bgm_mech", "ambient": "amb_mech_hum",
		"temp": 0.45, "humidity": 0.20,
		"blocks": { "top": 39, "sub": 39 },
		"characters": ["Optimus_Prime", "Iron_Man", "PacificRim_Jaeger", "Megatron"],
		"mobs": ["battle_drone", "security_bot", "laser_turret", "repair_drone"],
		"structures": ["mech_factory", "command_center", "reactor_core", "hangar_bay"],
		"sky_tint": Color(0.55, 0.60, 0.70)
	},
	BiomeType.DIMENSION_MAGIQUE: {
		"name_fr": "Dimension Magique", "name_en": "Magical Dimension",
		"description": "Dimension feerique avec portails, energies magiques et realites deformees",
		"primary_color": Color(0.40, 0.15, 0.60),
		"secondary_color": Color(0.60, 0.25, 0.80),
		"height_range": Vector2(10, 50), "roughness": 0.6, "vegetation": 0.20,
		"fog_color": Color(0.35, 0.15, 0.50), "fog_density": 0.04,
		"music": "bgm_magic", "ambient": "amb_magic_hum",
		"temp": 0.50, "humidity": 0.55,
		"blocks": { "top": 33, "sub": 33 },
		"characters": ["Harry_Potter", "Dr_Strange", "Winx_Fairies", "Gandalf_White"],
		"mobs": ["magic_orb", "spell_wisp", "enchanted_armor", "portal_guardian"],
		"structures": ["magic_tower", "portal_nexus", "enchanted_library", "spell_circle"],
		"sky_tint": Color(0.5, 0.3, 0.7)
	},
	BiomeType.ARENE_DE_COMBAT: {
		"name_fr": "Arene de Combat", "name_en": "Combat Arena",
		"description": "Arene legendaire pour combats epiques duels et tournois de gladiateurs",
		"primary_color": Color(0.65, 0.50, 0.30),
		"secondary_color": Color(0.50, 0.38, 0.22),
		"height_range": Vector2(5, 15), "roughness": 0.15, "vegetation": 0.02,
		"fog_color": Color(0.70, 0.60, 0.45), "fog_density": 0.02,
		"music": "bgm_arena", "ambient": "amb_arena_crowd",
		"temp": 0.60, "humidity": 0.25,
		"blocks": { "top": 4, "sub": 1 },
		"characters": ["Goku", "Vegeta", "Maximus_Gladiator", "Heector_RoadRunner"],
		"mobs": ["arena_champion", "wild_beast", "spectator_npc", "referee"],
		"structures": ["arena_pit", "spectator_stands", "champion_throne", "weapon_rack"],
		"sky_tint": Color(0.90, 0.80, 0.65)
	},
	BiomeType.TEMPLE_LEGENDAIRE: {
		"name_fr": "Temple Legendaire", "name_en": "Legendary Temple",
		"description": "Temple ultime ou tous les heros convergent pour l'affrontement final",
		"primary_color": Color(0.75, 0.65, 0.35),
		"secondary_color": Color(0.90, 0.80, 0.45),
		"height_range": Vector2(20, 60), "roughness": 0.5, "vegetation": 0.15,
		"fog_color": Color(0.60, 0.55, 0.40), "fog_density": 0.03,
		"music": "bgm_temple", "ambient": "amb_temple_choir",
		"temp": 0.50, "humidity": 0.40,
		"blocks": { "top": 34, "sub": 1 },
		"characters": ["Dragon_Ultime", "Tous_Legendes", "Boss_Final"],
		"mobs": ["legendary_guardian", "ancient_golem", "celestial_dragon", "void_lord"],
		"structures": ["ultimate_altar", "hero_hall", "dragon_throne", "cosmic_portal"],
		"sky_tint": Color(0.85, 0.75, 0.55)
	}
}

## Retourne les donnees d'un biome
func get_biome_data(biome_type: BiomeType) -> Dictionary:
	return BIOME_DATA.get(biome_type, {})

## Retourne le biome a une position donnee (bruit de Perlin simplifie)
func get_biome_at_position(world_pos: Vector2) -> BiomeType:
	var temp: float = _noise(world_pos.x * 0.002, world_pos.y * 0.002, 0.0)
	var humidity: float = _noise(world_pos.x * 0.002, world_pos.y * 0.002, 100.0)
	return _classify_biome(temp, humidity)

## Classifie un biome selon temperature et humidite
func _classify_biome(temp: float, humidity: float) -> BiomeType:
	if temp > 0.85:
		return BiomeType.VOLCAN_INFERNALE
	elif temp > 0.70:
		return BiomeType.DESERT_MYTHIQUE
	elif temp < 0.15:
		return BiomeType.GLAISE_ET_AURORA
	elif humidity > 0.85:
		return BiomeType.OCEAN_PROFOND
	elif humidity < 0.15:
		return BiomeType.FORTERESSE_MECA
	elif temp > 0.55 and humidity > 0.55:
		return BiomeType.FORET_ENCHANTEE
	elif temp > 0.45 and humidity < 0.35:
		return BiomeType.ARENE_DE_COMBAT
	elif temp < 0.30 and humidity < 0.35:
		return BiomeType.ROYAUME_DES_OMBRES
	elif temp > 0.60 and humidity > 0.30 and humidity < 0.50:
		return BiomeType.CITE_DOR
	elif temp > 0.40 and temp < 0.60 and humidity > 0.50 and humidity < 0.70:
		return BiomeType.RUINES_ANCIENNES
	elif temp > 0.30 and temp < 0.50 and humidity > 0.55:
		return BiomeType.ISLES_DU_CIEL
	elif temp > 0.25 and temp < 0.40 and humidity > 0.40 and humidity < 0.55:
		return BiomeType.CRISTALLINE_CAVERNE
	elif temp > 0.45 and temp < 0.65 and humidity > 0.40 and humidity < 0.60:
		return BiomeType.VILLAGE_COLONIE
	elif temp > 0.40 and temp < 0.60 and humidity > 0.50 and humidity < 0.65:
		return BiomeType.DIMENSION_MAGIQUE
	else:
		return BiomeType.TEMPLE_LEGENDAIRE

## Bruit simplifie (hash base)
func _noise(x: float, y: float, seed: float) -> float:
	var n: float = sin(x * 12.9898 + y * 78.233 + seed) * 43758.5453
	return fmod(n, 1.0) * 2.0 - 1.0

## Retourne un biome aleatoire
func get_random_biome() -> BiomeType:
	return BiomeType.values()[randi() % BiomeType.size()]

## Retourne les biomes associes a un personnage
func get_biomes_for_character(character_name: String) -> Array:
	var result: Array = []
	for biome_type in BiomeType.values():
		var data: Dictionary = BIOME_DATA.get(biome_type, {})
		var chars: Array = data.get("characters", [])
		if character_name in chars:
			result.append(biome_type)
	return result

## Retourne le nom lisible d'un biome
func get_biome_name(biome_type: BiomeType) -> String:
	var data: Dictionary = BIOME_DATA.get(biome_type, {})
	return data.get("name_fr", "Inconnu")

## Retourne tous les biomes sous forme de dictionnaire nom -> type
func get_all_biomes() -> Dictionary:
	var result: Dictionary = {}
	for biome_type in BiomeType.values():
		result[get_biome_name(biome_type)] = biome_type
	return result
