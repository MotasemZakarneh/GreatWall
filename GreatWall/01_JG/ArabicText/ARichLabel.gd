class_name ARichLabel
tool
extends RichTextLabel

#const arabic = preload("res://addons/arabic-text/arabic.gd")
#const wordwrap = preload("res://addons/arabic-text/wordwrap/wordwrap.gd")

const arabic = ArArabic
const wordwrap = ArWordWrap
const def_font_path = "res://01_JG/ArabicText/MarkaziFont.tres"

# Use this for input rather than `text`
@export var continious = false
@export var auto_wrap = true
@export(String, MULTILINE) var text_prop = '' setget _set_text_prop


func _ready():
	display()
	var _er = connect("draw", self, "_on_ALabel_draw")
	_er = connect("resized",self,"_on_ALabel_draw")

func _process(_delta):
	if continious:
		display()
	pass

func _set_text_prop(s):
	text_prop = s
	_on_ALabel_draw()

func _on_ALabel_draw():
	display()

func display():
	if text_prop == null or text_prop.empty():
		text = ""
		return
	_protect_font()
	
	var temptext = text_prop
	var processed_text = arabic.process_text(temptext)
	var modifiers = Extentions.get_children_in_group("TextModifier",self)
	if auto_wrap:
		processed_text = wrap_text(processed_text)
	for m in modifiers:
		processed_text = m.modify_text(processed_text)
	if bbcode_enabled:
		text = ""
		bbcode_text = processed_text
	else:
		bbcode_text = ""
		text = processed_text

func wrap_text(input):
	return wordwrap.wrap_text(input, get_font("font"), get_rect().size)

func _protect_font():
	if get("custom_fonts/font") == null:
		var f = load(def_font_path)
		if f != null:
			add_font_override("font",f)
		else:
			print("Can not find Default font at " + def_font_path)
	pass
