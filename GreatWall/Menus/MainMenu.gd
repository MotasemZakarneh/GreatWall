extends Control

var lobby = null
var console : Console
var player_name = "hero1"

func _ready():
	console = ConsoleLoader.get_main(self)
	yield (get_tree(),"idle_frame")
	lobby = Extentions.get_node_in_group(self,"LobbyUI")
	var _er = lobby.connect("on_leave_lobby",self,"_on_lobby_back")
	_on_PlayerName_text_changed(player_name)
	pass

func _on_SinglePlayer_button_down():
	
	pass

func _on_MultiPlayer_button_down():
	NetworkHead.matchmaker_to_player.start_client_def()
	lobby.show_ui()
	visible = false
	pass

func _on_lobby_back():
	NetworkHead.matchmaker_to_player.stop_client()
	console.write("Lobby Back Request")
	lobby.hide_ui()
	visible = true
	pass

func _on_PlayerName_text_changed(new_text):
	player_name = new_text
	NetworkHead.player_name = player_name
	pass

func _on_Direct_MP_button_down():
	pass 
