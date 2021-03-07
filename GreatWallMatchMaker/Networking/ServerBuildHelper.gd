extends Node
export var is_in_editor = false

var world_app_path = ""
var console : Console

func set_up(statics_saver):
	console = ConsoleLoader.get_main(self)
	world_app_path = statics_saver.get_var("game_wolrds_paths")
	console.write(world_app_path)
	pass

func start_new_server_build(match_name):
	_create_world()
	
	var was_build_started = false
	while not was_build_started:
		yield(get_tree().create_timer(1),"timeout")
		NetworkHead.match_maker_to_world.cs_assign_world_to_match()
		was_build_started = not get_parent().is_world_being_prepared(match_name)
		console.write("Waiting For Match Build To Start")
	pass

func _create_world():
	if is_in_editor:
		console.write("Creating World: But Is In Editor, go launch manually")
		return
	
	var build_path = world_app_path
	var f = File.new()
	
	var build_exists = f.file_exists(build_path)
	
	if not build_exists:
		console.write("Executbile Of Game world does not exist " + build_path)
		return
	
	console.write("Openig Executible Of Game World :: " + build_path)
	var output = []
	var _res = OS.execute(build_path,[],false,output)
	pass
