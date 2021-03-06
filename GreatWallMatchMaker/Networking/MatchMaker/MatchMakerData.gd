extends Node2D
class_name MatchMakerData

export var auto_update_cd = 10

onready var statics_saver = $Savers/StaticsSaver
onready var matches_saver = $Savers/MatchesSaver

var curr_matches = []
var curr_matches_ids = []

var console:Console
var data : Dictionary = {}
var auto_update_counter = 0

func _ready():
	console = ConsoleLoader.get_main(self)
	_setup_savers()
	
	yield(get_tree(),"idle_frame")
	
	$ServerBuildHelper.set_up(statics_saver)
	create_new_match()
	pass

func _process(delta):
	auto_update_counter = auto_update_counter + delta/auto_update_cd
	if auto_update_counter>=1:
		update_data()
	pass

func _setup_savers():
	statics_saver.assign_file(GConstants.statics_file_name)
	matches_saver.assign_file(GConstants.matches_file_name)
	pass

func get_first_joinable_match()->Dictionary:
	var first_match = find_first_joinable_match()
	
	if first_match.size() == 0:
		first_match = yield(create_new_match(),"completed")
	else:
		yield(get_tree(),"idle_frame")
	
	return first_match

func find_first_joinable_match():
	var first_match = {}
	update_data()
	
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

func create_new_match():
	var m = create_new_match_data()
	var match_name = m["match_name"]
	var id = m["id"]
	
	curr_matches.append(match_name)
	curr_matches_ids.append(id)
	
	matches_saver.assign_file_parts(GConstants.matches_dir,match_name+".json")
	matches_saver.set_data_self(m)
	
	#data[match_name] = m
	#matches_saver.set_var(match_name,m)
	yield($ServerBuildHelper.start_new_server_build(match_name),"completed")
	return m

func create_new_match_data()->Dictionary:
	update_data()
	
	var id = curr_matches.size()
	var n = GConstants.match_file_prefix + str(id)
	var port = $PortsHelper.get_first_clean_port(curr_matches,curr_matches_ids)
	
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
		"port":port
	}
	
	return new_match

func update_data():
	var matches = Extentions.get_all_file_names(GConstants.matches_dir)
	curr_matches = matches
	
	data = matches_saver.get_data_self()
	auto_update_counter = 0
	
	var erasables = []
	
	for k in data:
		var m = data[k]
		var is_over = m["is_over"]
		var match_name = k
		if is_over:
			console.write("Should Process/Store Match Data of " + match_name)
			erasables.append(k)
	
	for e in erasables:
		var _e = data.erase(e)
	
	if erasables.size()>0:
		matches_saver.set_data_self(data)
	
	return data
