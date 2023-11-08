@tool
extends EditorPlugin

const AUTOLOAD_NAME = "LimitedColorGlobal"

func _enter_tree():
	# Initialization of the plugin goes here.
	add_custom_type("MeshColored", "MeshInstance3D", preload("mesh_colored.gd"), preload("utils/icon.png"))
	add_autoload_singleton(AUTOLOAD_NAME, "global_limited_color.gd")
	# Add dock
	var dock = preload("res://addons/limited_color/dock/control.tscn").instantiate()
	add_control_to_dock(DOCK_SLOT_LEFT_UR , dock)

func _exit_tree():
	# Clean-up of the plugin goes here.
	remove_autoload_singleton(AUTOLOAD_NAME)
	#RenderingServer.global_shader_parameter_remove(GLOBAL_SHADER_PALETTE)
	#RenderingServer.global_shader_parameter_remove(GLOBAL_SHADER_PALETTE_SIZE)
