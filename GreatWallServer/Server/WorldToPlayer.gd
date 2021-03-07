extends Node2D
class_name WorldToPlayer

"""
Server/World app:
	Being, Server to The Clients/Players
"""

var network : NetworkedMultiplayerENet = NetworkedMultiplayerENet.new()
export var players_count = 0

var console:Console
var started_con = false

func _ready():
	console = ConsoleLoader.get_main(self)
	var _er = connect("tree_exiting",self,"_on_closing")
	
	while not started_con:
		console.write("Trying To Find Match For This World")
		yield(get_tree().create_timer(1),"timeout")
	pass

func begin_con():
	var m = _get_match_data()
	if m.size()==0:
		return
	started_con = true
	var port = m["port"]
	var max_players = m["max_players"]
	var match_name = m["match_name"]
	console.write("Assigned Build To " + match_name)
	
	_start_server(port,max_players)
	pass

func _start_server(port,max_players):
	var _er = network.create_server(port,max_players)
	
	if _er != OK:
		print("Failed To Create Server because :: " + str(_er))
	else:
		get_tree().network_peer = network
		console.write ("World/Server Has Started")
	
	var _e = network.connect("peer_connected",self,"_on_client_connected")
	_e = network.connect("peer_disconnected",self,"_on_client_disconnected")
	pass

func _on_client_connected(player_id):
	console.write("User " + str(player_id) + " Has Connected")
	players_count = players_count + 1
	_add_player(player_id)
	pass

func _on_client_disconnected(player_id):
	console.write("User " + str(player_id) + " Has DisConnected")
	players_count = players_count - 1
	_remove_player(player_id)
	if players_count == 0:
		get_tree().call_deferred("quit")
	pass

func _on_closing():
	var m = _get_match_data()
	if m.size() == 0:
		return
	
	m["is_over"] = true
	pass

func _add_player(player_id):
	var m = _get_match_data()
	m["curr_players"].append(player_id)
	m["joined_players"].append(player_id)
	pass

func _remove_player(player_id):
	var m = _get_match_data()
	var curr_players : Array = m["curr_players"]
	curr_players.erase(player_id)
	pass

func _get_match_data():
	return NetworkHead.match_maker_to_world.get_match_data()
