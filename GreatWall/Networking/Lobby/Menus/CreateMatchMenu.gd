extends BaseMenu

signal on_create_pressed(match_name,match_pw)
signal on_cancel_pressed

@export var match_size = 2

var match_name = ""
var match_pw = ""

func _on_MatchName_text_changed(new_text):
	match_name = new_text
	pass

func _on_MatchPW_text_changed(new_text):
	match_pw = new_text
	pass

func _on_Create_Button_button_down():
	emit_signal("on_create_pressed",match_name,match_pw,match_size)
	pass

func _on_CancelButton_button_down():
	emit_signal("on_cancel_pressed")
	pass
