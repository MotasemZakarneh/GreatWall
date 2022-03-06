extends Resource
class_name LocalizedTextsTableObj

@export_file("*.json") var def_texts_file_path = ""
@export var localizable_texts_dir = "res://Resources/LocalizableTexts/"

var file_to_texts_table = {}
var was_setup = false

#Public Functions to get the correct text
func get_files_count ():
	return file_to_texts_table.size()

func get_localized_text_fn(file_name:String,key:String,lang:String)->Array:
	var file_path = def_texts_file_path
	if file_name != "":
		file_path = _get_file_path_from_name(file_name)
	
	return _get_localized_text(file_path,key,lang)

func add_file_fn(file_name):
	if file_name.empty():
		return
	
	var file_path = _get_file_path_from_name(file_name)
	_add_file(file_path)
	pass

func remove_file_fn(file_name):
	if file_name.empty():
		return
	
	var file_path = _get_file_path_from_name(file_name)
	_remove_file(file_path)
	pass

#private functions, that deal with the appropriate path
func _get_localized_text(file_path:String,key:String,lang:String)->Array:
	if file_path == "":
		return [key,false]
	
	var norm = _get_normalized_file_path(file_path)
	if not file_to_texts_table.has(norm):
		_add_file(file_path)
	
	var tables_in_file = file_to_texts_table[norm]
	if tables_in_file == null:
		tables_in_file = []
	var localized_text = Extentions.get_localized_text(tables_in_file,key,lang)
	
	return localized_text

func _add_file(file_path):
	var norm = _get_normalized_file_path(def_texts_file_path)
	if not def_texts_file_path.empty() and not file_to_texts_table.has(norm):
		file_to_texts_table[norm] = Extentions.read_file(def_texts_file_path)
	
	norm = _get_normalized_file_path(file_path)
	if file_to_texts_table.has(norm):
		return
	
	file_to_texts_table[norm] = Extentions.read_file(file_path)
	pass

func _remove_file(file_path):
	var norm = _get_normalized_file_path(file_path)
	if not file_to_texts_table.has(norm):
		return
	
	file_to_texts_table.erase(norm)
	pass

func _get_normalized_file_path(fn : String):
	var norm : String = fn.replace(" ","")
	norm = norm.replace("/","")
	norm = norm.replace(":","")
	return norm

func _get_file_path_from_name(file_name):
	var file_path = localizable_texts_dir.plus_file(file_name) + ".json"
	return file_path
