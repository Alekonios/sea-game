extends Control

@onready var control = $"."

const player = preload("res://scenes/charapters/players/Charapter.tscn")
const port = 9999

var enet_peer = ENetMultiplayerPeer.new()


func _on_hostbutton_pressed() -> void:
	control.hide()
	enet_peer.create_server(port)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	add_player(multiplayer.get_unique_id())


func _on_joinbutton_pressed() -> void:
	control.hide()
	enet_peer.create_client("localhost", port)
	multiplayer.multiplayer_peer = enet_peer
	
func add_player(peer_id):
	var _player = player.instantiate()
	_player.name = str(peer_id)
	add_child(_player)
