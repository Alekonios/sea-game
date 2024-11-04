extends Node

@export var spawn_point : Marker3D

@onready var main_menu = $".."
@onready var new_game_menu = $"../New_Game_Menu"
@onready var address_entry = $"../VBoxContainer/adres"

var enet_peer = ENetMultiplayerPeer.new()

const Player = preload("res://scenes/charapters/players/Charapter.tscn")
const PORT = 1200

func add_player(peer_id):
	var player = Player.instantiate()
	player.name = str(peer_id)
	self.get_parent().get_parent().add_child(player)
	player.global_position = spawn_point.global_position

func remove_player(peer_id):
	var player = get_node_or_null(str(peer_id))
	if player:
		player.queue_free()

func _on_hostbutton_pressed():
	new_game_menu.show()


func _on_joinbutton_pressed() -> void:
	main_menu.hide()
	enet_peer.create_client(address_entry.text, PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	add_player(multiplayer.get_unique_id())

func _on_new_game_pressed() -> void:
	main_menu.hide()
	enet_peer.create_server(PORT, 2)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	add_player(multiplayer.get_unique_id())


func _on_load_game_pressed() -> void:
	main_menu.hide()
	enet_peer.create_server(PORT, 2)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	add_player(multiplayer.get_unique_id())
	SaveSingleTon.load_cube_func()
