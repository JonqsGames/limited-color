@tool
extends Control
@onready var file_dialog : FileDialog = $VBoxContainer/FileDialog
@onready var bayer_tex = $VBoxContainer/HBoxContainer2/BayerTex
@onready var palette_tex = $VBoxContainer/HBoxContainer/PaletteTex

enum FileDialogMode {
	PALETTE,
	BAYER
}

var file_mode : FileDialogMode

func _ready():
	pass
	#print("Limited color control enter scene")
	#palette_tex.texture = LimitedColorGlobal.palette
	#bayer_tex.texture = LimitedColorGlobal.bayer_matrix


func _on_texture_rect_gui_input(event : InputEvent):
	if event is InputEventMouse and event.is_pressed():
		file_dialog.show()
		file_mode = FileDialogMode.PALETTE


func _on_file_dialog_file_selected(path):
	match file_mode:
		FileDialogMode.PALETTE:
			LimitedColorGlobal.palette = load(path)
			palette_tex.texture = LimitedColorGlobal.palette
			LimitedColorGlobal.color_count = LimitedColorGlobal.palette.get_width()
		FileDialogMode.BAYER:
			LimitedColorGlobal.bayer_matrix = load(path)
			bayer_tex.texture = LimitedColorGlobal.bayer_matrix

func _on_button_pressed():
	LimitedColorGlobal.save_data()


func _on_bayer_tex_gui_input(event):
	if event is InputEventMouse and event.is_pressed():
		file_dialog.show()
		file_mode = FileDialogMode.BAYER


func _on_visibility_changed():
	print("Limited visible")
	if palette_tex:
		palette_tex.texture = LimitedColorGlobal.palette
	if bayer_tex:
		bayer_tex.texture = LimitedColorGlobal.bayer_matrix
