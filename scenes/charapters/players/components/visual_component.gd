class_name VisualComponent

extends Node

@onready var player_meshes = [$"../../Kalikotetstt/Armature_001/Skeleton3D/BézierCurve_014", $"../../Kalikotetstt/Armature_001/Skeleton3D/BézierCurve_015", $"../../Kalikotetstt/Armature_001/Skeleton3D/BézierCurve_016", $"../../Kalikotetstt/Armature_001/Skeleton3D/BézierCurve_017", $"../../Kalikotetstt/Armature_001/Skeleton3D/Cube_001", $"../../Kalikotetstt/Armature_001/Skeleton3D/Cube_002", $"../../Kalikotetstt/Armature_001/Skeleton3D/Cube_003", $"../../Kalikotetstt/Armature_001/Skeleton3D/Cube_007", $"../../Kalikotetstt/Armature_001/Skeleton3D/Cube_008", $"../../Kalikotetstt/Armature_001/Skeleton3D/Cube_009", $"../../Kalikotetstt/Armature_001/Skeleton3D/Cube_010", $"../../Kalikotetstt/Armature_001/Skeleton3D/Cube_011", $"../../Kalikotetstt/Armature_001/Skeleton3D/Cube_013", $"../../Kalikotetstt/Armature_001/Skeleton3D/Cube_014", $"../../Kalikotetstt/Armature_001/Skeleton3D/Cube_087", $"../../Kalikotetstt/Armature_001/Skeleton3D/Cube_088", $"../../Kalikotetstt/Armature_001/Skeleton3D/Cube_089", $"../../Kalikotetstt/Armature_001/Skeleton3D/Cylinder_001", $"../../Kalikotetstt/Armature_001/Skeleton3D/Cylinder_031", $"../../Kalikotetstt/Armature_001/Skeleton3D/Icosphere_011", $"../../Kalikotetstt/Armature_001/Skeleton3D/Traveller_Mesh_v01_PlayerSuit_Body_001"]
@export var camera_cur : Camera3D
@export var camera_3th : Camera3D
var view3h = false

func _ready() -> void:
	if !is_multiplayer_authority(): return
	camera_cur.current = is_multiplayer_authority()
	hide_ob()


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("3th_view"):
		if !view3h:
			camera_3th.current = true
			show_ob()
			view3h = true
		elif view3h:
			camera_cur.current = true
			hide_ob()
			view3h = false
			
func hide_ob():
	if is_multiplayer_authority():
		for i in player_meshes:
			i.transparency = 1
func show_ob():
	if is_multiplayer_authority():
		for i in player_meshes:
			i.transparency = 0
