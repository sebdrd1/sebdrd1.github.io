## block_types.gd
## Definition de tous les types de blocs voxel - Godot 4.6.2
@tool
class_name BlockTypes
extends Node

enum BlockType {
	AIR, STONE, DIRT, GRASS, SAND, SANDSTONE,
	OBSIDIAN, ICE, SNOW, MUD, GRAVEL, CLAY,
	ORE_IRON, ORE_GOLD, ORE_DIAMOND, ORE_EMERALD, ORE_RUBY, ORE_SAPPHIRE,
	CRYSTAL, LAVA, WATER, BEDROCK,
	LOG_OAK, LOG_BIRCH, LOG_PALM, LOG_CRYSTAL, WOOD,
	LEAVES_GREEN, LEAVES_AUTUMN, LEAVES_CRYSTAL,
	GLOWSTONE, MAGIC_STONE, SHADOW_STONE, THUNDER_STONE,
	COPPER_BLOCK, MARBLE, DARK_STONE, VOLCANIC_ROCK, CORAL,
	MECHA_METAL, MECHA_PLATING, GOLD_BLOCK,
	MUSHROOM_RED, MUSHROOM_GLOW,
	FLOWER_RED, FLOWER_BLUE, FLOWER_YELLOW
}

const BLOCK_COLORS: Dictionary = {
	BlockType.AIR: Color(0, 0, 0, 0),
	BlockType.STONE: Color(0.50, 0.50, 0.50),
	BlockType.DIRT: Color(0.55, 0.38, 0.22),
	BlockType.GRASS: Color(0.20, 0.60, 0.20),
	BlockType.SAND: Color(0.88, 0.80, 0.50),
	BlockType.SANDSTONE: Color(0.80, 0.72, 0.45),
	BlockType.OBSIDIAN: Color(0.08, 0.05, 0.12),
	BlockType.ICE: Color(0.65, 0.82, 0.95),
	BlockType.SNOW: Color(0.95, 0.95, 0.98),
	BlockType.MUD: Color(0.35, 0.25, 0.15),
	BlockType.GRAVEL: Color(0.55, 0.52, 0.50),
	BlockType.CLAY: Color(0.60, 0.55, 0.50),
	BlockType.ORE_IRON: Color(0.52, 0.48, 0.45),
	BlockType.ORE_GOLD: Color(0.85, 0.72, 0.20),
	BlockType.ORE_DIAMOND: Color(0.45, 0.85, 0.90),
	BlockType.ORE_EMERALD: Color(0.20, 0.75, 0.35),
	BlockType.ORE_RUBY: Color(0.80, 0.15, 0.15),
	BlockType.ORE_SAPPHIRE: Color(0.15, 0.25, 0.75),
	BlockType.CRYSTAL: Color(0.60, 0.40, 0.80),
	BlockType.LAVA: Color(0.90, 0.30, 0.05),
	BlockType.WATER: Color(0.15, 0.35, 0.70, 0.6),
	BlockType.BEDROCK: Color(0.20, 0.20, 0.20),
	BlockType.LOG_OAK: Color(0.40, 0.28, 0.15),
	BlockType.LOG_BIRCH: Color(0.80, 0.78, 0.70),
	BlockType.LOG_PALM: Color(0.55, 0.45, 0.25),
	BlockType.LOG_CRYSTAL: Color(0.50, 0.35, 0.65),
	BlockType.WOOD: Color(0.40, 0.28, 0.15),
	BlockType.LEAVES_GREEN: Color(0.15, 0.55, 0.15),
	BlockType.LEAVES_AUTUMN: Color(0.75, 0.45, 0.10),
	BlockType.LEAVES_CRYSTAL: Color(0.45, 0.30, 0.60),
	BlockType.GLOWSTONE: Color(0.90, 0.80, 0.40),
	BlockType.MAGIC_STONE: Color(0.40, 0.15, 0.60),
	BlockType.SHADOW_STONE: Color(0.10, 0.08, 0.15),
	BlockType.THUNDER_STONE: Color(0.55, 0.50, 0.65),
	BlockType.COPPER_BLOCK: Color(0.72, 0.45, 0.30),
	BlockType.MARBLE: Color(0.90, 0.88, 0.85),
	BlockType.DARK_STONE: Color(0.22, 0.20, 0.25),
	BlockType.VOLCANIC_ROCK: Color(0.30, 0.15, 0.10),
	BlockType.CORAL: Color(0.85, 0.40, 0.50),
	BlockType.MECHA_METAL: Color(0.45, 0.48, 0.52),
	BlockType.MECHA_PLATING: Color(0.55, 0.58, 0.62),
	BlockType.GOLD_BLOCK: Color(0.85, 0.72, 0.25),
	BlockType.MUSHROOM_RED: Color(0.80, 0.15, 0.10),
	BlockType.MUSHROOM_GLOW: Color(0.70, 0.85, 0.40),
	BlockType.FLOWER_RED: Color(0.85, 0.15, 0.20),
	BlockType.FLOWER_BLUE: Color(0.20, 0.40, 0.85),
	BlockType.FLOWER_YELLOW: Color(0.90, 0.80, 0.15)
}

