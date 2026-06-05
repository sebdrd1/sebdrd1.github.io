
# SyntaxCheck.gd
# This script checks if the project scripts can be loaded without syntax errors.
func _ready() -> void:
    var scripts = [
        "res://scripts/biome_generator.gd",
        "res://scripts/block_types.gd",
        "res://scripts/biome_registry.gd",
        "res://scripts/world_config.gd"
    ]
    for script_path in scripts:
        var res = load(script_path)
        if res == null:
            push_error("Failed to load script: " + script_path)
        else:
            print("Loaded successfully: " + script_path)
    # Quit after checking
    get_tree().quit()
