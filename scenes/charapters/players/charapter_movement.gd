class_name Movement

extends CharacterBody3D

var SPEED = 5.0
const JUMP_VELOCITY = 4.5

var block = false
var mouse_sens = 0.1

var run = false

var view3h = false

var handing = false
var ship_speed_z = 0.0

@export var target_position : Vector3
@export var target_rotation : Vector3

@export var _SoundComponent : SoundComponent
@export var _StateMacine : StateMacine
@export var _InteractionComponent : InteractionComponent

@onready var player_meshes = [$"Kalikotetstt/Armature_001/Skeleton3D/BézierCurve_014", $"Kalikotetstt/Armature_001/Skeleton3D/BézierCurve_015", $"Kalikotetstt/Armature_001/Skeleton3D/BézierCurve_016", $"Kalikotetstt/Armature_001/Skeleton3D/BézierCurve_017", $Kalikotetstt/Armature_001/Skeleton3D/Cube_001, $Kalikotetstt/Armature_001/Skeleton3D/Cube_002, $Kalikotetstt/Armature_001/Skeleton3D/Cube_003, $Kalikotetstt/Armature_001/Skeleton3D/Cube_007, $Kalikotetstt/Armature_001/Skeleton3D/Cube_008, $Kalikotetstt/Armature_001/Skeleton3D/Cube_009, $Kalikotetstt/Armature_001/Skeleton3D/Cube_010, $Kalikotetstt/Armature_001/Skeleton3D/Cube_011, $Kalikotetstt/Armature_001/Skeleton3D/Cube_013, $Kalikotetstt/Armature_001/Skeleton3D/Cube_014, $Kalikotetstt/Armature_001/Skeleton3D/Cube_087, $Kalikotetstt/Armature_001/Skeleton3D/Cube_088, $Kalikotetstt/Armature_001/Skeleton3D/Cube_089, $Kalikotetstt/Armature_001/Skeleton3D/Cylinder_001, $Kalikotetstt/Armature_001/Skeleton3D/Cylinder_031, $Kalikotetstt/Armature_001/Skeleton3D/Icosphere_011, $Kalikotetstt/Armature_001/Skeleton3D/Traveller_Mesh_v01_PlayerSuit_Body_001]

signal interact

func _enter_tree() -> void:
	set_multiplayer_authority(str(name).to_int())

func _ready() -> void:
	if not is_multiplayer_authority(): return
	mouse_mod_capture()
	
func mouse_mod_capture():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func mouse_mod_confiend():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	
func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta * 2
	
	if is_multiplayer_authority():
		target_position = global_position
		target_rotation = global_rotation
	else:
		global_position = global_position.lerp(target_position, delta * 7)
		global_rotation.y = lerp_angle(global_rotation.y, target_rotation.y, delta * 15)
		
	if !is_multiplayer_authority(): return
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_pressed("run") and Input.is_action_pressed("forward"):
		run = true
	else:
		run = false
	
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and !block:
		velocity.x = direction.x * SPEED * delta * 50
		velocity.z = direction.z * SPEED * delta * 50
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
		
	elif block:
		velocity.x = 0
		velocity.z = 0

	move_and_slide()
	

func not_block():
	block = false
