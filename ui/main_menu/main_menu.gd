extends Node

@onready var play_btn = $CanvasLayer/Root/VBoxContainer/PlayBtn
@onready var settings_btn = $CanvasLayer/Root/VBoxContainer/SettingsBtn
@onready var exit_btn = $CanvasLayer/Root/VBoxContainer/ExitBtn

func _ready():
	SceneManager.set_current_scene(self)
	play_btn.pressed.connect(_on_play_pressed)
	settings_btn.pressed.connect(_on_settings_pressed)
	exit_btn.pressed.connect(_on_exit_pressed)

func _on_play_pressed():
	SceneManager.load_game()

func _on_settings_pressed():
	pass

func _on_exit_pressed():
	get_tree().quit()
