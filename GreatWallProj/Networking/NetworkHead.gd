extends Node2D

var world_to_player : WorldToPlayer
var server_client_bridge : ServerClientBridge
var gateway_to_player : GateWayToPlayer
var matchmaker_to_player : MatchMakerToPlayer

func _ready():
	world_to_player = get_node("WorldToPlayer")
	server_client_bridge = get_node("ServerClientBridge")
	gateway_to_player = get_node("GateWayToPlayer")
	matchmaker_to_player = get_node("MatchMakerToPlayer")
	pass
