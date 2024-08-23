class_name  InteractionComponent

extends Node

@onready var interaction_collider = $"../../camera_node/Camera3D/Interaction_Raycast"

func _process(delta: float) -> void:
	if interaction_collider.is_colliding() and interaction_collider.get_collider() is Hitbox:
		if Input.is_action_just_pressed("use"):
			interaction_collider.get_collider().activation()
