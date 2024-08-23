class_name Hitbox

extends Area3D

@export var Usable_Object : Node3D

func activation():
	if Usable_Object:
		Usable_Object.activation()
