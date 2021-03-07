extends Node2D

var world_to_player : WorldToPlayer
var match_maker_to_world : MatchMakerToWorld

func _ready():
	world_to_player = get_node("WorldToPlayer")
	match_maker_to_world = get_node("MatchMakerToWorld")
	pass
