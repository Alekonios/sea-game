extends Node3D

var player_camera
var player

var want_activation = false
var have_order = false
var order_player 
var rotate_speed = 0.0

@export var ship : SHIP

@onready var camera = $Camera3D



func _on_shturval_collision_area_entered(area: Area3D) -> void:
	if !want_activation:
		player_camera = area.get_parent().camera_cur
		player = area.get_parent()
		want_activation = true

func activation():
	if !have_order:
		if multiplayer.get_unique_id() != order_player:
			order_player = multiplayer.get_unique_id()
			_activation.rpc(order_player)

@rpc("any_peer", "reliable", "call_local")
func _activation(a):
	if want_activation and !have_order:
		have_order = true
		want_activation = false
		if multiplayer.get_unique_id() == a:
			camera.current = true
			player.block = true
			
func _process(delta: float) -> void:
	management(delta)

func management(delta):
	if multiplayer.get_unique_id() == order_player and ship.state == ship.States.Swim:
		if Input.is_action_pressed("left"):
			right.rpc(delta)
		elif Input.is_action_pressed("right"):
			left.rpc(delta)
		elif !Input.is_action_pressed("right") and !Input.is_action_pressed("left"):
			none.rpc(delta)
@rpc("any_peer", "reliable", "call_local")
func right(delta):
	rotate_speed = lerp(rotate_speed, 0.01, 0.2)
	ship.global_rotation.y -= rotate_speed
	
@rpc("any_peer", "reliable", "call_local")
func left(delta):
	rotate_speed = lerp(rotate_speed, 0.01, 0.2)
	ship.global_rotation.y += rotate_speed

@rpc("any_peer", "reliable", "call_local")
func none(delta):
	rotate_speed = lerp(rotate_speed, 0.0, 0.2)
