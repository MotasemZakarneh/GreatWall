extends BaseMenu

func _i_ready():
	var _er = $HBox/Arabic.connect("button_up",self,"_on_arabic_selected")
	_er = $HBox/English.connect("button_up",self,"_on_english_selected")
	pass

func _on_arabic_selected():
	PersistantScene.localizer.set_new_lang(PersistantScene.settings.Languages.ar)
	get_parent().open_menu("PlayMenu")
	pass

func _on_english_selected():
	PersistantScene.localizer.set_new_lang(PersistantScene.settings.Languages.en)
	get_parent().open_menu("PlayMenu")
	pass
