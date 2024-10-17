
extends Node

var config_file = ConfigFile
var file_dir = "user://config.ini"

@export var SaveCube : Node3D


func _ready() -> void:
	config_file = ConfigFile.new()
	if FileAccess.file_exists(file_dir):
		config_file.load(file_dir)
	else:
		config_file.save(file_dir)
		
func set_key(section: String, key: String, value: Variant):
	config_file.set_value(section, key, value)
	config_file.save(file_dir)
	
func get_key(section: String, key: String):
	if config_file.has_section(section) and config_file.has_section_key(section, key):
		return config_file.get_value(section, key)
	else:
		return null
		
func save_cube_func():
	var cube_pos = SaveCube.global_position
	var cube_rot = SaveCube.global_rotation
	set_key("Objects", "Cube", cube_pos)
func load_cube_func():
	var a = get_key("Objects", "Cube")
	SaveCube.global_position = a
