extends Node2D

var matchmaker_to_player : MatchMakerToPlayer = null
var player_name = ""

func _ready():
	matchmaker_to_player = $MatchMakerToPlayer
	pass
