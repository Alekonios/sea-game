extends Node3D

var player

func _on_penis_area_area_entered(area: Area3D) -> void:
	player = area.get_parent()
	player.interact.connect(on_player_interacted)

func _on_penis_area_area_exited(area: Area3D) -> void:
	player.interact.disconnect(on_player_interacted)
	player = null
	


@rpc("any_peer", "call_local")
func showw():
	if player:
		player.PENIS_VIS()
		
func on_player_interacted():
	showw.rpc()
