extends Node2D
class_name MatchMakerToPlayer

signal on_connected_to_match_maker


var network : NetworkedMultiplayerENet
var mp : MultiplayerAPI

export var port = 1913
export var ip = "127.0.0.1"

func _process(_delta):
	if get_custom_multiplayer() == null:
		return
	if not custom_multiplayer.has_network_peer():
		return
	
	custom_multiplayer.poll()
	pass

func _start_client():
	network = NetworkedMultiplayerENet.new()
	mp = MultiplayerAPI.new()
	var _er = network.create_client(ip,port)
	set_custom_multiplayer(mp)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)
	
	print ("ClientApp :: Client To MatchMaker :: Has Started")
	_er = network.connect("connection_succeeded",self,"_on_connected_to_server")
	_er = network.connect("connection_failed",self,"_on_connection_failed")
	pass

func _on_connected_to_server():
	print("Client App: Connected To MatchMaker")
	emit_signal("on_connected_to_match_maker")
	pass

func _on_connection_failed():
	print("ClientApp: Failed To Connect To MatchMaker")
	network.disconnect("connection_succeeded",self,"_on_connected_to_server")
	network.disconnect("connection_failed",self,"_on_connection_failed")
	pass

func connect_to_matchmatcher():
	_start_client()
	pass
