extends Node2D

var match_maker_to_player : MatchMakerToPlayer
var match_maker_data : MatchMakerData
var match_maker_to_world : MatchMakerToWorld

func _ready():
	match_maker_to_player = get_node("MatchMakerToPlayer")
	match_maker_data = get_node("MatchMakerData")
	match_maker_to_world = get_node("MatchMakerToWorld")
	pass
