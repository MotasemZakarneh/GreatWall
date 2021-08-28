extends Button

var dialog_node = null

func _ready():
	connect("button_up",self,"_on_next_indi_pressed")
	var t = load("res://addons/dialogic/Nodes/dialog_node.gd")
	dialog_node = Extentions.get_parent_of_type(self,[t])
	pass

func _on_next_indi_pressed():
	
	if dialog_node == null:
		return
	dialog_node.continue_by_ui()
	pass
