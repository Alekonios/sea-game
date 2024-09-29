class_name SHIP

extends RigidBody3D

@export var target_position : Vector3
@export var target_rotation : Vector3
@export var targer_angular_velocity : Vector3
@export var targer_linear_velocity : Vector3

@export var float_force := 1.0
@export var water_drag := 0.05
@export var water_angular_drag := 0.05

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var water = get_node('/root/Node3D/Water')
@onready var probes = $ProbeContainer.get_children()
@onready var enter_hold_area: Area3D = $EnterHoldArea

var player = false

@onready var pos

var SPEED = 0.0
var stoped = false

enum States {Idle, Swim}

@export var state : States = States.Idle

var submerged := false

func _ready() -> void:
	enter_hold_area.body_entered.connect(enter_hold_area_entered)

func sync(delta):
	if multiplayer.is_server():
		target_position = global_position
		target_rotation = global_rotation

	else:
		global_position = global_position.lerp(target_position, delta * 3)
		global_rotation.y = lerp_angle(global_rotation.y, target_rotation.y, delta * 8)

func _physics_process(delta):
	sync(delta)
	moving(delta)
	var forward_direction = Vector3(0, 0, -1).rotated(Vector3.UP, global_rotation.y)
	forward_direction = forward_direction.normalized()
	linear_velocity.x = forward_direction.x * SPEED * delta * 50
	linear_velocity.z = forward_direction.z * SPEED * delta * 50

func moving(delta):
	submerged = false
	for p in probes:
		var depth = water.get_height(p.global_position) - p.global_position.y 
		if depth > 0:
			submerged = true
			apply_force(Vector3.UP * float_force * gravity * depth, p.global_position - global_position)
	match state:
		States.Idle:
			SPEED = lerp(SPEED, 0.0, 0.2)
		States.Swim:
			SPEED = lerp(SPEED, 5.0, 0.2)

func _integrate_forces(state: PhysicsDirectBodyState3D):
	if submerged:
		state.linear_velocity *=  1 - water_drag
		state.angular_velocity *= 1 - water_angular_drag 

func _on_apply_vel_player_area_entered(area: Area3D) -> void:
	player = area.get_parent()

func enter_hold_area_entered(body: Node3D) -> void: #Абстракция для тестировки
	if !(body is Movement): # TODO добавить вместо Area3D анимацию или что-то вроде того
		return

	var water_level: int = 2
	invert_water_draw(body, water_level)

func invert_water_draw(player: CharacterBody3D, water_layer: int) -> void: #Функция для инвертирования слоя отрисовки
	var current_mask_value: bool = player.camera_cur.get_cull_mask_value(water_layer) #По хорошему игрок должен быть в
	player.camera_cur.set_cull_mask_value(water_layer, !current_mask_value) #системе
