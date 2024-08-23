class_name SoundComponent

extends Node

@onready var place_collider = $"../../Sounds/RayCast3D"


@export var move_sounds : Array[AudioStreamPlayer3D]

var play_cd = false

func checkplace():
	if place_collider.is_colliding():
		play_sound(0, 0.5)
			
func play_sound(sound_id : int, time : float):
	if !play_cd:
		move_sounds[sound_id].play()
		play_cd = true
		await get_tree().create_timer(time, false).timeout
		play_cd = false
		
