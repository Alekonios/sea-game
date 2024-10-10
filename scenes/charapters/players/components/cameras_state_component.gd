extends Node

@export  var camera : Camera3D
@export var player : Movement

@export var markers : Array[Marker3D]

#func _process(delta: float) -> void:
	#if player.block:
		#camera.global_position = lerp(camera.global_position, markers[1].global_position, delta * 0.8)
		#player.show_ob()
	#if !player.block:
		#camera.global_position = lerp(camera.global_position, markers[0].global_position, delta * 0.8)
		#player.hide_ob()
	
