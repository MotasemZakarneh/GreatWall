extends Resource
class_name LevelsData

@export var levels : Array[PackedScene]= []

func get_level(level_name:String):
	for l in levels:
		if l == null:
			continue
		var p : String = l.resource_path
		var f = Extentions.get_file_name_no_ext(p)
		if f == level_name:
			return l
	return null

func has_level(level_name:String):
	for l in levels:
		if l == null:
			continue
		var p = l.resource_path
		var f = Extentions.get_file_name_no_ext(p)
		if f == level_name:
			return true
	return false
