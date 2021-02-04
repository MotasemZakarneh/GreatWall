extends Node2D
class_name MatchMakerToPlayer

"""
MatchMakerApp:
	Server To Player
Responsible for:
	match making between players, and creating gameservers
"""

export var port = 1913
export var max_players = 4000
export var is_in_editor = false

var network : NetworkedMultiplayerENet
var unmatched_players = []
var matched_players = []

func _ready():
	_start_server()
	pass

func _process(_delta):
	if Input.is_action_just_released("ui_accept"):
		_create_world()
	pass

func _start_server():
	network = NetworkedMultiplayerENet.new()
	var _er = network.create_server(port,max_players)
	
	if _er == OK:
		get_tree().network_peer = network
		print("MatchMakerApp: ServerToPlayer Created Successfully")
	else:
		print("MatchMakerApp: ServerToPlayer Failed To Be Created Because " + str(_er))
	
	_er = network.connect("peer_connected",self,"_on_player_connected")
	_er = network.connect("peer_disconnected",self,"_on_player_disconnected")
	
	pass

func _on_player_connected(_player_id):
	print("MatchMakerApp:: Player " + str(_player_id) + " :: Has Connected")
	unmatched_players.append(_player_id)
	
	if unmatched_players.size() == 2:
		_match_make_players()
	pass

func _on_player_disconnected(_player_id):
	print("MatchMakerApp:: Player " + str(_player_id) + " :: Has DisConnected")
	unmatched_players.remove(_player_id)
	pass

func _match_make_players():
	
	pass

func _create_world():
	if is_in_editor:
		return
	var build_path = NetworkHead.match_maker_data.world_app_path
	var f = File.new()
	
	var build_exists = f.file_exists(build_path)
	
	if not build_exists:
		print("Executbile Of Game world does not exist " + build_path)
		return
	
	print("Openig Executible Of Game World :: " + build_path)
	var output = []
	var _res = OS.execute(build_path,[],false,output)
	pass
