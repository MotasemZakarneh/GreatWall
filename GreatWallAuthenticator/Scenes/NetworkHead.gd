extends Node2D

var auth_to_gateway : AuthToGateWay
var auth_to_world : AuthToWorld

func _ready():
	auth_to_gateway = get_node("AuthToGateWay")
	auth_to_world = get_node("AuthToWorld")
	pass
