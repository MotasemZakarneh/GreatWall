extends Node2D
class_name ServerClientBridge

remote func request_rnd_val(requester_node_name,requester_node_path):
	var requester_player_id = get_tree().get_rpc_sender_id()
	var rnd_val = randi()%9000
	
	print(str(requester_node_name) + " :: " + str(requester_node_path) 
									+ " :: Has Requested Val :: " + str(rnd_val) + 
									" With Player Id Of  " + str(requester_player_id))
	
	rpc_id(requester_player_id,"recieve_rnd_val",requester_node_name,requester_node_path,rnd_val)
	
	pass
