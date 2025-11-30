extends MeshInstance3D

@onready var box = get_node("/root/MainScene/PlayerCharacter/CameraHolder/Camera/Box")
@onready var order: Node = $"../../GameController/order"

@onready var heart = $heart
@onready var implant = $implant
@onready var granate = $granate
@onready var talisman: Node3D = $talisman

var showcase_item = null

func _interact():
	var item = box.get_select_item()
	if showcase_item:
		if not item:
			box.select(showcase_item)
			order.case_remove_by_id(showcase_item.id)
			heart.visible = false
			implant.visible = false
			granate.visible = false
			talisman.visible = false
			showcase_item = null
			print(order.get_case())
		return
	
	if item:
		if item.name == "heart":
			heart.visible = true
		elif item.name == "implant":
			implant.visible = true
		elif item.name == "granate":
			granate.visible = true
		elif item.name == "talisman":
			talisman.visible = true
		else:
			return
		showcase_item = item
		order.case_push(item)
		box.down()
		print(order.get_case())
