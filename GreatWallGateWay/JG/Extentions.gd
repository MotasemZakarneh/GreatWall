extends Node
class_name Extentions

enum decision_operator {AND,OR}

static func check_decision_operation(operation,on:Array) -> bool:
	if  operation==decision_operator.AND:
		for o in on:
			if not o:
				return false
		return true
	elif operation == decision_operator.OR:
		for o in on:
			if o:
				return true
		return false
	return true


static func get_children_in_group(group:String,node:Node)->Array:
	var children = node.get_children()
	var filtered_children = []
	
	for c in children:
		if c.is_in_group(group):
			filtered_children.append(c)
	
	return filtered_children

static func get_children_in_group_recursively(group,node:Node)->Array:
	var children_in_group = []
	
	var all_children = []
	get_children_recursively(node,all_children)
	
	for c in all_children:
		if c.is_in_group(group):
			children_in_group.append(c)
	
	return children_in_group

static func get_children_recursively(node:Node,recursive_children_holder:Array):
	if node.get_child_count()==0:
		return
	
	var node_children = node.get_children()
	
	for node_child in node_children:
		if not recursive_children_holder.has(node_child):
			recursive_children_holder.append(node_child)
			get_children_recursively(node_child,recursive_children_holder)
	
	pass

static func get_child_of_type(node:Node,types : Array):
	var children = []
	get_children_recursively(node,children)
	
	for type in types:
		for c in children:
			if c is type:
				return c
	
	return null

static func get_child_of_name(node:Node,names:Array):
	var children = []
	get_children_recursively(node,children)
	
	for n in names:
		for c in children:
			if c.get("name") != null and c.get("name") == n:
				return c
	
	return null

static func get_children_of_type(node:Node,types : Array):
	var children = []
	get_children_recursively(node,children)
	
	var filtered = []
	for type in types:
		for c in children:
			if c is type:
				if not filtered.has(c):
					filtered.append(c)
	
	return filtered

static func test_groups_on_node(node:Node,groups:Array):
	for g in groups:
		if node.is_in_group(g):
			return true
	return false

static func get_sibling_node(the_node:Node,sibling_name):
	var par = the_node.get_parent()
	if par == null:
		return null
	if not par.has_node(str(sibling_name)):
		return null
	
	return par.get_node(str(sibling_name))

static func clamp_magnitude(v1:Vector2,length:float):
	if(v1.length()<=length):
		return v1
	var dir = v1.normalized()
	var clampped = dir * length
	return clampped

static func is_zero(f:float):
	return abs(f)<=0.001

static func make_one (v:Vector2):
	var oned = Vector2()
	if v.x > 0:
		oned.x = 1
	elif v.x<0:
		oned.x = -1
	if v.y>0:
		oned.y = 1
	elif v.y<0:
		oned.y = -1
	return oned

static func get_localized_text(text_tables : Array,key : String,lang : String):
	for t in text_tables:
		var t_dict : Dictionary= t
		if t_dict.has("key") and t_dict["key"] == key:
			var l = "en"
			if t_dict.has(lang):
				l = lang
			return t_dict[l]
	
	return "Could Not Text " + key

static func get_localized_text_f(file_name:String,key:String,lang:String):
	var all_tables = read_file(file_name)
	return get_localized_text(all_tables,key,lang)

static func read_file(file_to_read) -> Array:
	var file = File.new()
	file.open(file_to_read, File.READ)
	var content = file.get_as_text()
	file.close()
	var json_obj = parse_json(content)
	return json_obj

static func to_pretty_json(obj):
	return JSON.print(obj,"\t")

static func get_anims_from_sheet(sheet:Texture,sheet_x_len:int,sheet_y_len:int,x_anim_len:int,dirs_to_get:int,anim_type:String):
	var directions = ["Down","Left","Right","Up","BotLeft","TopLeft","BotRight","TopRight"]
	
	var single_w = sheet.get_width()/float(sheet_x_len)
	var single_h = sheet.get_height()/float(sheet_y_len)
	
	var ready_anims = []
	
	for y in dirs_to_get:
		var y_pos = y * single_h
		var anim_name = anim_type+"_"+directions[y]
		var anim_frames = []
		
		for x in x_anim_len:
			var x_pos = x * single_w
			var atlas : AtlasTexture = AtlasTexture.new()
			atlas.region = Rect2(x_pos,y_pos,single_w,single_h)
			
			atlas.atlas = sheet
			anim_frames.append(atlas)
		
		var ready_anim  = { "full_anim_name":anim_name,
							"frames":anim_frames }
		ready_anims.append(ready_anim)
	
	return ready_anims

