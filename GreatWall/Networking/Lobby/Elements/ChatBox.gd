extends Control

signal on_text_submitted(new_text)

export var initial_text = "Welcome To Lobby"

func _on_LineEdit_text_changed(new_text):
	$LineEdit.text = ""
	var chat = $ChatArea/ChatBox
	chat.bbcode_text = chat.bbcode_text + "\n" + new_text
	emit_signal("on_text_submitted",new_text)
	pass
