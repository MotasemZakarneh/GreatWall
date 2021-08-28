extends Node2D
class_name WorldToPlayer

"""
Player App:
	Client To The World Of The Game
"""
var network : NetworkedMultiplayerENet

export var ip = "127.0.0.1"

export var tick_rate = 0.1
var timer = 0
var port = 1909

var console : Console
var match_name = ""

func _ready():
	console = ConsoleLoader.get_main(self)
	pass

func start_client():
	network = NetworkedMultiplayerENet.new()
	var _er = network.create_client(ip,port)
	get_tree().network_peer = network
	
	console.write ("ClientApp: Client To World/Server :: Has Started")
	_er = network.connect("connection_succeeded",self,"_on_connected_to_server")
	_er = network.connect("connection_failed",self,"_on_connection_failed")
	pass

func _on_connected_to_server():
	console.write("Have Connected To World :: " + match_name)
	pass

func _on_connection_failed():
	console.write("Failed to connect to server :: " + match_name)
	pass

func join_match(m_name,_port):
	self.port = _port
	self.match_name = m_name
	console.write("Trying To Join Match " + match_name + " :: " + str(_port))
	start_client()
	pass
