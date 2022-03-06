extends SFXPlayer
class_name SFXButton

@export var mouse_entered_group = ""
@export var mouse_exitted_group = ""
@export var mouse_click_group = ""

func _ready():
	var _er = get_parent().connect("mouse_entered",self,"_on_mouse_entered")
	_er = get_parent().connect("mouse_exited",self,"_on_mouse_exitted")
	_er = get_parent().connect("button_up",self,"_on_mouse_clicked")
	pass

func _on_mouse_entered():
	PersistantScene.sfx_manager.play_group(mouse_entered_group)
	pass

func _on_mouse_exitted():
	PersistantScene.sfx_manager.play_group(mouse_exitted_group)
	pass

func _on_mouse_clicked():
	PersistantScene.sfx_manager.play_group(mouse_click_group)
	pass
