tool
extends SimpleComponent
class_name LocalizedText

@export var do_work = true
@export(String) var file_name
@export var key = ""
var alabel = null

func update_data(_do_work,_file_name,_key):
	self.do_work = _do_work
	self.file_name = _file_name
	self.key = _key
	if not Engine.editor_hint:
		_update_text(PersistantScene.settings.get_curr_lang())
	pass

func _ready():
	if Engine.editor_hint:
		return
	
	alabel = Extentions.get_child_of_type(get_parent(),[ALabel,ARichLabel])
	_update_text(PersistantScene.settings.get_curr_lang())
	PersistantScene.localizer.connect("on_lang_updated",self,"_on_lang_updated")
	pass

func _on_lang_updated(new_lang):
	_update_text(new_lang)
	pass

func _update_text(_new_lang):
	if Engine.editor_hint:
		return
	
	if not do_work:
		return
	
	var new_text = PersistantScene.localizer.get_localized_text_of_lang(file_name,key,_new_lang)[0]
	alabel.text_prop = new_text
	pass
