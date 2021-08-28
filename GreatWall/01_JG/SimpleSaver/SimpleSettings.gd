extends SimpleSaver
class_name SimpleSettings

export var load_on_ready = true

enum Languages { en, ar }
export (Languages) var curr_lang = Languages.en
export var sfx_vol = 0.85
export var music_vol = 0.65

var last_played_level = ""
var is_first_run = true

func _i_ready():
	if load_on_ready:
		sfx_vol = get_sfx_vol()
		music_vol = get_music_vol()
		curr_lang = get_saved_lang()
		is_first_run = get_is_first_run()
		last_played_level = get_last_played_level()
		
		if is_first_run:
			yield(get_tree().create_timer(0.1),"timeout")
			is_first_run = false
			update_data()
	pass

func get_sfx_vol():
	return safe_get_var("SFX Vol",sfx_vol)

func get_music_vol():
	return safe_get_var("Music Vol",music_vol)

func get_saved_lang():
	return safe_get_var("Lang",curr_lang)

func get_is_first_run():
	return safe_get_var("IsFirstRun",is_first_run)

func get_last_played_level():
	return safe_get_var("LastPlayedLevel",last_played_level)

func set_lang(new_lang:int):
	curr_lang = new_lang
	update_data()
	pass

func set_sfx(new_sfx):
	sfx_vol = new_sfx
	update_data()
	pass

func set_music(new_music):
	music_vol = new_music
	update_data()
	pass

func set_last_played_level(new_last_played_level):
	last_played_level = new_last_played_level
	update_data()
	pass

func get_lang_of_id(lang:int)->String:
	var i = 0
	for l in Languages:
		if i == int(lang):
			return l
		i = i + 1
	return Languages[0]

func get_curr_lang()->String:
	return get_lang_of_id(curr_lang)

func update_data():
	set_var("SFX Vol",sfx_vol)
	set_var("Music Vol",music_vol)
	set_var("Lang",curr_lang)
	set_var("IsFirstRun",is_first_run)
	set_var("LastPlaydLevel",last_played_level)
	pass
