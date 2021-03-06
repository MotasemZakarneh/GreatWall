extends Node2D
class_name ConStarter

export var max_tries = 90
export var time_between_tries = 1

var data = {}
var console:Console
var m = {}
var match_name = ""

func _ready():
	var _er = connect("tree_exiting",self,"_on_closing")
	
	console = ConsoleLoader.get_main(self)
	$WorldsBuilderSaver.assign_file(GConstants.worlds_builder_file)
	$MatchesSaver.assign_file(GConstants.matches_file_name)
	
	m = yield(get_match_with_no_build(),"completed")
	if m.size()==0:
		return
	
	var port = m["port"]
	var max_players = m["max_players"]
	match_name = m["match_name"]
	m["is_build_running"] = true
	$MatchesSaver.set_var(match_name,m)
	console.write("Assigned Build To " + match_name)
	
	NetworkHead.world_to_player.start_server_async(port,max_players)
	pass

func update_data():
	data = $MatchesSaver.get_data_self()
	pass

func get_match_with_no_build():
	var counter = 0
	var found_match = {}
	
	while counter < max_tries and found_match.size()==0:
		console.write("Trying To Find Match With No Build")
		yield(get_tree().create_timer(time_between_tries),"timeout")
		update_data()
		
		for k in data:
			var md = data[k]
			var is_build_running = md["is_build_running"]
			if not is_build_running:
				found_match = md
				break
	
	if found_match.size()==0:
		get_tree().call_deferred("quit")
		return found_match
	
	return found_match

func _on_closing():
	if m.size() == 0:
		return
	
	update_data()
	m["is_over"] = true
	$MatchesSaver.set_var(match_name,m)
	pass

func on_match_is_ready():
	var pending_matches = $WorldsBuilderSaver.get_var("pending_matches")
	
	if pending_matches.has(match_name):
		pending_matches.erase(match_name)
	
	$WorldsBuilderSaver.set_var("pending_matches",pending_matches)
	pass

func add_player(player_id):
	m["curr_players"].append(player_id)
	m["joined_players"].append(player_id)
	
	$MatchesSaver.set_var(match_name,m)
	pass

func remove_player(player_id):
	var curr_players : Array = m["curr_players"]
	curr_players.erase(player_id)
	
	$MatchesSaver.set_var(match_name,m)
	pass
