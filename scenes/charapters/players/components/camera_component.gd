class_name CameraComponent

extends Node

@export var player : CharacterBody3D

@export var camera_node : Node3D
var mouse_sens = 0.05


func _input(event):
	if !is_multiplayer_authority(): return
	if event is InputEventMouseMotion:
		player.rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
		camera_node.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
		camera_node.rotation.x = clamp(camera_node.rotation.x, deg_to_rad(-70), deg_to_rad(90))
