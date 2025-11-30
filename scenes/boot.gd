extends MeshInstance3D

@onready var box = get_node("/root/MainScene/PlayerCharacter/CameraHolder/Camera/Box")
@onready var order = get_node("/root/MainScene/GameController/order")

func _interact():
	if box.get_select_item() == null:
		var item = order.cargo_pull()
		if item:
			box.select(item)
	print("Boot")
