extends Node2D

var world_server : WorldServer
var server_client_bridge : ServerClientBridge
var auth_to_world : AuthToWorld

func _ready():
	world_server = get_node("WorldServer")
	server_client_bridge = get_node("ServerClientBridge")
	auth_to_world = get_node("AuthToWorld")
	pass
