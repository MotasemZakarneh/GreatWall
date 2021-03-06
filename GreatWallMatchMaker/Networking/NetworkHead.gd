extends Node2D

var match_maker_to_player : MatchMakerToPlayer
var match_maker_data : MatchMakerData
export (Array,String) var curr_matches =  []

func _ready():
	match_maker_to_player = get_node("MatchMakerToPlayer")
	match_maker_data = get_node("MatchMakerData")
	pass
