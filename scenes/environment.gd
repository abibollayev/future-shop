extends Node3D

@onready var sun = $DirectionalLight3D
@onready var time = get_node("/root/MainScene/GameController/time")

func _ready() -> void:
	print("sun")


# углы солнца
const SUN_RISE = 180.0
const SUN_NOON = 280.0
const SUN_SET = 360.0

func _process(_delta):
	var h = time.get_hour()
	var m = time.get_minute()
	var current_time = h + float(m)/60.0

	# переводим время в "угловой прогресс"
	# пусть день идёт с 6:00 до 20:00
	if current_time < 6 or current_time >= 20:
		# ночь
		sun.light_energy = 0.0
		# держим солнце на заходе или утреннем положении
		if current_time < 6:
			sun.rotation_degrees.x = SUN_RISE
		else:
			sun.rotation_degrees.x = SUN_SET
	else:
		# день: интерполируем угол
		var day_progress = (current_time - 6) / 14.0 # 6..20 = 14 часов
		if day_progress < 0.5:
			# утро → полдень
			sun.rotation_degrees.x = lerp(SUN_RISE, SUN_NOON, day_progress * 2)
		else:
			# полдень → заход
			sun.rotation_degrees.x = lerp(SUN_NOON, SUN_SET, (day_progress - 0.5) * 2)
		sun.light_energy = 1.0
