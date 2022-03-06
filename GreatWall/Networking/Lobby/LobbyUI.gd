extends CanvasLayer
class_name LobbyUI

signal on_leave_lobby

@export var auto_hide = true
var active_match_id = -1

func _ready():
	if not is_in_group("LobbyUI"):
		add_to_group("LobbyUI")
	if auto_hide:
		hide_ui()
	
	var _er = NetworkHead.matchmaker_to_player.connect("r_on_player_left",self,"remove_player")
	_er = NetworkHead.matchmaker_to_player.connect("r_on_player_joined",self,"add_player_by_name")
	_er = NetworkHead.matchmaker_to_player.connect("r_on_recieved_existing_players_data",self,"refresh_players")
	
	_er = NetworkHead.matchmaker_to_player.connect("r_create_match_response",self,"_on_create_match_response")
	_er = NetworkHead.matchmaker_to_player.connect("r_on_match_created",self,"_on_match_created")
	
	_er = NetworkHead.matchmaker_to_player.connect("r_on_recieved_existing_matches_data",self,"_on_recieved_existing_matches_data")
	pass

func hide_ui():
	$Control.visible = false
	pass

func show_ui():
	$Control.visible = true
	pass

func refresh_players(players_lobby_data):
	$Control/MainLobbyMenu.refresh_players(players_lobby_data)
	pass

func remove_player(player):
	$Control/MainLobbyMenu.remove_player(player)
	pass

func add_player_by_name(player,player_name):
	$Control/MainLobbyMenu.add_player_by_name(player,player_name)
	pass

func _on_create_match_response(response,id):
	$Control/Blocker.hide_ui()
	if response:
		$Control/CreateMatchMenu.hide_ui()
		$Control/MatchMenu.show_ui()
		active_match_id = id
	pass

func on_match_created(_match_data):
	pass

func _on_recieved_existing_matches_data(existing_matches_data):
	$Control/MainLobbyMenu.refresh_matches_data(existing_matches_data)
	pass

func _on_MainLobbyMenu_on_back_pressed():
	emit_signal("on_leave_lobby")
	pass

func _on_MainLobbyMenu_on_create_pressed():
	$Control/CreateMatchMenu.show_ui()
	pass

func _on_CreateMatchMenu_on_create_pressed(match_name, match_pw,match_size):
	$Control/Blocker.show_ui()
	NetworkHead.matchmaker_to_player.create_match(match_name,match_pw,match_size)
	pass

func _on_CreateMatchMenu_on_cancel_pressed():
	$Control/CreateMatchMenu.hide_ui()
	pass

func _on_MatchMenu_on_back_pressed():
	$Control/MatchMenu.hide_ui()
	$Control/MainLobbyMenu.show_ui()
	NetworkHead.matchmaker_to_player.leave_match(active_match_id)
	pass

func _on_MatchMenu_on_tried_to_start_game():
	pass
