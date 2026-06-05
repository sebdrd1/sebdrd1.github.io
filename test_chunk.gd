# Test chunk generation by preloading dependencies

# Preload the dependencies first
const BlockTypes = preload("res://scripts/block_types.gd")
const BiomeRegistry = preload("res://scripts/biome_registry.gd")
# Now we can preload the biome generator
const BiomeGenerator = preload("res://scripts/biome_generator.gd")

func _ready() -> void:
    print("Starting chunk generation test...")
    try:
        var generator = BiomeGenerator.new()
        print("BiomeGenerator instantiated successfully.")
        
        generator.world_seed = 12345
        generator.chunk_size = 16
        generator.max_height = 64
        generator.sea_level = 20
        generator.render_distance = 8
        
        # Initialize noise (call _ready on the generator)
        generator._ready()
        print("Noise system initialized.")
        
        # Generate a chunk at (0,0)
        var chunk = generator.generate_chunk(0, 0)
        if chunk:
            print("SUCCESS: Chunk generated at (0,0)")
            print("Chunk has ", chunk.get_child_count(), " child nodes.")
            
            # Count the mesh instances (should be 1 if mesh was built)
            var mesh_instances = 0
            for child in chunk.get_children():
                if child.get_class() == "MeshInstance3D":
                    mesh_instances += 1
            print("MeshInstance3D count: ", mesh_instances)
        else:
            print("ERROR: generate_chunk returned null")
    except Exception as e:
        print("ERROR: ", e)
        print("Stack trace: ", get_stack())
    finally:
        # Quit after 2 seconds to allow output to be seen
        get_tree().create_timer(2.0).timeout.connect(func():
            get_tree().quit()
        )