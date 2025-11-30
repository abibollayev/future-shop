extends Node3D

@onready var mesh = $Image

var select_item = null

func get_select_item():
	return select_item


func select(item):
	if select_item != null:
		return
	select_item = item
	# set_image(select_item.name)
	print(select_item)
	visible = true
	

func down():
	select_item = null
	visible = false


func set_image(n: String):
	if n == "heart":
		set_mesh_texture("res://img/products/golem_heart.jpg")
	elif n == "implant":
		set_mesh_texture("res://img/products/implant.jpg")
	elif n == "granate":
		set_mesh_texture("res://img/products/granate.jpg")
	elif n == "blast":
		set_mesh_texture("res://img/products/blast.png")

func set_mesh_texture(path: String) -> void:
	if not mesh:
		print("mesh is null")
		return

	print("trying to set texture:", path)

	# load texture resource
	var tex = load(path)
	if not tex:
		print("failed to load texture at path:", path)
		return
	else:
		print("texture loaded:", tex)

	# override material if exists, иначе active
	var mat = mesh.get_surface_override_material(0)
	if not mat:
		mat = mesh.get_active_material(0)

	if not mat:
		print("no material found on mesh")
		return
	else:
		print("material found:", mat)

	if mat is StandardMaterial3D:
		var mat_copy = mat.duplicate() as StandardMaterial3D
		mat_copy.albedo_texture = tex
		mat_copy.albedo_color = Color(1,1,1,1) # reset color to ensure texture visible
		mesh.set_surface_override_material(0, mat_copy)
		print("texture applied:", path)
	else:
		print("material is not StandardMaterial3D, type:", mat.get_class())
