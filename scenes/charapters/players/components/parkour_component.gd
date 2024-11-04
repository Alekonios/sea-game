class_name ParkourComponent

extends Node3D

@onready var collider = %Parkour_collider


@onready var hands_node = [%left_hand_NODE, %right_hand_NODE]
@onready var IK_hands = [%left_hand_IK, %right_hand_IK]

@export var player : Movement

func _process(delta: float) -> void:
	hook_on_climbing_stone()

func hook_on_climbing_stone():
	if collider.is_colliding() and collider.get_collider() is Hitbox:
		if collider.get_collider().get_parent()._name == "climbing_stone":
			for i in hands_node:
				i.global_position = collider.get_collider().get_parent().hook_marker.global_position
			for i in IK_hands:
				i.start()
			player.handing = true
			if Input.is_action_pressed("ui_accept"):
				player.velocity.y = 5.0
			else :
				player.velocity.y = 0.0
	else:
		await get_tree().create_timer(0.1, false).timeout
		player.handing = false
		for i in IK_hands:
			i.stop()
