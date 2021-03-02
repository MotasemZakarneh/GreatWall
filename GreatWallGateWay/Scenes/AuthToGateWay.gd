extends Node2D
class_name AuthToGateWay

"""
Gateway App:
	Client To The Authenticator
"""

var network : NetworkedMultiplayerENet

export var port = 1911
export var ip = "127.0.0.1"
var console:Console

func _ready():
	console = ConsoleLoader.get_main(self)
	start_client()
	pass

func start_client():
	network = NetworkedMultiplayerENet.new()
	var _er = network.create_client(ip,port)
	get_tree().network_peer = network
	
	console.write ("GateWayApp :: ClientToAuthenticator :: Has Started")
	
	_er = network.connect("connection_succeeded",self,"_on_connected_to_server")
	_er = network.connect("connection_failed",self,"_on_connection_failed")
	pass

func _on_connected_to_server():
	console.write("Gateway Connected To Server(Authenticator)")
	pass

func _on_connection_failed():
	console.write("Gateway Failed To Connect To Server(authenticator)")
	pass

func cs_authenticate_player(username,password,player_id):
	console.write("Gateway App: Sending Authenticate Request To Authentactor Server")
	rpc_id(1,"s_authenticate_player",username,password,player_id)
	pass

remote func r_authenticate_player(result,player_id,token):
	console.write("Authenticated Player Of ID : " + str(player_id))
	NetworkHead.gateway_to_player.r_login_request(result,player_id,token)
	pass
