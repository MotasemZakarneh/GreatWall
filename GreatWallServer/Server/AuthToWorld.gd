extends Node2D
class_name AuthToWorld

"""
World/World App:
	Client To Authenticator
"""

var network : NetworkedMultiplayerENet
var mp : MultiplayerAPI

export var port = 1912
export var ip = "127.0.0.1"

func _ready():
	_start_client()
	pass

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
	
	print ("World/Server App :: Client To Authenticator :: Has Started")
	_er = network.connect("connection_succeeded",self,"_on_connected_to_server")
	_er = network.connect("connection_failed",self,"_on_connection_failed")
	pass

func _on_connected_to_server():
	print("World/Server App: Connected To Authenticator")
	pass

func _on_connection_failed():
	print("Failed to connect to server")
	network.disconnect("connection_succeeded",self,"_on_connected_to_server")
	network.disconnect("connection_failed",self,"_on_connection_failed")
	pass
