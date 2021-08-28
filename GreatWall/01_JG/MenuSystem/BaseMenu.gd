extends Control
class_name BaseMenu
export var start_hidden = true

func _ready():
	_i_ready()
	
	if start_hidden:
		inst_close_menu()
	pass

func _i_ready():
	
	pass

func _i_on_open():
	
	pass

func on_back_pressed():
	_i_on_back_pressed()
	pass

func _i_on_back_pressed():
	
	pass

func open_menu():
	visible = true
	_i_on_open()
	pass

func close_menu():
	visible = false
	pass

func inst_close_menu():
	visible = false
	pass
