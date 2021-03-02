extends Node2D
class_name MatchMakerToPlayer

signal on_connected_to_match_maker

var network : NetworkedMultiplayerENet
var mp : MultiplayerAPI

export var port = 1913
export var ip = "127.0.0.1"
var console : Console

signal on_token_compared(result)

func _ready():
	console = ConsoleLoader.get_main(self)
	pass

func _process(_delta):
	if get_custom_multiplayer() == null:
		return
	if not custom_multiplayer.has_network_peer():
		return
	
	custom_multiplayer.poll()
	pass

func _start_client():
	network = NetworkedMultiplayerENet.new()
	mp = MultiplayerAPI.new()
	var _er = network.create_client(ip,port)
	set_custom_multiplayer(mp)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)
	
	console.write("ClientApp :: Client To MatchMaker :: Has Started")
	_er = network.connect("connection_succeeded",self,"_on_connected_to_server")
	_er = network.connect("connection_failed",self,"_on_connection_failed")
	pass

func _on_connected_to_server():
	console.write("Client App: Connected To MatchMaker")
	emit_signal("on_connected_to_match_maker")
	cs_login()
	pass

func _on_connection_failed():
	console.write("ClientApp: Failed To Connect To MatchMaker")
	network.disconnect("connection_succeeded",self,"_on_connected_to_server")
	network.disconnect("connection_failed",self,"_on_connection_failed")
	pass

func connect_to_matchmatcher():
	_start_client()
	pass

remote func r_try_login(result,match_name,match_port):
	console.write(str(result) + " :: Login Result")
	emit_signal("on_token_compared",result)
	pass

func cs_login():
	console.write("Requesting Login From MatchMaker")
	var token = NetworkHead.gateway_to_player.last_recieved_token
	rpc_id(1,"c_try_login",token)
	pass
