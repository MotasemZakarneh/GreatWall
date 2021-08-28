extends Node2D

export var port = 8002
export var auto_connect = true

func _ready():
	$MainMenuUI/ClosingControl.visible = false
	if auto_connect:
		yield (get_tree().create_timer(1),"timeout")
		_on_StartServerButton_button_down()
	pass

func _on_StartServerButton_button_down():
	NetworkHead.matchmaker_to_player.start_server(port)
	
	$MainMenuUI/OpeningControl.visible = false
	$MainMenuUI/ClosingControl.visible = true
	$LobbyUI.show_ui()
	pass

func _on_PortWriter_text_changed(new_text):
	port = int(new_text)
	pass

func _on_CloseServerButton_button_down():
	$MainMenuUI/ClosingControl.visible = false
	$MainMenuUI/OpeningControl.visible = true
	$LobbyUI.hide_ui()
	NetworkHead.matchmaker_to_player.stop_server()
	pass
