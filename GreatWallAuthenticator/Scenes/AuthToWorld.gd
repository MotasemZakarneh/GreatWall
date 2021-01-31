extends Node2D
class_name AuthToWorld

"""
Authenticator App:
	Server To GameWorlds
"""

var network : NetworkedMultiplayerENet
var mp : MultiplayerAPI

export var port = 1912
export var max_worlds = 10

export var worlds_count = 0

func _ready():
	start_server()
	pass

func _process(_delta):
	if get_custom_multiplayer() == null:
		return
	if not get_custom_multiplayer().has_network_peer():
		return
	custom_multiplayer.poll()
	pass

func start_server():
	network = NetworkedMultiplayerENet.new()
	mp = MultiplayerAPI.new()
	var _er = network.create_server(port,max_worlds)
	
	if _er != OK:
		print("Failed To Create Server because :: " + str(_er))
	else:
		set_custom_multiplayer(mp)
		custom_multiplayer.set_root_node(self)
		custom_multiplayer.set_network_peer(network)
		print ("Authenticator App: ServerToWorld :: Has Started")
	
	_er = network.connect("peer_connected",self,"_on_client_connected")
	_er = network.connect("peer_disconnected",self,"_on_client_disconnected")
	pass

func _on_client_connected(world_id):
	print("World " + str(world_id) + " Has Connected")
	worlds_count = worlds_count + 1
	pass

func _on_client_disconnected(world_id):
	print("World " + str(world_id) + " Has DisConnected")
	worlds_count = worlds_count - 1
	pass
