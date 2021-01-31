extends Node2D

var auth_to_gateway : AuthToGateWay
var gateway_to_player : GateWayToPlayer

func _ready():
	auth_to_gateway = get_node("AuthToGateWay")
	gateway_to_player = get_node("GateWayToPlayer")
	pass
