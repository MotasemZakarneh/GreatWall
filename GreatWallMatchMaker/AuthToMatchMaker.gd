extends Node2D
class_name AuthToMatchMaker

"""
MatchMakerApp: 
	Client To Authenticator
"""

export var port = 1919
export var ip = "127.0.0.1"

var network : NetworkedMultiplayerENet
var mp : MultiplayerAPI

var console : Console

func _ready():
	console = ConsoleLoader.get_main(self)
	start_client()
	pass

func _process(_delta):
	if custom_multiplayer == null:
		return
	if not custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll()
	pass

func start_client():
	network = NetworkedMultiplayerENet.new()
	mp = MultiplayerAPI.new()
	
	var _er = network.create_client(ip,port)
	if _er == OK:
		console.write("MatchMakerApp: ClientToAuth Created Succesfully")
		
		custom_multiplayer = mp
		custom_multiplayer.network_peer = network
		custom_multiplayer.set_root_node(self)
	else:
		console.write_warn("MatchMakerApp: ClientToAuth Created Succesfully " + str(_er))
	
	_er = network.connect("connection_succeeded",self,"con_succeded")
	_er = network.connect("connection_failed",self,"conn_failed")
	pass

func con_succeded():
	console.write("Connection To Authenticator: Success")
	pass

func conn_failed():
	console.write_warn("Connection To Authenticator: Failed")
	pass

remote func c_distribute_token(token):
	NetworkHead.match_maker_to_player.expect_player(token)
	pass
