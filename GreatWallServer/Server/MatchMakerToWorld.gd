extends Node2D
class_name MatchMakerToWorld

"""
Server/World app:
	Client For Match Maker
"""

export var port = 1914
export var ip = "127.0.0.1"

var network : NetworkedMultiplayerENet
var mp : MultiplayerAPI
var console :Console

var curr_match : Dictionary

func get_match_data():
	return curr_match

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
		console.write("Client To MatchMaker has started")
		custom_multiplayer = mp
		custom_multiplayer.network_peer = network
		custom_multiplayer.set_root_node(self)
	else:
		console.write("Client To Match Maker Failed To Start")
	
	_er = network.connect("connection_succeeded",self,"_on_con_succeeded")
	_er = network.connect("connection_failed",self,"_on_con_failed")
	pass

func _on_con_succeeded():
	console.write("Connected To MatchMaker Successfully")
	pass

func _on_con_failed():
	console.write("Failed To Connect To MatchMaker")
	pass

remote func c_assign_world_to_match(m):
	curr_match = m
	var match_name = m["match_name"]
	m["owner"] = network.get_unique_id()
	console.write_good("Assigned World To " + match_name)
	NetworkHead.world_to_player.begin_con()
	rpc_id(1,"r_assign_world_to_match",m)
	pass
