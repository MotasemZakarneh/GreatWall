extends Node
class_name Localizer
signal on_lang_updated(new_lang)

const texts_obj = preload("res://01_JG/Localization/LocalizedTextsTableObj.tres")
const en_letters = [
	"A","B","C","D","E","F","G","H","I","J","K","L","M",
	"N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
	"a","b","c","d","e","f","g","h","i","j","k","l","m",
	"n","o","p","q","r","s","t","u","v","w","x","y","z"
]
const ar_letters = [
	"ا","ب","ت","ث","ج","ح","خ","د","ذ","ر","ز","س","ش",
	"ص","ض","ط","ظ","ع","غ","ف","ق","ك","ل","م","ن","ه",
	"و","ي"
]

func _ready():
	yield (get_tree(),"idle_frame")
	apply_lang(PersistantScene.settings.curr_lang)
	pass

func apply_lang(new_lang:int):
	var temp_lang = PersistantScene.settings.get_lang_of_id(new_lang)
	emit_signal("on_lang_updated",temp_lang)
	pass

func get_localized_text(file_name,key)->Array:
	var curr_lang = PersistantScene.settings.get_curr_lang()
	return get_localized_text_of_lang(file_name,key,str(curr_lang))

func get_localized_text_of_lang(file_name,key,lang)->Array:
	var localized_data = texts_obj.get_localized_text_fn(file_name,key,lang)
	return localized_data

func get_localized_vo_key(vo_key:String)->String:
	var curr_lang = PersistantScene.settings.get_curr_lang()
	var localized_vo = curr_lang + "_" + vo_key
	return localized_vo

func is_arabic():
	var curr_lang = PersistantScene.settings.get_curr_lang()
	var is_ara = curr_lang == PersistantScene.settings.get_lang_of_id(PersistantScene.settings.Languages.ar)
	return is_ara

func is_english():
	var curr_lang = PersistantScene.settings.get_curr_lang()
	var is_en = curr_lang == PersistantScene.settings.get_lang_of_id(PersistantScene.settings.Languages.en)
	return is_en

static func has_ar_letter(s:String):
	for l in s:
		if ar_letters.has(l):
			return true
	return false

static func has_en_letter(s:String):
	for l in s:
		if en_letters.has(l):
			return true
	return false
