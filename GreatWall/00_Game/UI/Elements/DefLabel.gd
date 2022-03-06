tool
extends ALabel

@export var key = ""
@export var file_name = ""
@export var do_work = true

var localized_text : LocalizedText = null

func _i_ready():
	if Engine.editor_hint:
		return
	
	if localized_text == null:
		localized_text = get_node("LocalizedText")
	localized_text.update_data(do_work,file_name,key)
	pass

func _process(_delta):
	if not Engine.editor_hint:
		return
	
	if localized_text == null:
		localized_text = get_node("LocalizedText")
	localized_text.update_data(do_work,file_name,key)
	pass
