class_name  InteractionComponent

extends Node

signal interact
signal use
@onready var interaction_collider = $"../../camera_node/Camera3D/Interaction_Raycast"

func _process(delta: float) -> void:
	if !is_multiplayer_authority(): return
	if interaction_collider.is_colliding() and interaction_collider.get_collider() is Hitbox:
		$"../../CanvasLayer/use".show()
		if Input.is_action_just_pressed("use"):
			interaction_collider.get_collider().activation()
			emit_signal("use")
	else:
		$"../../CanvasLayer/use".hide()
		
	if Input.is_action_just_pressed("back"):
		emit_signal("interact")
	
