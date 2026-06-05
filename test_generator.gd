#!/usr/bin/env godot

extends Node

func _ready() -> void:
    print("Testing BiomeGenerator load...")
    var generator = BiomeGenerator.new()
    print("BiomeGenerator loaded successfully!")
    generator.world_seed = 12345
    generator._ready()
    print("Noise initialized.")
    var chunk = generator.generate_chunk(Vector2i(0, 0))
    if chunk:
        print("Chunk generated at (0,0) with ", chunk.get_child_count(), " children.")
    else:
        print("Chunk generation returned null.")
    get_tree().quit()