const BLOCK_TEXTURES: Dictionary = {
	BlockType.STONE: "res://textures/blocks/stone.png",
	BlockType.DIRT: "res://textures/blocks/dirt.png",
	BlockType.GRASS: "res://textures/blocks/grass.png",
	BlockType.SAND: "res://textures/blocks/sand.png",
	BlockType.SANDSTONE: "res://textures/blocks/sandstone.png",
	BlockType.OBSIDIAN: "res://textures/blocks/obsidian.png",
	BlockType.ICE: "res://textures/blocks/ice.png",
	BlockType.SNOW: "res://textures/blocks/snow.png",
	BlockType.CRYSTAL: "res://textures/blocks/crystal.png",
	BlockType.LAVA: "res://textures/blocks/lava.png",
	BlockType.WATER: "res://textures/blocks/water.png",
	BlockType.LOG_OAK: "res://textures/blocks/log_oak.png",
	BlockType.WOOD: "res://textures/blocks/log_oak.png",
	BlockType.LEAVES_GREEN: "res://textures/blocks/leaves_green.png",
	BlockType.GLOWSTONE: "res://textures/blocks/glowstone.png",
	BlockType.MAGIC_STONE: "res://textures/blocks/magic_stone.png",
	BlockType.SHADOW_STONE: "res://textures/blocks/shadow_stone.png",
	BlockType.MECHA_METAL: "res://textures/blocks/mecha_metal.png",
	BlockType.GOLD_BLOCK: "res://textures/blocks/gold_block.png"
}

const BLOCK_NAMES_FR: Dictionary = {
	BlockType.AIR: "Air", BlockType.STONE: "Pierre",
	BlockType.DIRT: "Terre", BlockType.GRASS: "Herbe",
	BlockType.SAND: "Sable", BlockType.SANDSTONE: "Gres",
	BlockType.OBSIDIAN: "Obsidienne", BlockType.ICE: "Glace",
	BlockType.SNOW: "Neige", BlockType.MUD: "Boue",
	BlockType.CRYSTAL: "Cristal", BlockType.LAVA: "Lave",
	BlockType.WATER: "Eau", BlockType.BEDROCK: "Roche-mere",
	BlockType.LOG_OAK: "Chene", BlockType.LOG_BIRCH: "Bouleau",
	BlockType.WOOD: "Bois",
	BlockType.LEAVES_GREEN: "Feuilles vertes", BlockType.LEAVES_AUTUMN: "Feuilles d'automne",
	BlockType.GLOWSTONE: "Pierre lumineuse", BlockType.MAGIC_STONE: "Pierre magique",
	BlockType.SHADOW_STONE: "Pierre d'ombre", BlockType.MECHA_METAL: "Metal mecanique",
	BlockType.GOLD_BLOCK: "Bloc d'or", BlockType.MARBLE: "Marbre",
	BlockType.VOLCANIC_ROCK: "Roche volcanique", BlockType.CORAL: "Corail"
}

func get_block_color(block_type: BlockType) -> Color:
	return BLOCK_COLORS.get(block_type, Color(1, 0, 1))

func get_block_texture(block_type: BlockType) -> String:
	return BLOCK_TEXTURES.get(block_type, "")

func get_block_name(block_type: BlockType) -> String:
	return BLOCK_NAMES_FR.get(block_type, "Bloc inconnu")

func is_transparent(block_type: BlockType) -> bool:
	return block_type == BlockType.AIR or block_type == BlockType.WATER

func is_solid(block_type: BlockType) -> bool:
	return block_type != BlockType.AIR and block_type != BlockType.WATER and block_type != BlockType.LAVA

func get_hardness(block_type: BlockType) -> float:
	match block_type:
		BlockType.BEDROCK: return -1.0  # Indestructible
		BlockType.OBSIDIAN: return 50.0
		BlockType.STONE, BlockType.SANDSTONE: return 15.0
		BlockType.DIRT, BlockType.SAND, BlockType.GRAVEL: return 3.0
		BlockType.WOOD, BlockType.LOG_OAK: return 5.0
		BlockType.MECHA_METAL, BlockType.MECHA_PLATING: return 40.0
		BlockType.CRYSTAL, BlockType.GLOWSTONE: return 8.0
		_: return 10.0
