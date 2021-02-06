extends Node2D
class_name AuthToGateWay

"""
Authenticator App:
	Server To GateWay
"""

var network : NetworkedMultiplayerENet
export var port = 1911
export var max_gateways = 10

export var gateways_count = 0

func _ready():
	start_server()
	pass

func start_server():
	network = NetworkedMultiplayerENet.new()
	var _er = network.create_server(port,max_gateways)
	
	if _er != OK:
		print("Failed To Create Server because :: " + str(_er))
	else:
		get_tree().network_peer = network
		print ("Authenticator App: ServerToGateway :: Has Started")
	
	_er = network.connect("peer_connected",self,"_on_client_connected")
	_er = network.connect("peer_disconnected",self,"_on_client_disconnected")
	pass

func _on_client_connected(gateway_id):
	print("Gateway " + str(gateway_id) + " Has Connected")
	gateways_count = gateways_count + 1
	pass

func _on_client_disconnected(gateway_id):
	print("Gateway " + str(gateway_id) + " Has DisConnected")
	gateways_count = gateways_count - 1
	pass

remote func s_authenticate_player(_username,_password,player_id):
	print("Trying To Authenticate Player " + str(_username))
	var gateway_id = get_tree().get_rpc_sender_id()
	var result = true
	#TODO: Implement, proper verfication
	rpc_id(gateway_id,"r_authenticate_player",result,player_id)
	pass
