class_name SHIP

extends RigidBody3D
@export var target_position : Vector3
@export var target_rotation_y : Vector3
@export var target_rotation_x : Vector3
@export var target_rotation_z : Vector3


@export var float_force := 1.0
@export var water_drag := 0.05
@export var water_angular_drag := 0.05

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var water = get_node('/root/Node3D/Water')
@onready var probes = $ProbeContainer.get_children()

var player = false

@onready var pos

var SPEED = 0.0
var stoped = false

enum States {Idle, Swim}

@export var state : States = States.Idle

var submerged := false

func sync(delta):
	if multiplayer.is_server():
		target_position = global_position
		target_rotation_y = global_rotation
		target_rotation_x = global_rotation
		target_rotation_z = global_rotation
		
	else:
		global_position = global_position.lerp(target_position, delta * 15)
		global_rotation.y = lerp_angle(global_rotation.y, target_rotation_y.y, delta * 15)
		global_rotation.x = lerp_angle(global_rotation.x, target_rotation_x.x, delta * 15)
		global_rotation.z = lerp_angle(global_rotation.z, target_rotation_z.z, delta * 15)
		
func _physics_process(delta):
	sync(delta)
	moving(delta)
	var forward_direction = Vector3(0, 0, -1).rotated(Vector3.UP, global_rotation.y)
	forward_direction = forward_direction.normalized()
	linear_velocity.x = forward_direction.x * SPEED * delta * 50
	linear_velocity.z = forward_direction.z * SPEED * delta * 50
	print(linear_velocity)
	
	

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
