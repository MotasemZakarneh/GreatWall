extends Node2D

var world_to_player : WorldToPlayer
var con_starter : ConStarter

func _ready():
	world_to_player = get_node("WorldToPlayer")
	con_starter = get_node("ConStarter")
	pass
