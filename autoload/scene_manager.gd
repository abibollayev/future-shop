extends Node

var loading_screen = null
var current_scene = null

func set_current_scene(scene):
	current_scene = scene
	get_tree().current_scene = scene

func _ready():
	loading_screen = preload("res://ui/loading_screen/loading_screen.tscn").instantiate()

func load_game():
	if get_tree().current_scene:
		get_tree().current_scene.call_deferred("queue_free")
	get_tree().get_root().add_child(loading_screen)
	loading_screen.start_loading("res://game/world.tscn")

func finish_loading(scene):
	loading_screen.queue_free()
	current_scene = scene
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
