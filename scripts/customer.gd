extends CharacterBody3D

@onready var hud: HUD = $"../PlayerCharacter/HUD"

@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var shop: Node3D = $"../Shop"
@onready var order: Node = $"../GameController/order"
@onready var table: MeshInstance3D = $"../Table"
@onready var box: Node3D = $"../PlayerCharacter/CameraHolder/Camera/Box"
@onready var balance: Node = $"../GameController/balance"
@onready var start: Node3D = $"../Start"
const SPEED = 4.0
var check_timer := 0.0
const CHECK_INTERVAL := 10.0

var is_moving := false
enum CustomerState {WAIT, TO_SHOP, IDLE, TO_HOME}
var state = CustomerState.WAIT

var buy_item = null

func _interact():
	if state == CustomerState.IDLE:
		print("buy")
		if box.select_item:
			if box.select_item.name != buy_item.name:
				return
			
			if buy_item.name == "heart":
				balance.plus_balance(450)
			elif buy_item.name == "implant":
				balance.plus_balance(750)
			elif buy_item.name == "granate":
				balance.plus_balance(2250)
			elif buy_item.name == "blast":
				balance.plus_balance(6300)
			elif buy_item.name == "talisman":
				balance.plus_balance(15000)
				
			box.down()
			
			state = CustomerState.TO_HOME
			is_moving = true
			buy_item = null 
			hud.item_hidden()
	print("customer")

func _process(delta: float) -> void:
	if state == CustomerState.IDLE:
		hud.item_visible()
		hud.set_item_text(str(buy_item.name))
	elif table.is_open and state == CustomerState.WAIT:
		check_timer += delta
		if check_timer >= CHECK_INTERVAL:
			check_timer = 0.0
			_run_check()
	else:
		check_timer = 0.0
		
func _run_check():
	if order.get_case_items_count() > 0:
		customer_create()
	else:
		print("пусто")

func customer_create():
	state = CustomerState.TO_SHOP
	is_moving = true
	buy_item = get_random_item(order.get_case())
	print("ходит")

func get_random_item(arr: Array) -> Dictionary:
	if arr.is_empty():
		return {}
	return arr[randi() % arr.size()]

func _physics_process(_delta: float) -> void:
	var target_pos: Vector3 = Vector3.ZERO
	var has_target := false

	if state == CustomerState.TO_HOME and is_moving:
		nav.target_position = start.position
		target_pos = nav.get_next_path_position()
		has_target = true
	elif is_moving:
		nav.target_position = shop.position
		target_pos = nav.get_next_path_position()
		has_target = true

	if has_target:
		var direction := (target_pos - global_transform.origin).normalized()
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED

		var look_dir = Vector3(direction.x, 0, direction.z)
		if look_dir.length() > 0.01:
			look_at(global_transform.origin + look_dir, Vector3.UP)
	else:
		# нет цели — замедляемся
		velocity.x = move_toward(velocity.x, 0.0, SPEED)
		velocity.z = move_toward(velocity.z, 0.0, SPEED)

	move_and_slide()
	
func on_enter_shop():
	state = CustomerState.IDLE
	print("idle")

	
func on_enter_start():
	is_moving = false
	state = CustomerState.WAIT
	print("start")
