extends Node2D
class_name MatchMakerToWorld

"""
MatchMakerApp:
	Server To Worlds
Responsible for:
	Keeping Track Of Active Worlds
"""

export var max_worlds = 4000
export var port = 1914

var network : NetworkedMultiplayerENet
var mp : MultiplayerAPI

var worlds = []

func _ready():
	network = NetworkedMultiplayerENet.new()
	mp = MultiplayerAPI.new()
	
	var _er = network.create_server(port,max_worlds)
	
	if _er == OK:
		set_custom_multiplayer(mp)
		mp.set_root_node(self)
		mp.set_network_peer(network)
		print("MatchMakerApp: ServerToWorld Created Successfully")
	else:
		print("MatchMakerApp: ServerToWorld Failed To Be Created Because " + str(_er))
	
	_er = network.connect("peer_connected",self,"_on_world_connected")
	_er = network.connect("peer_disconnected",self,"_on_world_disconnected")
	pass

func _process(_delta):
	if get_custom_multiplayer() == null:
		return
	if not get_custom_multiplayer().has_network_peer():
		return
	custom_multiplayer.poll()
	pass

func _on_world_connected(_world_id):
	print("MatchMakerApp:: World " + str(_world_id) + " :: Has Connected")
	worlds.append(_world_id)
	
	cs_prepare_world_to_players(_world_id)
	pass

func _on_world_disconnected(_world_id):
	print("MatchMakerApp:: World " + str(_world_id) + " :: Has DisConnected")
	worlds.remove(_world_id)
	pass

func cs_prepare_world_to_players(world_id):
	print("MatchMakerApp: Sending Preparing World For Players")
	var new_port = NetworkHead.match_maker_data.get_ready_port()
	rpc_id(world_id,"s_prepare_world_for_players",new_port)
	pass

remote func r_prepare_world_to_players(world_id):
	
	pass
