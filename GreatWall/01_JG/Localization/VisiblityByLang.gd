extends Node2D
class_name VisiblityByLang

@export var visible_on_ar = false
@export var visible_on_en = true
@export var apply_on_parent = true
var body = null

func _ready():
	if apply_on_parent:
		body = get_parent()
	else:
		body = self
	
	_on_lang_updated(PersistantScene.settings.get_curr_lang())
	PersistantScene.localizer.connect("on_lang_updated",self,"_on_lang_updated")
	pass

func _on_lang_updated(new_lang):
	var is_ar = new_lang == PersistantScene.settings.get_lang_of_id(PersistantScene.settings.Languages.ar)
	var is_en = new_lang == PersistantScene.settings.get_lang_of_id(PersistantScene.settings.Languages.en)
	if is_ar and visible_on_ar:
		body.visible = true
	elif is_en and visible_on_en:
		body.visible = true
	else:
		body.visible = false
	pass
