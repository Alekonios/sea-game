extends Node3D

var player_camera
var player
var want_activation = false

var have_order = false

@onready var camera = $Camera3D

func _on_shturval_collision_area_entered(area: Area3D) -> void:
	player_camera = area.get_parent().camera_cur
	player = area.get_parent()
	want_activation = true
	
func activation():
	var a = multiplayer.get_unique_id()
	_activation.rpc(a)
		
		

@rpc("any_peer", "reliable", "call_local")
func _activation(a):
	if want_activation and !have_order:
		have_order = true
		if multiplayer.get_unique_id() == a:
			camera.current = true
			player.block = true
