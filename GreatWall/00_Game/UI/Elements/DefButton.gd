extends Button
tool

@export var do_work = true
@export var text_key = ""
@export var text_file_name = ""

@export var placeholder_text = ""
@export var disable_on_html = false

var alabel = null
var localized_text = null

func _ready():
	if Engine.editor_hint:
		return
	alabel = get_node("ALabel")
	localized_text = get_node("LocalizedText")
	alabel.text_prop = placeholder_text
	localized_text.update_data(do_work,text_file_name,text_key)
	
	if disable_on_html and Extentions.is_html():
		_de_activate_button()
	pass

func _process(_delta):
	if not Engine.editor_hint:
		return
	if alabel == null:
		alabel = get_node("ALabel")
	if localized_text == null:
		localized_text = get_node("LocalizedText")
	
	if alabel != null:
		alabel.text_prop = placeholder_text
	if localized_text != null:
		localized_text.update_data(do_work,text_file_name,text_key)
	pass

func _de_activate_button():
	button_mask = 0
	visible = false
	set_focus_mode(Control.FOCUS_NONE)
	pass
