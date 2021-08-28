extends MenusController

var is_first_run = false
var lang_start_menu = null
var play_menu = null

func _i_ready():
	lang_start_menu = get_node("LanguageStartMenu")
	play_menu = get_node("PlayMenu")
	
	is_first_run = PersistantScene.settings.is_first_run
	if is_first_run:
		start_menu = lang_start_menu.name
	else:
		start_menu = play_menu.name
	
	pass
