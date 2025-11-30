extends MeshInstance3D
@onready var customer: CharacterBody3D = $"../Customer"

func _interact():
	customer._interact()
