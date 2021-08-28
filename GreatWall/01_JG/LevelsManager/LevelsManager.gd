extends Node
class_name LevelsManager

signal on_level_changed(last_level_name,new_level_name)

export(Resource) var levels_data = null
export(Array,String) var levels = null

var fader = null

func _ready():
	fader = get_node("Fader")
	fader.inst_fade_out()
	pass

func go_to_scene(level_name : String):
	if not levels_data.has_level(level_name) and get_level(level_name).empty():
		return
	var last_level_name = get_tree().current_scene.name
	$Fader.def_fade_in()
	yield($Fader,"on_faded_in")
	var level_path = ""
	if levels_data.has_level(level_name):
		var l = levels_data.get_level(level_name)
		level_path = l.resource_path
		var _er = get_tree().change_scene_to(l)
	elif not get_level(level_name).empty():
		var l = get_level(level_name)
		level_path = l
		var _er = get_tree().change_scene(l)
	
	while true:
		if get_tree().current_scene == null:
			yield(get_tree(),"idle_frame")
			continue
		
		if get_tree().current_scene.filename == level_path:
			yield(get_tree(),"idle_frame")
			break
		
		if get_tree().current_scene.name == level_name:
			yield(get_tree(),"idle_frame")
			break
		
		yield(get_tree(),"idle_frame")
	
	yield(get_tree(),"idle_frame")
	emit_signal("on_level_changed",last_level_name,level_name)
	$Fader.inst_fade_out()
	pass

func get_level(level_name : String):
	if levels == null or levels.size()==0:
		return ""
	
	for l in levels:
		if l == null:
			continue
		if l.empty():
			continue
		var f = Extentions.get_file_name_no_ext(l)
		if f == level_name:
			return l
	return ""
