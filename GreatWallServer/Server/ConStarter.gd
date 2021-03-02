extends Node2D

var max_tries = 90
var time_between_tries = 1

var server_data_dir = ""
var matches_data = {}
var console:Console

func _ready():
	console = ConsoleLoader.get_main(self)
	server_data_dir = GConstants.get_server_data_dir()
	$WorldsBuilderSaver.assign_file_parts(server_data_dir,GConstants.worlds_builder_file)
	$MatchesSaver.assign_file_parts(server_data_dir,GConstants.matches_file_name)
	
	matches_data = $MatchesSaver.get_data_self()
	
	var m = yield(get_match_with_no_build(),"completed")
	if m.size()==0:
		return
	
	var port = m["port"]
	var max_players = m["max_players"]
	var match_name = m["match_name"]
	m["is_build_running"] = true
	$MatchesSaver.set_var(match_name,m)
	console.write("Assigned Build To " + match_name)
	var pending_matches : Array = $WorldsBuilderSaver.get_var("pending_matches")
	if pending_matches.has(match_name):
		pending_matches.erase(match_name)
	$WorldsBuilderSaver.set_var("pending_matches",pending_matches) 
	pass

func get_match_with_no_build():
	var counter = 0
	var found_match = {}
	
	while counter < max_tries and found_match.size()==0:
		console.write("Trying To Find Match With No Build")
		yield(get_tree().create_timer(time_between_tries),"timeout")
		for k in matches_data:
			var m = matches_data[k]
			var is_build_running = m["is_build_running"]
			if not is_build_running:
				found_match = m
				break
	
	if found_match.size()==0:
		get_tree().call_deferred("quit")
		return found_match
	
	return found_match
