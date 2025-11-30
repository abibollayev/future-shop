extends Node

var _order_items: Array = []
var _cargo_items: Array = [] # items waiting in cargo
var _case_items: Array = []
var _order_active := false
var _order_timer = null

var _id_counter := 1 # generate unique item ids

func _ready():
	_order_timer = Timer.new()
	_order_timer.wait_time = 30.0
	_order_timer.one_shot = true
	_order_timer.timeout.connect(_on_order_arrived)
	add_child(_order_timer)

func get_case_items_count() -> int:
	return _case_items.size()

func case_push(item):
	_case_items.append(item)
	
func get_case():
	return _case_items

func case_pull():
	if _case_items.size() == 0:
		return null
	return _case_items.pop_front()

func case_remove_by_id(id: int) -> bool:
	for i in range(_case_items.size()):
		if _case_items[i].id == id:
			_case_items.remove_at(i)
			return true
	return false

func get_case_item_by_id(id: int):
	for item in _order_items:
		if item.id == id:
			return item

	return null

# ----- time -----

func get_time() -> int:
	if _order_timer:
		return int(_order_timer.time_left)
	return 0


# ----- items (order) -----

func get_items():
	return _order_items

func get_items_count() -> int:
	# how many items will arrive when timer ends
	return _order_items.size()


# ----- cargo -----

func get_cargo_items():
	return _cargo_items

func get_cargo_count() -> int:
	# how many items are waiting in the cargo queue
	return _cargo_items.size()


# push item into cargo queue
func cargo_push(item):
	_cargo_items.append(item)

# pop one item from cargo queue
func cargo_pull():
	if _cargo_items.size() == 0:
		return null
	return _cargo_items.pop_front()


# ----- order creation -----

func get_order_active():
	return _order_active


func _create_item_list(data: Dictionary) -> Array:
	var arr: Array = []

	for key in ["heart", "implant", "granate", "blast", "talisman"]:
		if data.has(key):
			var entry = data[key]
			if entry.has("count"):
				for i in range(entry.count):
					arr.append({
						"name": key,
						"id": _id_counter
					})
					_id_counter += 1
	return arr


func create_order(data: Dictionary) -> void:
	if _order_active:
		print("order already active")
		return

	_order_items = _create_item_list(data)

	if _order_items.size() == 0:
		print("empty order, abort")
		return

	_order_active = true
	print("order created, arriving in 30 sec")

	_order_timer.start()


# ----- when order arrives -----

func _on_order_arrived():
	print("order arrived")

	for item in _order_items:
		cargo_push(item)

	_order_items.clear()
	_order_active = false

	print("cargo updated: ", _cargo_items)
