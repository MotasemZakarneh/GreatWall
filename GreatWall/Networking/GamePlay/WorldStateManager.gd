extends Node

var owned_entities = []

func _process(_delta):
	
	pass

func add_entity(entity:Node):
	if not owned_entities.has(entity):
		owned_entities.append(entity)
	pass

func remove_entity(entity:Node):
	if owned_entities.has(entity):
		owned_entities.erase(entity)
	pass

#Server Code
@export var server_update_rate = 20
var server_world_state = {}
var update_counter = 0

func _server_process(delta):
	update_counter = update_counter + delta/server_update_rate
	if update_counter>=1:
		server_world_state["T"] = OS.get_system_time_msecs()
		rpc_unreliable("r_recieve_world_state",server_world_state)
		update_counter = 0
	pass

remote func s_recieve_world_state(new_world_state : Dictionary):
	if server_world_state["T"]<new_world_state["T"]:
		server_world_state = new_world_state.duplicate(true)
	pass

#Client Code
var client_world_state = {}
var last_client_world_state = 0

func _client_process():
	var new_world_state = {}
	new_world_state["T"] = OS.get_system_time_msecs()
	for e in owned_entities:
		new_world_state[e.get_net_id()] = e.get_state()
	rpc_unreliable_id(1,"s_recieve_world_state",new_world_state)
	pass

remote func r_recieve_world_state(new_world_state:Dictionary):
	if last_client_world_state<new_world_state["T"]:
		last_client_world_state = new_world_state["T"]
		client_world_state = new_world_state.duplicate(true)
	pass
