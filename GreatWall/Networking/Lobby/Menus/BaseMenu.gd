extends Control
class_name BaseMenu

@export var auto_hide = true

func _ready():
	if auto_hide:
		hide_ui()
	_i_ready()
	pass

func _i_ready():
	pass

func show_ui():
	visible = true
	pass

func hide_ui():
	visible = false
	pass
