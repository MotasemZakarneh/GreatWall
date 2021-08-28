extends Node2D
class_name GatewayToPlayer

"""
Player App:
	Player Acting As Client To Gateway
"""

var network : NetworkedMultiplayerENet = null
var mp : MultiplayerAPI = null

export var port = 8000
export var ip = "127.0.0.1"

var console : Console
var last_username = ""
var last_pwd = ""

func _ready():
	console = ConsoleLoader.get_main(self)
	pass

func _process(_delta):
	if custom_multiplayer == null:
		return
	if not custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll()
	pass

func _connected_to_server():
	console.write("Connection Successful")
	c_send_login_request()
	pass

func _connect_fail():
	console.write("Connection Failed")
	pass
	
func _server_disconnected():
	console.write("Server Disconnected")
	pass

func start_client():
	network = NetworkedMultiplayerENet.new()
	mp = MultiplayerAPI.new()
	
	var _er = network.create_client(ip,port)
	custom_multiplayer = mp
	custom_multiplayer.root_node = self
	custom_multiplayer.network_peer = network
	
	_er = network.connect("connection_succeeded", self, "_connected_to_server")
	_er = network.connect("connection_failed", self, "_connect_fail")
	console.write("ClientApp: ClientToGateWay Started")
	pass

func on_login_clicked(username,pwd):
	console.write("Attempting To Login : " + str(username) + " : pwd : " + str(pwd))
	last_username = username
	last_pwd = pwd
	start_client()
	pass

func c_send_login_request():
	rpc_id(0,"s_send_login_request",last_username,last_pwd)
	pass

remote func r_recieve_login_result(_username,_pwd,_result):
	console.write("Login Request Completed For " + str(_username))
	console.write("Login REsult Is " + str(_pwd))
	pass
