extends Node2D
class_name WorldToPlayer

"""
Server/World app:
	Being, Server to The Clients/Players
"""

var network : NetworkedMultiplayerENet = NetworkedMultiplayerENet.new()
export var players_count = 0

func start_server(port,max_players):
	var _er = network.create_server(port,max_players)
	
	if _er != OK:
		print("Failed To Create Server because :: " + str(_er))
	else:
		get_tree().network_peer = network
		print ("World/Server Has Started")
	
	_er = network.connect("peer_connected",self,"_on_client_connected")
	_er = network.connect("peer_disconnected",self,"_on_client_disconnected")
	pass

func _on_client_connected(player_id):
	print("User " + str(player_id) + " Has Connected")
	players_count = players_count + 1
	pass

func _on_client_disconnected(player_id):
	print("User " + str(player_id) + " Has DisConnected")
	players_count = players_count - 1
	pass

