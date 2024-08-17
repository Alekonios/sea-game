class_name StateMacine

extends Node

enum States {Idle, Walk, Run, Jump}


@export var move : Movement

@export var state : States = States.Idle

@onready var camera_animator = $"../../AnimationPlayer"

func _process(delta: float) -> void:
	change_state()

func change_state():
	match state:
		States.Idle:
			camera_animator.play("idle")
		States.Walk:
			camera_animator.play("walk")
		States.Run:
			camera_animator.play("run")
		States.Jump:
			pass
