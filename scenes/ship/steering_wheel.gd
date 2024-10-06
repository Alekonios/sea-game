extends Node3D

var player
var area_player = []

var order_player 
var rotate_speed = 0.0

var sender


@export var ship : SHIP
@export var shturval_mesh : Node3D

@onready var camera = $Camera3D




#функция, которая на прямую связана с хитбоксом, для запоминания игрока. который управляет короблем
@rpc("any_peer", "call_local", "reliable")
func activation(_sender):
	if !order_player:
		sender = _sender
		print(multiplayer.get_remote_sender_id())
		order_player = multiplayer.get_remote_sender_id()
		if multiplayer.get_remote_sender_id() == order_player:
			if sender is CharacterBody3D:
				sender.block = true
				print("игрок" + str(order_player) + "начал управлять штурвалом")

#управление и проверка на нажатие кнопки для выхода
func _process(delta: float) -> void:
	management(delta)
	if Input.is_action_just_pressed("back_ui"):
		#отсылает на не на рпс функцию, т.к в процессе это вызвает баги
		back_r()
		
		
func back_r():
	back.rpc()

#выход из режима управления
@rpc("any_peer", "call_local", "reliable")
func back():
	if order_player:
		if multiplayer.get_remote_sender_id() == order_player:
			if sender is CharacterBody3D:
				order_player = null
				sender.not_block()
				sender = null

func management(delta):
	if multiplayer.get_unique_id() == order_player and ship.state == ship.States.Swim:
		if Input.is_action_pressed("left"):
			right.rpc(delta)
		elif Input.is_action_pressed("right"):
			left.rpc(delta)
		elif !Input.is_action_pressed("right") and !Input.is_action_pressed("left"):
			none.rpc(delta)
@rpc("any_peer", "reliable", "call_local")
func right(delta):
	rotate_speed = lerp(rotate_speed, 0.2, 0.01)
	ship.angular_velocity.y = rotate_speed
	shturval_mesh.rotation.x += rotate_speed / 10
	
@rpc("any_peer", "reliable", "call_local")
func left(delta):
	rotate_speed = lerp(rotate_speed, -0.2, 0.01)
	ship.angular_velocity.y = rotate_speed
	shturval_mesh.rotation.x += rotate_speed / 10

@rpc("any_peer", "reliable", "call_local")
func none(delta):
	rotate_speed = lerp(rotate_speed, 0.0, 0.01)
