extends Node2D
class_name GateWayToPlayer

"""
Player App:
	Client To Gateway
"""

var network : NetworkedMultiplayerENet
var mp : MultiplayerAPI

export var port = 1910
export var ip = "127.0.0.1"

var last_username
var last_password

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
	
	print ("ClientApp :: Client To Gateway :: Has Started")
	_er = network.connect("connection_succeeded",self,"_on_connected_to_server")
	_er = network.connect("connection_failed",self,"_on_connection_failed")
	pass

func _on_connected_to_server():
	print("Client App: Connected To Gateway, Sending Login Reqeuest")
	cs_login_request()
	pass

func _on_connection_failed():
	print("Failed to connect to server")
	network.disconnect("connection_succeeded",self,"_on_connected_to_server")
	network.disconnect("connection_failed",self,"_on_connection_failed")
	pass

func on_login_clicked(username,password):
	last_username = username
	last_password = password
	_start_client()
	pass

func cs_login_request():
	rpc_id(1,"s_login_request",last_username,last_password)
	last_username = ""
	last_password = ""
	pass

remote func r_login_request(result):
	print("Login Request Result Was  " + str(result))
	network.disconnect("connection_succeeded",self,"_on_connected_to_server")
	network.disconnect("connection_failed",self,"_on_connection_failed")
	pass
