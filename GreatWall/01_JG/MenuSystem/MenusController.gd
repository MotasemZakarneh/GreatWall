extends Node
class_name MenusController

@export var start_menu = ""
var active_menu = null
var menus = []

func _ready():
	menus = Extentions.get_children_of_type(self,[BaseMenu])
	_i_ready()
	
	if not start_menu.empty():
		open_menu(start_menu)
	pass

func _i_ready():
	
	pass

func open_menu(menu_name:String):
	var menu = _get_menu_of_name(menu_name)
	
	if Extentions.is_node_null(menu):
		return
	
	if not Extentions.is_node_null(active_menu):
		active_menu.close_menu()
	
	menu.open_menu()
	active_menu = menu
	pass

func close_menu(_menu_name:String):
	var menu = _get_menu_of_name(_menu_name)
	
	if Extentions.is_node_null(menu):
		return
	
	menu.close_menu()
	if menu.name == active_menu.name:
		active_menu = null
	pass

func close_active_menu():
	if active_menu != null:
		active_menu.close_menu()
		active_menu = null
	pass

func _get_menu_of_name(_menu_name:String):
	var menu = null
	if _menu_name.empty():
		return menu
	
	for m in menus:
		if Extentions.is_node_null(m):
			continue
		if m.name == _menu_name:
			menu = m
	
	return menu

func _on_back_pressed():
	if active_menu != null:
		active_menu.on_back_pressed()
	pass
