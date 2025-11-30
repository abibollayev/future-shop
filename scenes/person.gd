extends Node3D


@onready var anim = $AnimationPlayer

func _ready():
	print("ready")
	anim.play("mixamo_com")
