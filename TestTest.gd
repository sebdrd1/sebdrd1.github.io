extends Node

func _ready() -> void:
    print("Testing BiomeGenerator...")
    var generator = BiomeGenerator.new()
    print("BiomeGenerator instance created.")
    generator.world_seed = 12345
    generator.chunk_size = 16
    generator.max_height = 64
    generator.sea_level = 20
    generator.render_distance = 8
    generator._ready()  # Initialize noise
    print("Noise initialized.")
    var chunk = generator.generate_chunk(0, 0)
    if chunk:
        print("Chunk generated successfully at (0,0).")
        print("Chunk has ", chunk.get_child_count(), " children.")
    else:
        print("Chunk generation returned null.")
    get_tree().quit()