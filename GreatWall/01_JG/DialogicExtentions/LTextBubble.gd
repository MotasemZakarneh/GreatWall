#to use localized Text inside of Dialogic
#Uncomment this script
#Go To Dialog.tscn
#Create Inherited Scene
#Replace the TextBubble script with the LTextBubble script
#Add ALabel and ARichLabel scripts to the labels
#Use the new scene

tool
extends "res://addons/dialogic/Nodes/TextBubble.gd"

var file_name = ""
var first_call = true
export var use_standard = false

func _i_ready():
	if Engine.editor_hint:
		return
	
	PersistantScene.sfx_manager.play_group("UISlideIn")
	connect("tree_exited",self,"_on_destroy")
	if use_standard:
		text_label = $RichTextLabel/Label
	pass

func _on_destroy():
	PersistantScene.sfx_manager.play_group("UINextIndicatorClick")
	PersistantScene.sfx_manager.play_group("UISlideIn")
	pass

func update_name(name: String, color: Color = Color.white, autocolor: bool=false) -> void:
	name = _try_get_localized(name)
	
	if not name.empty():
		name_label.visible = true
		# Hack to reset the size
		#my change start
		#name_label.rect_min_size = Vector2(0, 0)
		#name_label.rect_size = Vector2(-1, 40)
		#my change end
		# Setting the color and text
		#name_label.text = name
		var n = name_label.get_node("NameLabel")
		n.text_prop = name
		
		if autocolor:
			n.set('custom_colors/font_color', color)
	else:
		name_label.visible = false

func update_text(text):
	_update_text_file_name()
	
	if first_call:
		first_call = false
	else:
		PersistantScene.sfx_manager.play_group("UINextIndicatorClick")
	
	var n : String = text
	
	var vo_start_key = "*_"
	var vo_end_key = "_*"
	var vo_start = n.find(vo_start_key)
	var vo_end = n.find(vo_end_key)
	
	if vo_start != -1 and vo_end != -1:
		var vo = n.substr(vo_start,vo_end)
		n = n.replace(vo,"")
		vo = vo.replace(vo_start_key,"")
		vo = vo.replace(vo_end_key,"")
		var vo_key = vo
		
		vo_key = PersistantScene.localizer.get_localized_vo_key(vo)
		
		if PersistantScene.sfx_manager.has_group(vo_key):
			PersistantScene.sfx_manager.play_group(vo_key)
		elif PersistantScene.sfx_manager.has_group(vo):
			vo_key = vo
			PersistantScene.sfx_manager.play_group(vo_key)
		else:
			vo_key = vo
			print("Could Not Locate Sound Group Of " + vo_key)
	
	text = n
	text = _try_get_localized(text)
	
	# Updating the text and starting the animation from 0
	#text_label.bbcode_text = text
	text_label.text_prop = text
	text_label.percent_visible = 0

	# The call to this function needs to be deferred.
	# More info: https://github.com/godotengine/godot/issues/36381
	if not PersistantScene.localizer.is_arabic():
		call_deferred("_start_text_tween")
	else:
		text_label.percent_visible = 1
		_on_Tween_tween_completed(null,null)
	return true

func _try_get_localized(text_to_process):
	var key = text_to_process
	var fn = ""
	
	if text_to_process.find("::") != -1:
		var split = text_to_process.split("::")
		fn = split[0]
		key = split[1]
	else:
		fn = file_name
		key = text_to_process
	
	var localized = text_to_process
	var localization_data = PersistantScene.localizer.get_localized_text(fn,key)
	if localization_data[1] == true:
		localized = localization_data[0]
	
	return localized

func _update_text_file_name():
	var timeline = Dialogic.get_current_timeline()
	if timeline == null or timeline.empty():
		return
	
	var timeline_json = DialogicResources.get_timeline_json(timeline)
	file_name = timeline_json["metadata"]["name"]
	pass
