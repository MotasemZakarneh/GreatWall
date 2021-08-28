extends NetworkManager
class_name MatchMakerToPlayer

signal r_on_match_created(match_data)
signal r_create_match_response(response,id)

signal r_on_player_left(player)
signal r_on_player_joined(player,player_name)
signal r_on_recieved_existing_players_data(players_lobby_data)

signal r_on_recieved_existing_matches_data(existing_matches_data)

var players_lobby_data = {}
var matches_data = {}

#Client Code
func _on_connected_to_server(id):
	var player_name = NetworkHead.player_name
	console.write("Telling Existing Players My Name : "+str(player_name))
	rpc_id(1,"s_spread_player_name",local_player,player_name)
	pass

func _on_player_left(_player):
	emit_signal("r_on_player_left",_player)
	#lobby.remove_player(_player)
	pass

func create_match(match_name,match_pw,match_size):
	console.write("Sending Create Match Request " + match_name)
	rpc_id(1,"s_create_match_request",match_name,match_pw,match_size)
	pass

func leave_match(match_id):
	console.write("Leaving Match :: " + str(match_id))
	rpc_id(1,"s_leave_match",match_id)
	pass

remote func r_recieve_player_name(player,player_name):
	console.write("Recieved Player Name : " + str(player) + " : " + player_name)
	#lobby.add_player_by_name(player,player_name)
	emit_signal("r_on_player_joined",player,player_name)
	pass

remote func r_recieve_existing_matches_data(existing_matches_data):
	matches_data = existing_matches_data
	emit_signal("r_on_recieved_existing_matches_data",matches_data)
	pass

remote func r_recieve_existing_players_data(existing_players_data):
	players_lobby_data = existing_players_data.duplicate(true)
	console.write("Recieved, Existing Players Data " + str(players_lobby_data))
	if not players_lobby_data.has(local_player):
		players_lobby_data[local_player] = NetworkHead.player_name
	emit_signal("r_on_recieved_existing_players_data",players_lobby_data)
	#lobby.refresh_players(players_lobby_data)
	pass

remote func r_on_create_match_response(response,id):
	console.write("Recieved, Match Creation Response with resullt " + str(response))
	emit_signal("r_create_match_response",response,id)
	pass

remote func r_on_match_created(match_data):
	console.write("A New Match Was Created with Name " + match_data["name"])
	matches_data[match_data["id"]] = match_data
	emit_signal("r_on_match_created",match_data)
	pass

remote func r_on_host_left_match(host):
	console.write_warn("Not Implemented When Host Leaves Match")
	pass

remote func r_on_host_leave_response(response):
	console.write_warn("Host Left Match, not implementd yet")   
	pass

remote func r_update_match(match_id,players_in_match):
	console.write_warn("Should Update Playesr Count In Match, not implemented yet")
	pass

#Server Code

signal s_on_match_deleted(match_id)

func _s_on_player_joined(player):
	._s_on_player_joined(player)
	console.write("New Player Joined, Sending Him Existing Players Names")
	var cleaned_data = players_lobby_data.duplicate(true)
	if cleaned_data.has(player):
		cleaned_data.erase(player)
	rpc_id(player,"r_recieve_existing_players_data",cleaned_data)
	rpc_id(player,"r_recieve_existing_matches_data",matches_data)
	pass

func _s_on_player_left(player):
	._s_on_player_left(player)
	console.write("Player Left, Updating, Players Lobby Data")
	if players_lobby_data.has(player):
		players_lobby_data.erase(player)
	pass

remote func s_spread_player_name(player,player_name):
	console.write("Sending Player Name " + player_name + " : to Other players")
	players_lobby_data[player] = player_name
	
	for p in players:
		if p == player:
			continue
		rpc_id(p,"r_recieve_player_name",player,player_name)
	pass

remote func s_create_match_request(match_name,match_pw,match_size):
	var caller = get_rpc_sender_id()
	var id = matches_data.size()
	matches_data[id] = {
		"id":id,"name":match_name,
		"pw":match_pw,"players":[caller],
		"host":caller,"max_players":match_size,
		"map":"SomeMap"
	}
	rpc_id(caller,"r_on_create_match_response",true,id)
	send_rpc_to_all_clients("r_on_match_created",caller,matches_data[id])
	console.write("Creating Match By " + str(caller) + " : Of Name : " + match_name)
	pass

remote func s_join_match_request(match_id):
	var player = get_rpc_sender_id()
	var result = false
	if matches_data.has(match_id):
		matches_data[match_id]["players"].append(player)
		result = true
	else:
		result = false
	send_rpc_to_all_clients("r_join_match_request",player,result)
	pass

remote func s_leave_match(match_id):
	var player = get_rpc_sender_id()
	if matches_data.has(match_id):
		var players_in_match : Array = matches_data[match_id]["players"]
		var host = matches_data[match_id]["host"]
		if host == player:
			matches_data.erase(match_id)
			rpc_id(host,"r_on_host_leave_response",null,true)
			send_rpc_to_all_clients("r_on_host_left_match",null,host)
		elif host != player and players_in_match.has(player):
			players_in_match.erase(player)
			matches_data[match_id]["players"] = players_in_match
			if players_in_match.size() == 0:
				matches_data.erase(match_id)
			rpc_id(0,"r_update_match",match_id,players_in_match)
	pass
