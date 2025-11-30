extends Node
# this node should be autoloaded or placed in root

var day:int = 1
var hour:int = 6
var minute:int = 0

var tick_time := 0.0
var tick_interval := 2.5
# 5 minutes pass every 2.5 seconds

func _process(delta):
	tick_time += delta
	if tick_time >= tick_interval:
		tick_time = 0
		add_minutes(5)

func add_minutes(m:int):
	minute += m
	if minute >= 60:
		minute -= 60
		hour += 1
		if hour >= 24:
			hour = 0
			day += 1

# getters
func get_day(): return day
func get_hour(): return hour
func get_minute(): return minute
