@tool
extends EditorScenePostImport

const HUE_FACTOR = 64.0
const SAT_FACTOR = 1.0
const VAL_FACTOR = 1.0

func _post_import(scene):
	return _recursive(scene)

func _recursive(scene : Node):
	if scene is MeshInstance3D:
		print("Add mesh colored script to %s" % [scene.name])
		var p = scene.get_parent()
		# Extract color
		var color_idx = []
		for s in range(scene.mesh.get_surface_count()):
			var m = scene.mesh.surface_get_material(s)
			var idx = find_color(m.albedo_color)
			color_idx.append(idx)
		scene.set_script(load("res://addons/limited_color/mesh_colored.gd"))
		print(color_idx)
		scene.color_id = color_idx
	for c in scene.get_children():
		_recursive(c)
	return scene

func find_color(color : Color):
	var d = -1
	var to_return = 0
	var palette = LimitedColorGlobal.palette
	var image = palette.get_image()
	for r in range(64):
		var c = image.get_pixel(r,0)
		var new_d = (Vector3(c.h*HUE_FACTOR,c.s*SAT_FACTOR,c.v * VAL_FACTOR) - Vector3(color.h*HUE_FACTOR,color.s*SAT_FACTOR,color.v * VAL_FACTOR)).length()
		if d < 0 or new_d < d:
			d = new_d
			to_return = r
	return to_return
