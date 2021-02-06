extends Node2D
class_name ServerClientBridge

var server = null
var timer = 0
var tick_rate = 0.1

func is_networked()->bool:
	if server == null:
		return false
	return server.is_networked

func _ready():
	server = NetworkHead.world_to_player
	pass

func _process(delta):
	if not is_networked():
		return
	
	timer = timer + delta/tick_rate
	if timer>=1:
		timer = 0
		print("Requesting Data From SErver")
		s_request_rnd_val()
	pass

func s_request_rnd_val():
	rpc_id(1,"request_rnd_val",name,get_path())
	pass

remote func recieve_rnd_val(_requester_node_name,requester_node_path,rnd_val):
	print("Recieved, Val " + str(rnd_val) + " : To Node Of Path " + requester_node_path)
	pass
