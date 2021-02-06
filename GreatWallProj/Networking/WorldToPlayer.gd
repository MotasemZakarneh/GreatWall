extends Node2D
class_name WorldToPlayer

"""
Player App:
	Client To The World Of The Game
"""
var network : NetworkedMultiplayerENet

export var port = 1909
export var ip = "127.0.0.1"

export var tick_rate = 0.1
var timer = 0
var is_networked = false

func _ready():
	#start_client()
	pass

func start_client():
	network = NetworkedMultiplayerENet.new()
	var _er = network.create_client(ip,port)
	get_tree().network_peer = network
	
	print ("ClientApp: Client To World/Server :: Has Started")
	_er = network.connect("connection_succeeded",self,"_on_connected_to_server")
	_er = network.connect("connection_failed",self,"_on_connection_failed")
	pass

func _on_connected_to_server():
	is_networked = true
	print("Have Connected To Server")
	pass

func _on_connection_failed():
	print("Failed to connect to server")
	is_networked = false
	pass

