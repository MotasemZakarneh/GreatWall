extends Node2D
class_name GateWayToPlayer

"""
Gateway App: 
	Server to The Player/Client
"""

var network : NetworkedMultiplayerENet
var mp : MultiplayerAPI
export var port = 1910
export var max_players = 4000

export var players_count = 0

func _ready():
	start_server()
	pass
func _process(_delta):
	if get_custom_multiplayer() == null:
		return
	
	if not custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll()
	pass

func start_server():
	network = NetworkedMultiplayerENet.new()
	mp = MultiplayerAPI.new()
	var _er = network.create_server(port,max_players)
	
	if _er != OK:
		print("Failed To Create Server because :: " + str(_er))
	else:
		set_custom_multiplayer(mp)
		custom_multiplayer.set_root_node(self)
		custom_multiplayer.set_network_peer(network)
		print ("GateWayApp :: ServerToClients :: Has Started")
	
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

remote func s_login_request(username,password):
	print("Gateway App :: Login Request Recieved ")
	var id = custom_multiplayer.get_rpc_sender_id()
	NetworkHead.auth_to_gateway.cs_authenticate_player(username,password,id)
	pass

func r_login_request(result,player_id):
	rpc_id(player_id,"r_login_request",result)
	network.disconnect_peer(player_id)
	pass