static func get_anims_from_sheet_n(sheet:Texture,sheet_x_len:int,sheet_y_len:int,x_anim_len:int,dirs_to_get:int):
	var anim_name : String = sheet.resource_path
	anim_name = anim_name.get_file()
	if sheet.resource_local_to_scene or ".tres" in anim_name:
		print(anim_name + " Is Local to source, this could cause issues, replug the textures")
	anim_name = anim_name.replace("."+anim_name.get_extension(),"")
	return get_anims_from_sheet(sheet,sheet_x_len,sheet_y_len,x_anim_len,dirs_to_get,anim_name)

static func get_sprite_frames(sheets:Array,sheets_lens,directions_to_get,speeds):
	var s = SpriteFrames.new()
	
	for i in sheets.size():
		var sheet = sheets[i]
		var sheet_x_len = sheets_lens[i].x
		var sheet_y_len = sheets_lens[i].y
		var anim_x_len = sheet_x_len
		var dirs_to_get = directions_to_get
		var speed = speeds[i]
		
		var anims = get_anims_from_sheet_n(sheet,sheet_x_len,sheet_y_len,anim_x_len,dirs_to_get)
		
		for a in anims:
			var full_anim_name = a["full_anim_name"]
			var frames = a["frames"]
			s.add_animation(full_anim_name)
			
			for f in frames:
				s.add_frame(full_anim_name,f)
			
			s.set_animation_speed(full_anim_name,speed)
		pass
	
	return s

#Should Be Of Type : CharaAnimData
static func get_sprite_frames_d(data):
	var anims = data
	return get_sprite_frames(anims.texes,anims.texes_lengths,anims.directions_to_get,anims.speeds)

static func get_sprite_frames_all(anims_sets:Array):
	var sprite_frames = SpriteFrames.new()
	
	for set in anims_sets:
		var s : SpriteFrames = get_sprite_frames_d(set)
		for anim in s.get_animation_names():
			if sprite_frames.has_animation(anim):
				continue
			sprite_frames.add_animation(anim)
			var frames_count = s.get_frame_count(anim)
			for i in frames_count:
				var f = s.get_frame(anim,i)
				sprite_frames.add_frame(anim,f)
			sprite_frames.set_animation_speed(anim,s.get_animation_speed(anim))
	
	return sprite_frames


static func get_visual_body(node:Node):
	var possible_bodies = ["Sprite","AnimatedSprite","VisualBody","MeshInstance2D"]
	var sprite = get_child_of_name(node,possible_bodies)
	if sprite == null:
		sprite = node
	return node

static func set_collision_state(node:Node,state:bool):
	var children = get_children_of_type(node,[CollisionShape2D,CollisionPolygon2D])
	if node is CollisionShape2D or node is CollisionPolygon2D:
		node.set_deferred("disabled",!state)
	for c in children:
		c.set_deferred("disabled",!state)
	pass

static func is_key_pressed(ev, key):
	if ev is InputEventKey and ev.scancode == key:
		return true
	return false

static func is_key_pressed_forced(ev,key):
	if ev is InputEventKey and Input.is_key_pressed(key):
		return true
	return false

static func is_key_pressed_up(ev,key):
	if ev is InputEventKey and ev.scancode == key and not ev.echo:
		return true
	return false

static func get_colored_text(new_text:String,col:Color):
	var start = "[color=#"+str(col.to_html())+"]"
	var end = "[/color]"
	var total = start+new_text+end
	return total

static func get_user_dir(dir_name):
	var gl : = ProjectSettings.globalize_path("user://")
	gl = gl.get_base_dir().get_base_dir().plus_file(dir_name)
	var dir = Directory.new()
	if not dir.dir_exists(gl):
		print(dir_name + " directory not found, creating it automatically at " + gl)
		var _er = dir.make_dir_recursive(gl)
		if _er != OK:
			print("Error, Creating, Dir Manually " +str(_er))
	return gl
