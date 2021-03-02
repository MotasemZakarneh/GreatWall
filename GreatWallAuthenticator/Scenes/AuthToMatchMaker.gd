extends Node2D
class_name AuthToMatchMaker

"""
Auth app:
	Server To MatchMakers
"""

export var port = 1919
export var max_makers = 8

var network : NetworkedMultiplayerENet
var mp : MultiplayerAPI

var console : Console
var makers = {}

func _ready():
	console = ConsoleLoader.get_main(self)
	start_server()
	pass

func _process(_delta):
	if custom_multiplayer == null:
		return
	if not custom_multiplayer.has_network_peer():
		return
	
	custom_multiplayer.poll()
	pass

func start_server():
	network = NetworkedMultiplayerENet.new()
	mp = MultiplayerAPI.new()
	
	var _er = network.create_server(port,max_makers)
	if _er == OK:
		custom_multiplayer = mp
		custom_multiplayer.set_root_node(self)
		custom_multiplayer.network_peer = network
		
		console.write("AuthToMatchMaker Server Has Started")
	else:
		console.write_warn("AuthToMatchMaker ServerCreation Failed Because " + str(_er))
		pass
	
	_er = network.connect("peer_connected",self,"_on_mm_connected")
	_er = network.connect("peer_disconnected",self,"_on_mm_disconnected")
	pass

func _on_mm_connected(match_maker_id):
	makers[NetworkHead.def_mm] = match_maker_id
	console.write("AuthToMatchMaker :: MatchMaker " + str(match_maker_id) + " Has Connected")
	pass

func _on_mm_disconnected(match_maker_id):
	makers.erase(NetworkHead.def_mm)
	console.write("AuthToMatchMaker :: MatchMaker " + str(match_maker_id) + " Has DisConnected")
	pass

func cs_distribute_token(token,match_maker):
	var mm_id = makers[match_maker]
	rpc_id(mm_id,"c_distribute_token",token)
	pass
