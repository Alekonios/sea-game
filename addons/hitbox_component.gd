class_name Hitbox

extends Area3D

@export var have_rpc : bool

@export var Usable_Object : Node3D

func activation():
	if !have_rpc:
		if Usable_Object:
			Usable_Object.activation()
	if have_rpc:
		if Usable_Object:
			Usable_Object.activation.rpc()
			
