extends BaseMenu

@export var previous_menu = "PlayMenu"

var sfx_slider = null
var music_slider = null

var last_pressed_lang = 0
var last_sfx_val = 0
var last_music_val = 0

func _i_ready():
	var _er = $BG/HBox/VBox/ControlButtons/Back.connect("button_up",self,"_on_back_pressed")
	
	sfx_slider = get_node("BG/HBox/VBox/SFXVol")
	music_slider = get_node("BG/HBox/VBox/MusicVol")
	
	sfx_slider.value = PersistantScene.settings.get_sfx_vol()
	music_slider.value = PersistantScene.settings.get_music_vol()
	
	_er = sfx_slider.connect("value_changed",self,"_on_sfx_updated")
	_er = music_slider.connect("value_changed",self,"_on_music_updated")
	
	_er = $BG/HBox/VBox/ControlButtons/Save.connect("button_up",self,"_on_save_pressed")
	_er = $BG/HBox/VBox/LangSelector/Arabic.connect("button_up",self,"_on_arabic_pressed")
	_er = $BG/HBox/VBox/LangSelector/English.connect("button_up",self,"_on_english_pressed")
	pass

func _i_on_open():
	last_pressed_lang = PersistantScene.settings.curr_lang
	last_sfx_val = PersistantScene.settings.sfx_vol
	last_music_val = PersistantScene.settings.music_vol
	pass

func _on_back_pressed():
	PersistantScene.localizer.apply_lang(PersistantScene.settings.curr_lang)
	
	last_sfx_val = PersistantScene.settings.sfx_vol
	last_music_val = PersistantScene.settings.music_vol
	
	PersistantScene.music_controller.apply_new_music(last_music_val)
	PersistantScene.sfx_manager.apply_new_sfx(last_sfx_val)
	get_parent().open_menu(previous_menu)
	pass

func _on_sfx_updated(new_val):
	last_sfx_val = new_val
	PersistantScene.sfx_manager.apply_new_sfx(new_val)
	pass

func _on_music_updated(new_val):
	last_music_val = new_val
	PersistantScene.music_controller.apply_new_music(new_val)
	pass

func _on_save_pressed():
	PersistantScene.settings.set_lang(last_pressed_lang)
	PersistantScene.settings.set_music(last_music_val)
	PersistantScene.settings.set_sfx(last_sfx_val)
	
	get_parent().open_menu(previous_menu)
	pass

func _on_arabic_pressed():
	last_pressed_lang = PersistantScene.settings.Languages.ar
	PersistantScene.localizer.apply_lang(last_pressed_lang)
	pass

func _on_english_pressed():
	last_pressed_lang = PersistantScene.settings.Languages.en
	PersistantScene.localizer.apply_lang(last_pressed_lang)
	pass
