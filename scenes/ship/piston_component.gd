extends Node3D


@export var ship : SHIP

func activation():
	_activation.rpc()


@rpc("any_peer", "call_local")
func _activation():
	if ship.state == ship.States.Idle:
		ship.state = ship.States.Swim
	elif ship.state == ship.States.Swim:
		ship.state = ship.States.Idle
