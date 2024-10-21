extends StaticBody3D

@export var pathfollow : PathFollow3D

var sender = null
var have_order = false
var order = false

var movement = false



@rpc("any_peer", "call_local", "reliable")
func activation(_sender):
	if !sender:
		sender = get_tree().root.get_node(_sender)
		if !movement:
			movement = true
		elif movement:
			movement = false

func _process(delta: float) -> void:
	ride_sync()


func ride_sync():
	ride.rpc()

@rpc("any_peer", "call_local", "reliable")
func ride():
	if sender:
		if movement:
			pathfollow.progress_ratio -= 0.01
			sender.global_position = pathfollow.global_position
			sender.velocity.y = 0.0
			if pathfollow.progress_ratio == 0:
				sender = null
		if !movement:
			pathfollow.progress_ratio += 0.01
			sender.global_position = pathfollow.global_position
			sender.velocity.y = 0.0
			if pathfollow.progress_ratio == 1:
				sender = null
