extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SaveSingleTon.SaveCube = self
