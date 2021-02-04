extends Node2D
class_name MatchMakerData

export var worlds_start_port = 14800

export var statics_file_name = "StaticData.json"
export var dynamics_file_name = "DynamicData.json"
var server_data_dir = ""

var world_app_path = ""
var clean_world_ports = []
var used_world_ports = []
const dir_name = "GWServerData"

func _ready():
	
	_setup_data_dir()
	
	yield(get_tree(),"idle_frame")
	
	activate_statics()
	
	world_app_path = NetworkHead.simp_saver.get_var("game_wolrds_paths")
	
	reset_file_to_defaults()
	pass

func _setup_data_dir():
	var gl : = ProjectSettings.globalize_path("user://")
	gl = gl.get_base_dir().get_base_dir().plus_file(dir_name)
	var dir = Directory.new()
	if not dir.dir_exists(gl):
		print("GWServerData directory not found, copy it to UserData, on the system")
	server_data_dir = gl 
	pass

func reset_file_to_defaults():
	NetworkHead.simp_saver.reset_file_to_defaults()
	pass

func activate_dyanmics():
	NetworkHead.simp_saver.assign_file_parts(server_data_dir,dynamics_file_name)
	pass

func activate_statics():
	NetworkHead.simp_saver.assign_file_parts(server_data_dir,statics_file_name)
	pass

func get_ready_port():
	
	pass

