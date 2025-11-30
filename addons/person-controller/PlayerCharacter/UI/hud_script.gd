extends CanvasLayer

class_name HUD

#player character reference variable
@export var play_char : PlayerCharacter

#label references variables
@onready var current_state_label_text: Label = %CurrentStateLabelText
@onready var desired_move_speed_label_text: Label = %DesiredMoveSpeedLabelText
@onready var velocity_label_text: Label = %VelocityLabelText
@onready var velocity_vector_label_text : Label = %VelocityVectorLabelText
@onready var is_on_floor_label_text: Label = %IsOnFloorLabelText
@onready var ceiling_check_label_text: Label = %CeilingCheckLabelText
@onready var jump_buffer_label_text: Label = %JumpBufferLabelText
@onready var coyote_time_label_text: Label = %CoyoteTimeLabelText
@onready var nb_jumps_in_air_allowed_label_text: Label = %NbJumpsInAirAllowedLabelText
@onready var jump_cooldown_label_text: Label = %JumpCooldownLabelText
@onready var slide_time_label_text: Label = %SlideTimeLabelText
@onready var slide_cooldown_label_text: Label = %SlideCooldownLabelText
@onready var nb_dashs_allowed_label_text: Label = %NbDashsAllowedLabelText
@onready var dash_cooldown_label_text: Label = %DashCooldownLabelText
@onready var frames_per_second_label_text: Label = %FramesPerSecondLabelText
@onready var camera_rotation_label_text: Label = %CameraRotationLabelText
@onready var current_fov_label_text: Label = %CurrentFOVLabelText
@onready var camera_bob_vertical_offset_label_text: Label = %CameraBobVerticalOffsetLabelText
@onready var speed_lines_container: ColorRect = %SpeedLinesContainer

@onready var day_label_text = $MainInfo/Text/DayLabelText
@onready var time_label_text = $MainInfo/Text/TimeLabelText
@onready var time = get_node("/root/MainScene/GameController/time")
@onready var balance = get_node("/root/MainScene/GameController/balance")
@onready var order = get_node("/root/MainScene/GameController/order")
@onready var cs = get_node("/root/MainScene/PlayerCharacter/CameraHolder")

@onready var shop_box_overlay = $ShopBoxOverlay
@onready var shop_box = $ShopBox

func _process(delta : float) -> void:
	display_current_FPS()
	
	update_ui()
	
	update_balance()
	
	update_order()

	# display_properties()

func _input(event):
	if event.is_action_pressed("open_shop"):
		toggle_shop()

func toggle_shop():
	cs.mouse_mode_toggle()
	shop_box_overlay.visible = not shop_box_overlay.visible
	shop_box.visible = not shop_box.visible

func update_ui():
	day_label_text.text = str(time.get_day())
	time_label_text.text = str(time.get_hour()).pad_zeros(2) + ":" + str(time.get_minute()).pad_zeros(2)
	
func display_properties() -> void:
	#player character properties
	current_state_label_text.set_text(str(play_char.state_machine.curr_state_name))
	desired_move_speed_label_text.set_text(str(round_to_3_decimals(play_char.desired_move_speed)))
	velocity_label_text.set_text(str(round_to_3_decimals(play_char.velocity.length())))
	velocity_vector_label_text.set_text(str("[ ", round_to_3_decimals(play_char.velocity.x)," ", round_to_3_decimals(play_char.velocity.y)," ", round_to_3_decimals(play_char.velocity.z), " ]"))
	is_on_floor_label_text.set_text(str(play_char.is_on_floor()))
	ceiling_check_label_text.set_text(str(play_char.ceiling_check.is_colliding()))
	jump_buffer_label_text.set_text(str(play_char.jump_buff_on))
	coyote_time_label_text.set_text(str(round_to_3_decimals(play_char.coyote_jump_cooldown)))
	nb_jumps_in_air_allowed_label_text.set_text(str(play_char.nb_jumps_in_air_allowed))
	jump_cooldown_label_text.set_text(str(round_to_3_decimals(play_char.jump_cooldown)))
	slide_time_label_text.set_text(str(round_to_3_decimals(play_char.slide_time)))
	slide_cooldown_label_text.set_text(str(round_to_3_decimals(play_char.time_bef_can_slide_again)))
	nb_dashs_allowed_label_text.set_text(str(play_char.nb_dashs_allowed))
	dash_cooldown_label_text.set_text(str(round_to_3_decimals(play_char.time_bef_can_dash_again)))
	
	#camera properties
	camera_rotation_label_text.set_text(str("[ ", round_to_3_decimals(play_char.cam.rotation.x)," ", round_to_3_decimals(play_char.cam.rotation.y)," ", round_to_3_decimals(play_char.cam.rotation.z), " ]"))
	current_fov_label_text.set_text(str(play_char.cam.fov))
	camera_bob_vertical_offset_label_text.set_text(str(round_to_3_decimals(play_char.cam.v_offset)))
	
func display_current_FPS() -> void:
	frames_per_second_label_text.set_text(str(Engine.get_frames_per_second()))
	
func display_speed_lines(value : bool) -> void:
	speed_lines_container.visible = value
	
func round_to_3_decimals(value: float) -> float:
	return round(value * 1000.0) / 1000.0

