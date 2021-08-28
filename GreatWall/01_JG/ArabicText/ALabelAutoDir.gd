extends Node
class_name ALabelAutoDir
tool

export var do_work = true

var p : ALabel = null

func _ready():
	p = get_parent()
	p.connect("on_new_text_displayed",self,"_on_new_text_displayed")
	pass

func _on_new_text_displayed():
	var curr_lang = PersistantScene.settings.get_curr_lang()
	if do_work and not p.align == p.ALIGN_CENTER:
			if curr_lang == PersistantScene.settings.get_lang_of_id(PersistantScene.settings.Languages.ar):
				p.align = p.ALIGN_RIGHT
			else:
				p.align = p.ALIGN_LEFT
	
	pass
