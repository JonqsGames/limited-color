@tool
extends Node

const SAVE_PATH = "res://limited_color_cache.json"

const GLOBAL_SHADER_PALETTE = "palette"
const GLOBAL_SHADER_PALETTE_SIZE = "palette_size"
const GLOBAL_SHADER_MESH_COUNT = "mesh_count"
const GLOBAL_SHADER_BAYER_MATRIX = "bayer_matrix"

var color_count :
	set(value):
		color_count = value
		RenderingServer.global_shader_parameter_set(GLOBAL_SHADER_PALETTE_SIZE, color_count)
		
@export var palette : Texture2D :
	set(value):
		palette = value
		color_count = palette.get_width()
		print("Set palette %s " % [palette.resource_name])
		RenderingServer.global_shader_parameter_set(GLOBAL_SHADER_PALETTE, palette)
@export var bayer_matrix : Texture2D : 
	set(value):
		bayer_matrix = value
		print("Set bayer_matrix %s " % [bayer_matrix.resource_name])
		RenderingServer.global_shader_parameter_set(GLOBAL_SHADER_BAYER_MATRIX, bayer_matrix)

var mesh_count = 0 :
	set(value):
		mesh_count = value
		RenderingServer.global_shader_parameter_set(GLOBAL_SHADER_MESH_COUNT, float(value + 1.0))
var editor_mesh_count = 0 :
	set(value):
		editor_mesh_count = value
		RenderingServer.global_shader_parameter_set(GLOBAL_SHADER_MESH_COUNT, float(value + 1.0))
		
var to_remove_id = []

signal mesh_id_updated(old_value, new_value)

func _enter_tree():
	if Engine.is_editor_hint():
		if GLOBAL_SHADER_PALETTE not in RenderingServer.global_shader_parameter_get_list():
			RenderingServer.global_shader_parameter_add(GLOBAL_SHADER_PALETTE, RenderingServer.GlobalShaderParameterType.GLOBAL_VAR_TYPE_SAMPLER2D, palette)
		if GLOBAL_SHADER_PALETTE_SIZE not in RenderingServer.global_shader_parameter_get_list():
			RenderingServer.global_shader_parameter_add(GLOBAL_SHADER_PALETTE_SIZE, RenderingServer.GlobalShaderParameterType.GLOBAL_VAR_TYPE_FLOAT, color_count)
		if GLOBAL_SHADER_MESH_COUNT not in RenderingServer.global_shader_parameter_get_list():
			RenderingServer.global_shader_parameter_add(GLOBAL_SHADER_MESH_COUNT, RenderingServer.GlobalShaderParameterType.GLOBAL_VAR_TYPE_FLOAT, float(mesh_count + 1.0))
		if GLOBAL_SHADER_BAYER_MATRIX not in RenderingServer.global_shader_parameter_get_list():
			RenderingServer.global_shader_parameter_add(GLOBAL_SHADER_BAYER_MATRIX, RenderingServer.GlobalShaderParameterType.GLOBAL_VAR_TYPE_SAMPLER2D, bayer_matrix)
	var save_file = FileAccess.open(SAVE_PATH,FileAccess.READ)
	if save_file != null:
		var json = JSON.new()
		var ret_parse = json.parse(save_file.get_line())
		var save_data = json.get_data()
		print(save_data["palette"])
		palette = load(save_data["palette"])
		bayer_matrix = load(save_data["bayer_matrix"])
		color_count = save_data["color_count"]
	else:
		palette = load("res://addons/limited_color/b_w.png")
		bayer_matrix = load("res://addons/limited_color/noise_texture.tres")
		color_count = palette.get_width()
	print("[LimitedColor] Autoload is loaded")
	self.reset_mesh_count()
	
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		self.save_data()

func save_data():
	print("[LimitedColor] Save")
	var save_dict = {
		"palette" : palette.resource_path,
		"bayer_matrix" : bayer_matrix.resource_path,
		"color_count" : color_count
	}
	var save_file = FileAccess.open(SAVE_PATH,FileAccess.WRITE)
	var json = JSON.stringify(save_dict)
	save_file.store_line(json)
	save_file.close()
	#print("[LimitedColor] Autoload is out")

func _process(delta):
	if to_remove_id.size() > 0:
		var att_id = to_remove_id.pop_front()
		for n in get_tree().get_nodes_in_group("colored_mesh"):
			n.on_reassigned_mesh_id(mesh_count,att_id)
		mesh_id_updated.emit(mesh_count,att_id)
		mesh_count -= 1
		
#Handle mesh count
func reset_mesh_count():
	if Engine.is_editor_hint():
		editor_mesh_count = 0
	else:
		mesh_count = 0

func deregister_mesh(id):
	if id == mesh_count and !Engine.is_editor_hint():
		mesh_count -= 1
	elif id == editor_mesh_count and Engine.is_editor_hint():
		editor_mesh_count -= 1
	else:
		to_remove_id.append(id)

func register_mesh():
	if to_remove_id.size() > 0:
		return to_remove_id.pop_front()
	else:
		if Engine.is_editor_hint():
			editor_mesh_count = editor_mesh_count + 1
			return editor_mesh_count
		else:
			mesh_count = mesh_count + 1
			return mesh_count
			
