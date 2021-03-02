extends Node2D

var world_to_player : WorldToPlayer
var gateway_to_player : GateWayToPlayer
var matchmaker_to_player : MatchMakerToPlayer

func _ready():
	world_to_player = get_node("WorldToPlayer")
	gateway_to_player = get_node("GateWayToPlayer")
	matchmaker_to_player = get_node("MatchMakerToPlayer")
	pass
