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
var console : Console

func _ready():
	console = ConsoleLoader.get_main(self)
	start_server()
	pass

func start_server():
	network = NetworkedMultiplayerENet.new()
	var _er = network.create_server(port,max_gateways)
	
	if _er != OK:
		console.write_warn("Failed To Create Server because :: " + str(_er))
	else:
		get_tree().network_peer = network
		var msg = "ServerToGateway :: Has Started"
		console.write(msg)
	
	_er = network.connect("peer_connected",self,"_on_client_connected")
	_er = network.connect("peer_disconnected",self,"_on_client_disconnected")
	pass

func _on_client_connected(gateway_id):
	console.write("Gateway " + str(gateway_id) + " Has Connected")
	gateways_count = gateways_count + 1
	pass

func _on_client_disconnected(gateway_id):
	console.write("Gateway " + str(gateway_id) + " Has DisConnected")
	gateways_count = gateways_count - 1
	pass

remote func s_authenticate_player(_username,_password,player_id):
	console.write("Trying To Authenticate Player " + str(_username))
	var gateway_id = get_tree().get_rpc_sender_id()
	var result = is_data_valid(_username,_password)
	var token = ""
	
	if result:
		token = get_token()
		var mm = NetworkHead.def_mm#TODO: Implement, other lobbies
		NetworkHead.auth_to_match_maker.cs_distribute_token(token,mm)
		pass
	
	rpc_id(gateway_id,"r_authenticate_player",result,player_id,token)
	pass

func is_data_valid(_username,_password):
	#TODO: Implement, DataValidation, 
	#checking whether these details exist
	return true

func get_token():
	randomize()
	var rand_num = randi()
	var hashed_num = str(rand_num).sha256_text()
	var now = str(OS.get_unix_time())
	var token = hashed_num + now
	
	return token
