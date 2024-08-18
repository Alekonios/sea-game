class_name StateMacine

extends Node

enum States {Idle, Walk, Run, Jump}


@export var move : Movement

@export var state : States

@onready var char_animator = $"../../Shroom_main_5/AnimationPlayer"
@onready var camera_animator = $"../../AnimationPlayer"

func _process(delta: float) -> void:
	change_state()
	
func change_state():
	match state:
		States.Idle:
			char_animator.play("Stand_v2")
			camera_animator.play("idle")
		States.Walk:
			char_animator.play("Walk")
			camera_animator.play("walk")
		States.Run:
			char_animator.play("Run")
			camera_animator.play("run")
		States.Jump:
			pass
