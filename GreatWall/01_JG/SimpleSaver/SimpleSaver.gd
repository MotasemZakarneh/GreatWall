extends Node
class_name SimpleSaver

#Use s_set_var/s_get_var 
#to save and get data from the default file, to use a different file
#add this node to the node tree and use set_var/get_var

const def_file_name = "SimpleData.dat"
const def_dir = "user://"

@export var file_name = def_file_name
@export var dir_name = def_dir

signal on_data_group_loaded(data_group)

func _ready():
	if not is_in_group("Simple Saver"):
		add_to_group("Simple Saver")
	
	_i_ready()
	pass

func _i_ready():
	
	pass

#override this to create data group per instance 
func _i_get_inst_data_group()->Dictionary:
	return {}

func _i_on_data_group_loaded(_data_group):
	
	pass

#public functions
func load_data_group()->Dictionary:
	var data_group = get_var("data_group")
	_i_on_data_group_loaded(data_group)
	emit_signal("on_data_group_loaded",data_group)
	return data_group

func save_curr_data_group():
	var data_group = _i_get_inst_data_group()
	set_var("data_group",data_group)
	pass

static func s_set_var(key,val):
	var data = get_data(null)
	data[key] = val
	
	var json_string = Extentions.to_pretty_json(data)
	write_to_file(null,json_string)
	pass

static func s_get_var(key):
	var data = get_data(null)
	if data.size() == 0:
		#print("There Is No Data Stored, Dictionary Is Empty")
		#print ("SimpleSaver Does Not Contain Key :: " + key)
		return null
	
	if not data.keys().has(key):
		#print ("SimpleSaver Does Not Contain Key :: " + key)
		return null
	
	var val = data[key]
	return val

func set_var(key,val):
	var data = get_data(self)
	data[key] = val
	
	var json_string = Extentions.to_pretty_json(data)
	write_to_file(self,json_string)
	return json_string

func get_var(key):
	var data = get_data(self)
	
	if data.size() == 0:
		#print("There Is No Data Stored, Dictionary Is Empty")
		#print ("SimpleSaver Does Not Contain Key :: " + key)
		return null
	
	if not data.keys().has(key):
		#print ("SimpleSaver Does Not Contain Key :: " + key)
		return null
	
	var val = data[key]
	return val

func has_var(key):
	var data = get_data(self)
	if data.size() == 0:
		return false
	if not data.keys().has(key):
		return false
	return true

func safe_get_var(key,def_val):
	var v = get_var(key)
	if v == null:
		set_var(key,def_val)
		v = def_val
	return v

func reset_file_to_defaults():
	dir_name = def_dir
	file_name = def_file_name
	pass

func assign_file(full_file_path : String):
	dir_name = full_file_path.get_base_dir()
	file_name = full_file_path.get_file()
	pass

func assign_file_parts(_dir_name:String,_file_name:String):
	self.dir_name = _dir_name
	self.file_name = _file_name
	pass

func get_data_self():
	return get_data(self)

func set_data_self(data):
	var d = Extentions.to_pretty_json(data)
	write_to_file(self,d)
	pass

static func write_to_file(inst,json_string):
	var file_path = get_file_path(inst)
	var file = File.new()
	file.open(file_path, File.WRITE)
	file.store_string(json_string)
	file.close()
	pass

static func get_data(inst):
	var file_path = get_file_path(inst)
	var data = {} 
	var file = File.new()
	if not file.file_exists(file_path):
		return data
	
	var er = file.open(file_path,File.READ)
	if er != OK:
		#print(er)
		return data
	
	var json_string : String = file.get_as_text()
	file.close()
	
	if(json_string.length() == 0 or json_string.length() <= 2):
		#print("There is no stored data In File")
		return data
	var json = JSON.new()
	json.parse(json_string)
	data = json.get_data()
	return data

static func get_file_path(inst):
	var f = def_file_name
	var d = def_dir
	if inst != null:
		f = inst.file_name
		d = inst.dir_name
	if d == null or d == "":
		d = def_dir
	if f == null or f == "":
		f = def_file_name
	var total_file_path = d.plus_file(f)
	return total_file_path
