class_name SHIP

extends RigidBody3D

@export var float_force := 1.0
@export var water_drag := 0.05
@export var water_angular_drag := 0.05

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var water = get_node('/root/Node3D/Water')
@onready var probes = $ProbeContainer.get_children()

@onready var pos

var SPEED = 0.0
var stoped = false

enum States {Idle, Swim}

@export var state : States = States.Idle

var submerged := false

func _physics_process(delta):
	moving()
	
func moving():
	submerged = false
	for p in probes:
		var depth = water.get_height(p.global_position) - p.global_position.y 
		if depth > 0:
			submerged = true
			apply_force(Vector3.UP * float_force * gravity * depth, p.global_position - global_position)
			
	match state:
		States.Idle:
			SPEED = lerp(SPEED, 0.0, 1)
		States.Swim:
			SPEED = lerp(SPEED, 2.0, 1)
	var forward_direction = Vector3(0, 0, -1).rotated(Vector3.UP, rotation.y)
	forward_direction = forward_direction.normalized()
	
	if !stoped:
		linear_velocity.x = forward_direction.x * SPEED 
		linear_velocity.z = forward_direction.z * SPEED
		
func _integrate_forces(state: PhysicsDirectBodyState3D):
	if submerged:
		state.linear_velocity *=  1 - water_drag
		state.angular_velocity *= 1 - water_angular_drag 
	
