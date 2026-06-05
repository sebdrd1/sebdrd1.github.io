# Main.gd
extends Node3D

func _ready() -> void:
    print("Starting Realm of Legends test...")
    var generator = BiomeGenerator.new()
    generator.world_seed = 12345
    generator.chunk_size = 16
    generator.max_height = 64
    generator.sea_level = 20
    generator.render_distance = 8
    # Initialize noise
    generator._ready()
    print("BiomeGenerator initialized.")
    # Generate a chunk at (0,0)
    var chunk = generator.generate_chunk(0, 0)
    if chunk:
        print("Chunk generated successfully:", chunk)
        print("Chunk children count:", chunk.get_child_count())
        # Add the chunk to the scene so it appears in the view
        add_child(chunk)
    else:
        print("Failed to generate chunk")
    # Quit after 3 seconds to allow viewing output
    get_tree().create_timer(3.0).timeout.connect(func():
        get_tree().quit()
    )
