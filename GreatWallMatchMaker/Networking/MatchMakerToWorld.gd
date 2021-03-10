extends Node2D
class_name MatchMakerToWorld

export var max_worlds = 4000
export var port = 1914

var curr_worlds = []
var unused_worlds = []

var network : NetworkedMultiplayerENet
var mp : MultiplayerAPI
var console : Console

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
	var _er = network.create_server(port,max_worlds)
	
	if _er == OK:
		console.write("MatchMaker App: Server To Worlds Has Started")
		custom_multiplayer = mp
		custom_multiplayer.network_peer = network
		custom_multiplayer.set_root_node(self)
	else:
		console.write("MatchMaker App: Server To Worlds failed with " + str(_er))
	
	_er = network.connect("peer_connected",self,"_on_world_connected")
	_er = network.connect("peer_disconnected",self,"_on_world_disconnected")
	pass

func _on_world_connected(world_id):
	console.write("World " +str(world_id) + " Has Connected")
	curr_worlds.append(world_id)
	unused_worlds.append(world_id)
	pass

func _on_world_disconnected(world_id):
	console.write("World " +str(world_id) + " Has DisConnected")
	curr_worlds.erase(world_id)
	
	if unused_worlds.has(world_id):
		unused_worlds.erase(world_id)
	pass

func cs_assign_world_to_match():
	if unused_worlds.size()==0:
		return
	
	var world_id = unused_worlds[0]
	unused_worlds.remove(0)
	var m = NetworkHead.match_maker_data.process_pending_match()
	if m.size()==0:
		return
	console.write("assigning world to match " +m["match_name"])
	rpc_id(world_id, "c_assign_world_to_match", m)
	pass

remote func r_assign_world_to_match(match_data):
	var match_name = match_data["match_name"]
	var world_id = match_data["owner"]
	console.write(match_name + " was assigned successfully for " + str(world_id))
	NetworkHead.match_maker_data.on_match_assigned(match_name,match_data)
	pass

remote func c_update_match_data(match_data):
	NetworkHead.match_maker_data.update_match_data(match_data)
	pass
