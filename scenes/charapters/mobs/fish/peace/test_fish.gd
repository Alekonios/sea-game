extends CharacterBody3D

@export var float_force := 1.0
@export var water_drag := 0.05
@export var water_angular_drag := 0.05

var speed = 5.0
var jump_vel = 1.0

@export var _main_pos : Vector3
@export var _position : Vector3
@export var _rotation : Vector3

@export var target : Vector3
@onready var navagent = $NavigationAgent3D

enum States {Idle, Swim, FastSwim, Jump, Scary}

@export var state = States.Idle

@export var directions : Array[Node3D]

@onready var rigid_body = $Fish

@onready var water = get_node('/root/Node3D/Water')
@onready var probes = $Fish/ProbeContainer.get_children()

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	get_random_direction.rpc()

func _physics_process(delta: float) -> void:
	if multiplayer.is_server():
		_position = rigid_body.global_position
		_rotation = rigid_body.global_rotation
		_main_pos = global_position
	else :
		rigid_body.global_position = lerp(rigid_body.global_position, _position, delta * 8)
		global_position = lerp(global_position, _main_pos, delta * 8)
		rigid_body.global_rotation.y = lerp_angle(rigid_body.global_rotation.y, _rotation.y, delta * 8)
		rigid_body.global_rotation.x = lerp_angle(rigid_body.global_rotation.x, _rotation.x, delta * 8)
		rigid_body.global_rotation.z = lerp_angle(rigid_body.global_rotation.z, _rotation.z, delta * 8)
	
	velocity = Vector3.ZERO
	var pos = global_position
	
	match state:
		States.Swim:
			navagent.set_target_position(target)
			var next_pos = navagent.get_next_path_position()
			velocity  = (next_pos - global_transform.origin).normalized() * speed
			_look_at()
			$Fish/AnimationPlayer.play("ArmatureAction")
		States.Idle:
			target = Vector3(0, 0, 0)
			velocity = Vector3(0, 0, 0)
	move_and_slide()
			
	
	if target:
		state = States.Swim

func _process(delta: float) -> void:
	for p in probes:
		var depth = water.get_height(p.global_position) - p.global_position.y 
		if depth > 0:
			rigid_body.apply_force(Vector3.UP * float_force * gravity * depth * 0.05, p.global_position - rigid_body.global_position)

func _look_at():
	var a = Quaternion(rigid_body.transform.basis)
	var po = target
	po.y = rigid_body.transform.origin.y
	var b = Quaternion(rigid_body.transform.looking_at(po, Vector3.UP).basis)
	var c = a.slerp(b, 0.2)
	rigid_body.transform.basis = Basis(c)

@rpc("any_peer", "call_local", "reliable")
func get_random_direction():
	var ramdom_choice = randi_range(-5, 5)
	var random_index = randi() % directions.size()
	target = directions[random_index].global_position * ramdom_choice * 10
	state = States.Swim
	


func _on_timer_timeout() -> void:
	get_random_direction.rpc()
