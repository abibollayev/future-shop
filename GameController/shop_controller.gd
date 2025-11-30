extends Node

var is_open: bool = false

func shop_open():
	is_open = true
	
func shop_close():
	is_open = false
	
func get_is_open() -> bool: return is_open
