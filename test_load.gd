# test_load.gd
extends Node
func _ready() -> void:
    var script = load("res://scripts/biome_generator.gd")
    if script:
        print("Script loaded successfully")
        var instance = script.new()
        print("Instance created:", instance)
    else:
        print("Failed to load script")
    get_tree().quit()
