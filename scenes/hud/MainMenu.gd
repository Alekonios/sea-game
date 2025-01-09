extends Control

@export var Enter_Ip : LineEdit
@onready var new_game_menu = %New_Game_Menu


const PORT = 1488
var enet_peer = ENetMultiplayerPeer.new()

var scene = get_node

func _on_hostbutton_pressed() -> void:
	new_game_menu.show()
	
func _on_joinbutton_pressed() -> void:
	enet_peer.create_client(Enter_Ip.text, PORT)
	multiplayer.multiplayer_peer = enet_peer
	get_tree().change_scene_to_file("res://scenes/locations/test/test.tscn")

func _on_new_game_pressed() -> void:
	enet_peer.create_server(PORT, 2)
	multiplayer.multiplayer_peer = enet_peer
	get_tree().change_scene_to_file("res://scenes/locations/test/test.tscn")

func _on_load_game_pressed() -> void:
	enet_peer.create_server(PORT, 2)
	multiplayer.multiplayer_peer = enet_peer
	get_tree().change_scene_to_file("res://scenes/locations/test/test.tscn")


	
