extends Control

@onready var create_lobby_but = %"create-lobby"
@onready var join_lobby_but = %"join-lobby"
@onready var enter_host_ip_line =  %Enter_Host_Ip

@onready var lobby_node = $lobby

var have_lobby = false

var EnetPeer = ENetMultiplayerPeer.new()
const Player = preload("res://scenes/charapters/players/Charapter.tscn")
const PORT = 1200





func _on_joinlobby_pressed() -> void:
	print(enter_host_ip_line.text)
	if enter_host_ip_line.text == "":
		%Enter_host_ip_label.show()

func _on_createlobby_pressed() -> void:
	EnetPeer.create_server(PORT, 2)
	lobby_node.show()
	multiplayer.multiplayer_peer = EnetPeer
	$lobby/player_one.text = str(multiplayer.multiplayer_peer)
