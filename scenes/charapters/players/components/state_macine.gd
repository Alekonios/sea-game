class_name StateMacine

extends Node

enum States {Idle, Walk, Run, Jump}


@export var move : Movement

@export var state : States

@onready var char_animator = $"../../Kalikotetstt/AnimationPlayer"
@onready var camera_animator = $"../../AnimationPlayer"

func _process(delta: float) -> void:
	change_state()
	
func change_state():
	match state:
		States.Idle:
			char_animator.play("Idol_test_1")
			camera_animator.play("idle")
		States.Walk:
			char_animator.play("Walk_test")
			camera_animator.play("walk")
		States.Run:
			char_animator.play("Run_test")
			camera_animator.play("run")
		States.Jump:
			pass
