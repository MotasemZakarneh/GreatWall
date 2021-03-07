extends Node2D
class_name MatchMakerData

onready var statics_saver = $Savers/StaticsSaver

var console:Console
var data : Dictionary = {}

var pending_matches : MatchesGroup
var matches_sent_to_worlds : MatchesGroup

func _ready():
	matches_sent_to_worlds = MatchesGroup.new()
	pending_matches = MatchesGroup.new()
	
	console = ConsoleLoader.get_main(self)
	statics_saver.assign_file(GConstants.statics_file_name)
	
	yield(get_tree(),"idle_frame")
	
	$ServerBuildHelper.set_up(statics_saver)
	pass

func get_first_joinable_match_async() -> Dictionary:
	var first_match = _find_first_joinable_match()
	
	if first_match.size() == 0:
		first_match = yield(create_new_match_async(),"completed")
	else:
		yield(get_tree(),"idle_frame")
	
	return first_match

func _find_first_joinable_match():
	var first_match = {}
	
	for k in data:
		var d = data[k]
		
		var curr_players = d["curr_players"]
		var max_players = d["max_players"]
		
		var is_over = d["is_over"]
		var is_build_running = d["is_build_running"]
		var not_full = curr_players.size() < max_players
		
		if is_build_running and not_full and not is_over:
			first_match = d
			break
	return first_match

func create_new_match_async():
	var m = _create_new_match_data()
	var match_name = m["match_name"]
	
	pending_matches.add_match(m)
	
	yield($ServerBuildHelper.start_new_server_build(match_name),"completed")
	return m

func _create_new_match_data()->Dictionary:
	
	var id = data.size()
	var n = "Match_" + str(id)
	var port = $PortsHelper.get_first_clean_port(data)
	
	var new_match = {
		"id":id,
		"match_name":n,
		"max_players":2,
		"has_started":false,
		"is_build_running":false,
		"is_over":false,
		"is_accepting_players":false,
		"joined_players":[],
		"curr_players":[],
		"owner":0,
		"port":port
	}
	
	return new_match

func is_world_being_prepared(match_name):
	var is_pending = pending_matches.contains(match_name)
	var is_sent = matches_sent_to_worlds.contains(match_name)
	var not_started_yet = not is_pending and not is_sent and not data.keys().has(match_name)
	return is_pending or is_sent or not_started_yet

func process_pending_match():
	var m = pending_matches.pop_match()
	if m.size()>0:
		matches_sent_to_worlds.add_match(m)
	return m

func on_match_assigned(match_name,match_data):
	matches_sent_to_worlds.remove_match(match_name)
	data[match_name] = match_data
	pass

func is_match_in_group(match_name:String,group:MatchesGroup):
	return group.contains(match_name)
