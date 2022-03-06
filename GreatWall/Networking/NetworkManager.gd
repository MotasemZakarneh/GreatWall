extends Node
class_name NetworkManager

signal on_connected_to_server(id)
signal on_connection_to_server_failed

@export var is_custom_mp = false

var network : ENetMultiplayerPeer = null
var mp : MultiplayerAPI = null
var console : Console

var players = []
var local_player = -1

func _ready():
	console = Console.get_main(self)
	_i_ready()
	pass

func _process(_delta):
	_i_process(_delta)
	if not is_custom_mp:
		return
	if custom_multiplayer == null:
		return
	if not custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll()
	pass

func _i_ready():
	pass

func _i_process(_delta):
	pass

func _stop_connection():
	if network == null:
		return
	
	network.close_connection(1)
	if is_custom_mp:
		network = null
		custom_multiplayer.network_peer = null
		custom_multiplayer = null
	else:
		network = null
		get_tree().network_peer = null
	pass

func setup_mp_for_children():
	if not is_custom_mp:
		return
	
	var children = []
	Extentions.get_children_recursively(self,children)
	for c in children:
		c.custom_multiplayer = mp
	pass

func get_rpc_sender_id():
	if is_custom_mp:
		return custom_multiplayer.get_rpc_sender_id()
	return get_tree().multiplayer.get_rpc_sender_id()

func is_connected_to_net():
	return is_client_running or is_server_running

#Client Code
#@export var connection_ip = "40.85.96.132"
@export var address = "127.0.0.1"
@export var port = 8002
var is_client_running = false

func start_client_def():
	return start_client(address,port)

func start_client(_address,_port):
	is_client_running = true
	network = ENetMultiplayerPeer.new()
	var _er = network.create_client(_address,_port)
	
	if _er != OK:
		return _er
	
	if is_custom_mp:
		mp = MultiplayerAPI.new()
		custom_multiplayer = mp
		custom_multiplayer.network_peer = network
		custom_multiplayer.root_node = self
	else:
		get_tree().network_peer = network
	
	_er = network.connect("connection_succeeded",_connection_success)
	_er = network.connect("connection_failed",_connection_failed)
	_er = network.connect("server_disconnected",_on_server_disconnected)
	_er = network.connect("peer_connected",_on_peer_connected)
	_er = network.connect("peer_disconnected",_on_peer_disconnected)
	
	port = _port
	address = _address
	
	setup_mp_for_children()
	_on_client_started()
	return OK

func stop_client():
	players.clear()
	_stop_connection()
	is_client_running = false
	_on_client_stopped()
	pass

func _connection_success():
	console.write(str(name) + " :: Connected To " + str(name) +" :: as " +str(network.get_unique_id()) )
	players.append(network.get_unique_id())
	local_player = network.get_unique_id()
	emit_signal("on_connected_to_server",local_player)
	_on_connected_to_server(local_player)
	pass

func _connection_failed():
	console.write(str(name) + " :: Connection Failed To " + str(name))
	emit_signal("on_connection_to_server_failed")
	_on_connection_failed_to_server()
	pass

func _on_peer_connected(_player):
	await get_tree().idle_frame
	if _player == 1:
		return
	players.append(_player)
	_on_player_joined(_player)
	console.write_good("Player Joined :: " + str(_player) + " :: all players :: " + str(players))
	pass

func _on_peer_disconnected(_player):
	await get_tree().idle_frame
	if _player == 1:
		return
	players.erase(_player)
	console.write_good("Player Left " + str(_player) + " :: all players :: " + str(players))
	_on_player_left(_player)
	pass

func _on_client_started():
	pass

func _on_client_stopped():
	pass

func _on_player_joined(_player):
	pass

func _on_player_left(_player):
	pass

func _on_connected_to_server(_id):
	pass

func _on_connection_failed_to_server():
	pass

func _on_server_disconnected():
	console.write(str(name) + " :: server has disconnected")
	pass

@rpc func r_recieve_player_address(player,_address,_port):
	console.write("Recieved Player Address " + str(player) + " : "+str(_address) + " : " + str(_port))
	pass

#Server Code
var is_server_running = false
@export var max_players = 4000

func start_server_def():
	return start_server(port)

func start_server(_port):
	is_server_running = true
	
	network = ENetMultiplayerPeer.new()
	var _er = network.create_server(_port,max_players)
	if _er != OK:
		return _er
	
	if is_custom_mp:
		mp = MultiplayerAPI.new()
		custom_multiplayer = mp
		custom_multiplayer.network_peer = network
		custom_multiplayer.root_node = self
	else:
		get_tree().network_peer = network
	
	_er = network.connect("peer_connected",_s_on_peer_connected)
	_er = network.connect("peer_disconnected",_s_on_peer_disconnected)
	
	console.write(str(name) + " :: Started As Server To Player :: Port :: " + str(_port))
	
	port = _port
	local_player = 1
	
	setup_mp_for_children()
	_s_on_server_started()
	return OK

func stop_server():
	players.clear()
	_stop_connection()
	is_server_running = false
	_s_on_server_stopped()
	pass

func _s_on_peer_connected(client):
	console.write("Player Joined " + str(client))
	await get_tree().idle_frame
	players.append(client)
	_s_on_player_joined(client)
	pass

func _s_on_peer_disconnected(client):
	console.write("Player Left " + str(client))
	await get_tree().idle_frame
	players.erase(client)
	_s_on_player_left(client)
	pass

func _s_on_player_joined(_player):
	pass

func _s_on_player_left(_player):
	pass

func _s_on_server_started():
	pass

func _s_on_server_stopped():
	pass

@rpc func s_request_player_address(player):
	if not players.has(player):
		return
	
	var _address = network.get_peer_address(player)
	var _port = network.get_peer_port(player)
	var caller = get_rpc_sender_id()
	rpc_id(caller,"r_recieve_player_address",player,_address,_port)
	console.write("sending address to " + str(caller))
	pass

#Helper Functions:
func send_rpc_to_all_clients(rpc_func,exclusions=null,vars=null):
	for p in players:
		if exclusions != null and (p == exclusions or exclusions.has(p)):
			continue
		if vars != null:
			rpc_id(p,rpc_func,vars)
		else:
			rpc_id(p,rpc_func)
	pass
