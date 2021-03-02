extends Node2D
class_name MatchMakerData

export var worlds_start_port = 1950

onready var statics_saver = $Savers/StaticsSaver
onready var dynamics_saver = $Savers/DynamicsSaver
onready var matches_saver = $Savers/MatchesSaver

var server_data_dir = ""
var clean_world_ports = []
var used_world_ports = []

var console:Console
var data : Dictionary = {}

func _ready():
	console = ConsoleLoader.get_main(self)
	_setup_savers()
	
	yield(get_tree(),"idle_frame")
	
	$ServerBuildHelper.set_up(statics_saver,server_data_dir)
	pass

func _setup_savers():
	server_data_dir = GConstants.get_server_data_dir()
	
	dynamics_saver.assign_file_parts(server_data_dir,GConstants.dynamics_file_name)
	statics_saver.assign_file_parts(server_data_dir,GConstants.statics_file_name)
	matches_saver.assign_file_parts(server_data_dir,GConstants.matches_file_name)
	pass

func get_first_joinable_match()->Dictionary:
	var first_match = find_first_joinable_match()
	
	if first_match.size() == 0:
		first_match = yield(create_new_match(),"completed")
	
	return first_match

func find_first_joinable_match():
	var first_match = {}
	for k in data:
		var d = data[k]
		var is_build_running = d["is_build_running"]
		var curr_players = d["curr_players"]
		var max_players = d["max_players"]
		var not_full = curr_players < max_players
		
		if is_build_running and not_full:
			first_match = d
			break
	return first_match

func create_new_match():
	var m = create_new_match_data()
	var match_name = m["match_name"]
	data[match_name] = m
	matches_saver.set_var(match_name,m)
	yield($ServerBuildHelper.start_new_server_build(match_name),"completed")
	return m


func create_new_match_data()->Dictionary:
	var n = "Match_" + str(data.size())
	var id = data.size()
	var port = $PortsHelper.get_first_clean_port(data)
	
	var new_match = {
		"id":id,
		"match_name":n,
		"max_players":2,
		"is_open":true,
		"has_started":false,
		"expected_players":[],
		"port":port,
		"is_build_running":false,
		"curr_players":[]
	}
	
	return new_match
