class_name Movement

extends CharacterBody3D


var SPEED = 5.0
const JUMP_VELOCITY = 4.5

var block = false
var mouse_sens = 0.1

var run = false

@export var _StateMacine : StateMacine

@export var camera : Node3D
@export var camera_cur = Camera3D

func _enter_tree() -> void:
	set_multiplayer_authority(str(name).to_int())

func _ready() -> void:
	if not is_multiplayer_authority(): return
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	camera_cur.current = is_multiplayer_authority()

func _physics_process(delta: float) -> void:
	print(camera_cur)
	if not is_multiplayer_authority(): return
	
	if not is_on_floor():
		velocity += get_gravity() * 2 * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_pressed("run") and Input.is_action_pressed("forward"):
		run = true
	else:
		run = false
		

	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED * delta * 60
		velocity.z = direction.z * SPEED * delta * 60
		if run:
			SPEED = 6.0
			_StateMacine.state = _StateMacine.States.Run
		else:
			SPEED = 3.0
			_StateMacine.state = _StateMacine.States.Walk
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		_StateMacine.state = _StateMacine.States.Idle

	move_and_slide()
	
func _input(event):
	if not is_multiplayer_authority(): return
	
	if event is InputEventMouseMotion and !block:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
		camera.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-70), deg_to_rad(90))
