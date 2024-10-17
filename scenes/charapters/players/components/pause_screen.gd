extends CanvasLayer

@export var player : Movement

var paused = false

func _process(delta: float) -> void:
	if !is_multiplayer_authority(): return
	if Input.is_action_just_pressed("pause"):
		if !paused:
			paused = true
			self.show()
			player.mouse_mod_confiend()
		else:
			paused = false
			self.hide()
			player.mouse_mod_capture()

func _on_button_pressed() -> void:
	SaveSingleTon.save_cube_func()