# Shop
@onready var total_price_text = $ShopBox/Panel/Bottom/TotalPrice
@onready var heart_minus_btn = $ShopBox/Panel/VBox/HBox/Heart/Box/Minus
@onready var heart_plus_btn = $ShopBox/Panel/VBox/HBox/Heart/Box/Plus
@onready var heart_count_text = $ShopBox/Panel/VBox/HBox/Heart/Box/Count
@onready var implant_minus_btn = $ShopBox/Panel/VBox/HBox/Implant/Box/Minus
@onready var implant_plus_btn = $ShopBox/Panel/VBox/HBox/Implant/Box/Plus
@onready var implant_count_text = $ShopBox/Panel/VBox/HBox/Implant/Box/Count
@onready var granate_minus_btn = $ShopBox/Panel/VBox/HBox/Granate/Box/Minus
@onready var granate_plus_btn = $ShopBox/Panel/VBox/HBox/Granate/Box/Plus
@onready var granate_count_text = $ShopBox/Panel/VBox/HBox/Granate/Box/Count
@onready var blast_minus_btn = $ShopBox/Panel/VBox/HBox/Blast/Box/Minus
@onready var blast_plus_btn = $ShopBox/Panel/VBox/HBox/Blast/Box/Plus
@onready var blast_count_text = $ShopBox/Panel/VBox/HBox/Blast/Box/Count
@onready var talisman_minus_btn = $ShopBox/Panel/VBox/HBox/Talisman/Box/Minus
@onready var talisman_plus_btn = $ShopBox/Panel/VBox/HBox/Talisman/Box/Plus
@onready var talisman_count_text = $ShopBox/Panel/VBox/HBox/Talisman/Box/Count

@onready var exit_btn = $ShopBox/Panel/Top/Exit
@onready var order_btn = $ShopBox/Panel/Bottom/Submit
@onready var reset_btn = $ShopBox/Panel/Bottom/Reset

var items = {
	"heart": {"price": 300, "count": 0, "count_text": null},
	"implant": {"price": 500, "count": 0, "count_text": null},
	"granate": {"price": 1500, "count": 0, "count_text": null},
	"blast": {"price": 4200, "count": 0, "count_text": null},
	"talisman": {"price": 10000, "count": 0, "count_text": null},
}

func _ready():
	# присваиваем текстовые лейблы после ready
	items["heart"].count_text = heart_count_text
	items["implant"].count_text = implant_count_text
	items["granate"].count_text = granate_count_text
	items["blast"].count_text = blast_count_text
	items["talisman"].count_text = talisman_count_text
	
	# подключаем кнопки
	heart_minus_btn.pressed.connect(func(): item_minus("heart"))
	heart_plus_btn.pressed.connect(func(): item_plus("heart"))
	implant_minus_btn.pressed.connect(func(): item_minus("implant"))
	implant_plus_btn.pressed.connect(func(): item_plus("implant"))
	granate_minus_btn.pressed.connect(func(): item_minus("granate"))
	granate_plus_btn.pressed.connect(func(): item_plus("granate"))
	blast_minus_btn.pressed.connect(func(): item_minus("blast"))
	blast_plus_btn.pressed.connect(func(): item_plus("blast"))
	talisman_minus_btn.pressed.connect(func(): item_minus("talisman"))
	talisman_plus_btn.pressed.connect(func(): item_plus("talisman"))
	
	exit_btn.pressed.connect(toggle_shop)
	order_btn.pressed.connect(submit_order)
	reset_btn.pressed.connect(reset_order)
	
	update_shop()

func set_count(id: String, n: int):
	items[id].count = n

func get_total() -> int:
	var sum = 0
	for id in items:
		sum += items[id].price * items[id].count
	return sum
	
func item_plus(id: String):
	items[id].count += 1
	update_shop()
	
func item_minus(id: String):
	if items[id].count > 0:
		items[id].count -= 1
	update_shop()
	
func update_shop():
	for id in items:
		var it = items[id]
		if it.count_text:
			it.count_text.text = str(it.count)
	
	total_price_text.text = str(get_total()) +  " ₸"

func submit_order():
	var active = order.get_order_active()
	if active:
		return
	var total_price = get_total()
	var user_balance = balance.get_balance()
	if user_balance < total_price:
		return
	
	balance.minus_balance(total_price)
	order.create_order(items)
	reset_order()
	
func reset_order():
	for id in items:
		items[id].count = 0
	update_shop()

# Balance
@onready var balance_label_text = $MainInfo/Text/BalanceLabelText

func update_balance():
	balance_label_text.text = str(balance.get_balance())  +  " ₸"

@onready var order_time_label = $Order/Label/TimeTo
@onready var order_select_label = $Order/Label/Select
@onready var order_time_text = $Order/Text/TimeToText
@onready var order_select_text = $Order/Text/SelectText

func update_order():
	# order time part
	var active = order.get_order_active()

	if active:
		order_btn.disabled = true
		order_btn.text = "Ожидайте"
		var t = order.get_time()                   # seconds left
		var incoming_count = order.get_items_count()

		order_time_text.text = str(t) + "s - " + str(incoming_count) + "x"

		order_time_label.visible = true
		order_time_text.visible = true
	else:
		order_btn.disabled = false
		order_btn.text = "Заказать"
		# hide time if no active orderdisabled = true
		order_time_label.visible = false
		order_time_text.visible = false


	# cargo part
	var cargo = order.get_cargo_items()
	var cargo_count = cargo.size()

	if cargo_count > 0:
		order_select_text.text = str(cargo_count) + "x"
		order_select_label.visible = true
		order_select_text.visible = true
	else:
		order_select_label.visible = false
		order_select_text.visible = false
		
@onready var itemBox: HBoxContainer = $Item
@onready var item_text: Label = $Item/Text/ItemText

func item_hidden():
	itemBox.visible = false

func item_visible():
	itemBox.visible = true
	
func set_item_text(v: String):
	item_text.text = v
	
