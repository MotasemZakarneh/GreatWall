tool
extends Node
class_name ARichLabelAutoDir

export var do_work = true

func _ready():
	if not is_in_group("TextModifier"):
		add_to_group("TextModifier")
	pass

func modify_text(curr_text:String):
	if curr_text.empty():
		return curr_text
	
	var new_text = curr_text
	
	if do_work and curr_text.find("[center]") == -1 and new_text.find("[/center]") == -1:
		var curr_lang = PersistantScene.settings.get_curr_lang()
		var start = ""
		var end = ""
		var is_ara = curr_lang == PersistantScene.settings.get_lang_of_id(PersistantScene.settings.Languages.ar)
		var has_ara = Localizer.has_ar_letter(curr_text)
		var has_en = Localizer.has_en_letter(curr_text)
		
		if is_ara:
			start = "[right]"
			end = "[/right]"
		
		if not has_ara and has_en:
			start = ""
			end = ""
		
		new_text = start + curr_text + end
	
	return new_text
