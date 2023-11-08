@tool
extends MeshInstance3D

const default_material = preload("res://addons/limited_color/shaders/default_mesh_colored.tres")
var mesh_id = -1:
	set(value):
		mesh_id = value
		update_all_mesh_id.call_deferred()

@export var color_id = [] :
	set(value):
		color_id = value
		update_all_mesh_id.call_deferred()

#func _enter_tree():
	#if !LimitedColorGlobal.mesh_id_updated.is_connected(self._on_reassigned_mesh_id):
		#LimitedColorGlobal.mesh_id_updated.connect(self._on_reassigned_mesh_id)
func _exit_tree():
	#LimitedColorGlobal.mesh_id_updated.disconnect(self._on_reassigned_mesh_id)
	LimitedColorGlobal.deregister_mesh(mesh_id)
func _ready():
	self.add_to_group("mesh_colored")
	mesh_id = LimitedColorGlobal.register_mesh()
	for i in range(mesh.get_surface_count()):
		if color_id.size() < i + 1:
			color_id.append(i)
		self.set_surface_override_material(i,default_material.duplicate())
		self.update_mesh_id(i)

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		self.update_all_mesh_id()

func update_all_mesh_id():
	for i in range(mesh.get_surface_count()):
		self.update_mesh_id(i)

func update_mesh_id(index):
	if self.get_surface_override_material(index) != null:
		self.get_surface_override_material(index).set_shader_parameter("mesh_id", float(mesh_id))
		self.get_surface_override_material(index).set_shader_parameter("color_id", float(color_id[index]))

func on_reassigned_mesh_id(old_value,new_value):
	if old_value == mesh_id:
		mesh_id = new_value
