extends CharacterBody3D


var speed = 5.0
var jump_vel = 1.0


@export var target : Node3D
@onready var navagent = $NavigationAgent3D

enum States {Ilde, Swim, FastSwim, Jump, Scary}

@export var state = States.Ilde

func _physics_process(delta: float) -> void:
	velocity = Vector3.ZERO
	var pos = global_position
	navagent.set_target_position(target.global_transform.origin)
	var next_pos = navagent.get_next_path_position()
	velocity = (next_pos - global_transform.origin).normalized() * speed
	look_at(navagent.get_next_path_position())
	move_and_slide()
	
