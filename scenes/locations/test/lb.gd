extends CSGBox3D

@onready var cubes = [$"../CSGBox3D15", $"../CSGBox3D16", $"../CSGBox3D17", $"../CSGBox3D18", $"../CSGBox3D19", $"../CSGBox3D20"]

var count = 0

func activation():
	activation_.rpc()

@rpc("any_peer", "call_local", "reliable")
func activation_():
	if !is_multiplayer_authority(): return
	$"../Label3D".text = str(count)
	if cubes.size() > count:
		cubes[count].show()
	count += 1
