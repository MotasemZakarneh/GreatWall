extends JG_Audio
class_name SFXManager

var groups = []
var curr_sfx_vol = 0
var curr_munsic_vol = 0

func _ready():
	groups = Extentions.get_children_of_type(self,[SFXGroup])
	for g in groups:
		g.setup()
	await get_tree().idle_frame
	apply_new_sfx(PersistantScene.settings.sfx_vol)
	pass

func has_group(group_name:String):
	var g = _get_group_by_name(group_name)
	if g == null:
		return false
	return true

func play_group(group_name:String,caller:Node2D = null,element:String = ""):
	var g : SFXGroup = _get_group_by_name(group_name)
	
	if g == null:
		if group_name != "":
			print("Can not find group " + group_name)
		return
	
	g.play(element,caller)
	pass

func add_group(new_group:SFXDynamicGroup):
	var group = SFXGroup.new()
	group.play_rnd = new_group.play_rnd
	add_child(group)
	
	for c in new_group.get_children():
		var new_group_child_scene = PackedScene.new()
		new_group_child_scene.pack(c)
		var cloned_element = new_group_child_scene.instance()
		cloned_element.name = c.name
		group.add_child(cloned_element)
	
	group.name = new_group.name
	group.setup()
	groups.append(group)
	pass

func remove_group(new_group:SFXDynamicGroup):
	var group = _get_group_by_dynamic_group(new_group)
	if group!=null:
		groups.erase(group)
		group.queue_free()
	pass

func remove_group_by_name(group_name : String):
	var group = _get_group_by_name(group_name)
	if group != null:
		groups.erase(group)
		group.queue_free()
	pass

func _get_group_by_name(group_name):
	if group_name.empty():
		return null
	
	for g in groups:
		if g.name == group_name:
			return g
	return null

func _get_group_by_dynamic_group(new_group:SFXDynamicGroup):
	for g in groups:
		if g.name == new_group.name:
				return g
	return null

func apply_new_sfx(new_sfx):
	var sfx_index = AudioServer.get_bus_index("SFX")
	if sfx_index>0:
		var new_sfx_vol = Extentions.percent2bus(new_sfx)
		AudioServer.set_bus_volume_db(sfx_index,new_sfx_vol)
	else:
		print("There is no sfx bus")
	pass
