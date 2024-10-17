extends Node

@onready var main_menu = $MainMenu
@onready var new_game_menu = $MainMenu/New_Game_Menu
@onready var address_entry = $MainMenu/VBoxContainer/adres

var enet_peer = ENetMultiplayerPeer.new()

const Player = preload("res://scenes/charapters/players/Charapter.tscn")
const PORT = 1200

func add_player(peer_id):
	var player = Player.instantiate()
	player.name = str(peer_id)
	add_child(player)

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
