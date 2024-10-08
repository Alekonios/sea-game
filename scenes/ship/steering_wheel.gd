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
func activation(_sender_path):
	if !order_player:
		var _sender = get_tree().root.get_node(_sender_path)
		sender = _sender
		order_player = multiplayer.get_remote_sender_id()
		print("первая ступень активации - " + str(order_player))
		if multiplayer.get_remote_sender_id() == order_player:
			print("вторая ступень активации" + str(sender))
			if sender is Movement:
				sender.block = true
				print("третья ступень активации")
				print("игрок"  + str(order_player) + "начал управлять штурвалом")

#управление и проверка на нажатие кнопки для выхода
func _process(delta: float) -> void:
	management(delta)
	if Input.is_action_just_pressed("back_ui"):
		#отсылает на не на рпс функцию, т.к в процессе это вызвает баги
		back.rpc()

#выход из режима управления
@rpc("any_peer", "call_local", "reliable")
func back():
	if order_player:
		if multiplayer.get_remote_sender_id() == order_player:
			if sender is CharacterBody3D:
				print("игрок" + " " + str(order_player) + "перестал управлять кораблем")
				sender.not_block()
				sender = null
				order_player = null
				

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
