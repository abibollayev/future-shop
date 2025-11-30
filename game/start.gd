extends Area3D


func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("customer"):
		return
	print("player entered start")
	if body.get_parent().has_method("on_enter_start"):
		body.get_parent().on_enter_start()


func _on_area_entered(area: Area3D) -> void:
	_on_body_entered(area)
