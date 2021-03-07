extends Node2D
class_name MatchMakerToPlayer

"""
MatchMakerApp:
	Server To Player
Responsible for:
	match making between players, and creating gameservers
"""

export var requests_clean_up_time = 30
export var port = 1913
export var max_players = 4000

var network : NetworkedMultiplayerENet
var unmatched_players = []
var matched_players = []
var expected_players = []
var console : Console

func _ready():
	console = ConsoleLoader.get_main(self)
	_start_server()
	pass

func _start_server():
	network = NetworkedMultiplayerENet.new()
	var _er = network.create_server(port,max_players)
	
	if _er == OK:
		get_tree().network_peer = network
		multiplayer.set_root_node(self)
		
		console.write("MatchMakerApp: ServerToPlayer Created Successfully")
	else:
		console.write_warn("MatchMakerApp: ServerToPlayer Failed To Be Created Because " + str(_er))
	
	_er = network.connect("peer_connected",self,"_on_player_connected")
	_er = network.connect("peer_disconnected",self,"_on_player_disconnected")
	
	pass

func _on_player_connected(_player_id):
	console.write("Player " + str(_player_id) + " :: Has Connected")
	unmatched_players.append(_player_id)
	
	if unmatched_players.size() == 2:
		_match_make_players()
	pass

func _on_player_disconnected(_player_id):
	console.write("Player " + str(_player_id) + " :: Has DisConnected")
	unmatched_players.erase(_player_id)
	pass

func _match_make_players():
	
	pass

func expect_player(token):
	console.write("Start Expecting Player " + str(token))
	expected_players.append(token)
	yield(get_tree().create_timer(requests_clean_up_time),"timeout")
	if expected_players.has(token):
		console.write("Stopped Expecting " + str(token))
		expected_players.erase(token)
	pass

remote func c_try_login(token):
	var sender = get_tree().get_rpc_sender_id()
	console.write("Recieved, Login Request " + str(token))
	var result = false
	var match_name = ""
	var match_port = 0
	
	if expected_players.has(token):
		expected_players.erase(token)
		result = true
		var m = yield(NetworkHead.match_maker_data.get_first_joinable_match_async(),"completed")
		match_name = m["match_name"]
		match_port = m["port"]
	
	console.write("Result, of login request " + str(result))
	
	rpc_id(sender,"r_try_login",result,match_name,match_port)
	
	network.disconnect_peer(sender)
	pass
