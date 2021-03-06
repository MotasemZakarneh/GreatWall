extends Node2D
class_name WorldToPlayer

"""
Server/World app:
	Being, Server to The Clients/Players
"""

var network : NetworkedMultiplayerENet = NetworkedMultiplayerENet.new()
export var players_count = 0

var console:Console

func _ready():
	console = ConsoleLoader.get_main(self)
	pass

func start_server_async(port,max_players):
	var _er = network.create_server(port,max_players)
	
	if _er != OK:
		print("Failed To Create Server because :: " + str(_er))
	else:
		get_tree().network_peer = network
		console.write ("World/Server Has Started")
	
	var _e = network.connect("peer_connected",self,"_on_client_connected")
	_e = network.connect("peer_disconnected",self,"_on_client_disconnected")
	
	yield(get_tree(),"idle_frame")
	
	if _er == OK:
		NetworkHead.con_starter.on_match_is_ready()
	pass

func _on_client_connected(player_id):
	console.write("User " + str(player_id) + " Has Connected")
	players_count = players_count + 1
	NetworkHead.con_starter.add_player(player_id)
	pass

func _on_client_disconnected(player_id):
	console.write("User " + str(player_id) + " Has DisConnected")
	players_count = players_count - 1
	NetworkHead.con_starter.remove_player(player_id)
	if players_count == 0:
		get_tree().call_deferred("quit")
	pass
