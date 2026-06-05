# Test.gd
extends Node

func _ready() -> void:
    var scripts = [
        "res://scripts/biome_generator.gd",
        "res://scripts/block_types.gd",
        "res://scripts/biome_registry.gd",
        "res://scripts/world_config.gd"
    ]
    var all_good = true
    for script_path in scripts:
        var res = load(script_path)
        if res == null:
            push_error("FAILED to load script: " + script_path)
            all_good = false
        else:
            print("OK: Loaded script: " + script_path)
    if all_good:
        print("All scripts loaded successfully.")
    else:
        print("Some scripts failed to load.")
    # Quit after a moment to allow output to be flushed
    yield(get_tree().create_timer(0.5), "timeout")
    get_tree().quit()
