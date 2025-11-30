extends Node

@onready var progress_bar = $CanvasLayer/Root/HBoxContainer/Panel/ProgressBar

var target_path: String
var loading = false

func start_loading(scene_path: String):
	target_path = scene_path
	var err = ResourceLoader.load_threaded_request(target_path)
	if err != OK:
		push_error("failed to start threaded load: " + target_path)
		return
	loading = true
	set_process(true)
	progress_bar.text = str(0)

func _process(_delta):
	if not loading:
		return

	var progress = []
	var status = ResourceLoader.load_threaded_get_status(target_path, progress)
	if progress.size() > 0:
		progress_bar.text = str(progress[0] * 100.0)

	if status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
		var res = ResourceLoader.load_threaded_get(target_path)
		if res is PackedScene:
			if SceneManager.current_scene:
				SceneManager.current_scene.call_deferred("queue_free")
			var inst = (res as PackedScene).instantiate()
			get_tree().get_root().add_child(inst)
			SceneManager.set_current_scene(inst)
		else:
			push_error("loaded resource is not PackedScene: " + str(res))
		loading = false
		set_process(false)
		queue_free()
	elif status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_FAILED:
		push_error("threaded load failed: " + target_path)
		loading = false
		set_process(false)
		queue_free()
