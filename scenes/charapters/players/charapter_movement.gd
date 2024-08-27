class_name Movement

extends CharacterBody3D

var SPEED = 5.0
const JUMP_VELOCITY = 4.5

var block = false
var mouse_sens = 0.1

var run = false

@export var target_position : Vector3
@export var target_rotation : Vector3

@export var _SoundComponent : SoundComponent
@export var _StateMacine : StateMacine

@export var camera : Node3D
@export var camera_cur = Camera3D

@onready var player_meshes = [$Shroom_main_5/Armature_001/Cube_003, $Shroom_main_5/Armature_001/Skeleton3D/Cube_001, $Shroom_main_5/Armature_001/Skeleton3D/Cube_002, $Shroom_main_5/Armature_001/Skeleton3D/Cube_005, $Shroom_main_5/Armature_001/Skeleton3D/Cube_006, $Shroom_main_5/Armature_001/Skeleton3D/Cube_007, $Shroom_main_5/Armature_001/Skeleton3D/Cube_008, $Shroom_main_5/Armature_001/Skeleton3D/Cube_009, $Shroom_main_5/Armature_001/Skeleton3D/Cube_199]

func _enter_tree() -> void:
	set_multiplayer_authority(str(name).to_int())

func _ready() -> void:
	$Shroom_main_5/Armature_001/Skeleton3D/SkeletonIK3D.start()
	hide_ob()
	if not is_multiplayer_authority(): return
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	camera_cur.current = is_multiplayer_authority()

func _physics_process(delta: float) -> void:
	
	if is_multiplayer_authority():
		target_position = global_position
		target_rotation = global_rotation
	else:
		global_position = global_position.lerp(target_position, delta * 15)
		global_rotation.y = lerp_angle(global_rotation.y, target_rotation.y, delta * 15)
	
	if !is_multiplayer_authority(): return
	
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
	if direction and !block:
		velocity.x = lerp(velocity.x, direction.x * SPEED, delta * 10)
		velocity.z = lerp(velocity.z, direction.z * SPEED, delta * 10)
		if run:
			SPEED = 6.0
			_StateMacine.state = _StateMacine.States.Run
			_SoundComponent.checkplace(0.2)
		else:
			SPEED = 3.0
			_StateMacine.state = _StateMacine.States.Walk
			_SoundComponent.checkplace(0.35)
	elif !direction and !block:
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
		
func hide_ob():
	if is_multiplayer_authority():
		for i in player_meshes:
			i.transparency = 1
