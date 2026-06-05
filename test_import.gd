extends Node

func _ready() -> void:
    print("Testing BiomeGenerator import...")
    try:
        var generator = BiomeGenerator.new()
        print("SUCCESS: BiomeGenerator instantiated.")
        generator.world_seed = 12345
        generator._ready()
        print("Noise initialized.")
        var chunk = generator.generate_chunk(0, 0)
        if chunk:
            print("Chunk generated at (0,0) with ", chunk.get_child_count(), " children.")
        else:
            print("Chunk generation returned null.")
    except Exception as e:
        print("ERROR: ", e)
    get_tree().quit()