extends Node2D

var auth_to_gateway : AuthToGateWay
var auth_to_match_maker : AuthToMatchMaker
var console : Console

const def_mm = "MatchMaker1"

func _ready():
	yield(get_tree(),"idle_frame")
	auth_to_gateway = get_node("AuthToGateWay")
	auth_to_match_maker = get_node("AuthToMatchMaker")
	console = ConsoleLoader.get_main(self)
	pass
