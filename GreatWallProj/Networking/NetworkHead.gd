extends Node2D

var world_server : WorldServer
var server_client_bridge : ServerClientBridge
var gateway_to_player : GateWayToPlayer

func _ready():
	world_server = get_node("WorldServer")
	server_client_bridge = get_node("ServerClientBridge")
	gateway_to_player = get_node("GateWayToPlayer")
	pass
