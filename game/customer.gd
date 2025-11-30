extends CharacterBody3D

@export var speed = 3.0
@export var wait_time_at_cash = 5.0
@export var start_delay = 3.0   # задержка старта

@onready var agent = $NavigationAgent3D

var waypoints = []
var current_index = 0
var cash_position: Vector3
var walking = false

func _ready():
	waypoints = [
		get_node("/root/MainScene/SpawnPoint").global_transform.origin,
		get_node("/root/MainScene/DoorPoint").global_transform.origin,
		get_node("/root/MainScene/InsideShopPoint").global_transform.origin,
		get_node("/root/MainScene/CashPoint").global_transform.origin,
		get_node("/root/MainScene/InsideShopPoint").global_transform.origin,
		get_node("/root/MainScene/DoorPoint").global_transform.origin,
		get_node("/root/MainScene/SpawnPoint").global_transform.origin
	]

	cash_position = get_node("/root/MainScene/CashPoint").global_transform.origin

	# старт через 3 сек
	start_after_delay()

func start_after_delay() -> void:
	var t = Timer.new()
	t.wait_time = start_delay
	t.one_shot = true
	add_child(t)
	t.start()
	await t.timeout
	t.queue_free()

	walking = true
	agent.target_position = waypoints[current_index]

func _physics_process(delta):
	if not walking:
		return

	if agent.is_navigation_finished():
		current_index += 1

		if current_index >= waypoints.size():
			queue_free()
			return

		var next_target = waypoints[current_index]
		agent.target_position = next_target

		if next_target == cash_position:
			walking = false
			wait_at_cash()
		return

	var next_pos = agent.get_next_path_position()
	var dir = (next_pos - global_position).normalized()

	velocity = dir * speed
	move_and_slide()

func wait_at_cash() -> void:
	var t = Timer.new()
	t.wait_time = wait_time_at_cash
	t.one_shot = true
	add_child(t)
	t.start()
	await t.timeout
	t.queue_free()

	walking = true
