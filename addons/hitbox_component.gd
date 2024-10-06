class_name Hitbox

extends Area3D

@export var have_rpc : bool
@export var Usable_Object : Node3D
@export var have_sender_with_rpc : bool
@export var have_sender_withnt_rpc : bool


var sender

func activation():
	if !have_rpc:
		if Usable_Object:
			if have_sender_withnt_rpc:
				Usable_Object.activation(sender)
			else:
				Usable_Object.activation()
	elif have_rpc:
		if Usable_Object:
			if have_sender_with_rpc:
				Usable_Object.activation.rpc(sender)
			else:
				Usable_Object.activation.rpc()
		
			
