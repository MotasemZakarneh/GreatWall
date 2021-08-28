tool
class_name ALabel
extends Label

#const arabic = preload("res://addons/arabic-text/arabic.gd")
#const wordwrap = preload("res://addons/arabic-text/wordwrap/wordwrap.gd")
signal on_new_text_displayed
const arabic = ArArabic
const wordwrap = ArWordWrap
const def_font_path = "res://01_JG/ArabicText/MarkaziFont.tres"

# Use this for input rather than `text`
export(String, MULTILINE) var text_prop = '' setget _set_text_prop
export var continious = false

func _ready():
	display()
	var _er = connect("draw", self, "_on_ALabel_draw")
	_er = connect("resized",self,"_on_ALabel_draw")
	_i_ready()

func _i_ready():
	pass

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
	
	var temptext = wrap_text(text_prop) if autowrap else text_prop
	var new_text = arabic.process_text(temptext)
	text = new_text
	emit_signal("on_new_text_displayed")

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
