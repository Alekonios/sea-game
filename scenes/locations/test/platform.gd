extends MeshInstance3D

var ahj = false

func _process(delta: float) -> void:
	if !is_multiplayer_authority(): return
	up_down.rpc()
	
@rpc("any_peer", "call_local", "reliable")
func up_down():
	if !ahj:
		for i in range(10):
			self.global_position.y += 0.005
		await get_tree().create_timer(1, false).timeout
		ahj = true
	elif ahj:
		for i in range(10):
			self.global_position.y -= 0.005
		await get_tree().create_timer(1, false).timeout
		ahj = false
		
		
	


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		ab.rpc(body)
		
@rpc("any_peer", "call_local", "reliable")
func ab(body):
	body.reparent($".")
