extends BaseMenu

func _i_ready():
	
	var last_level = PersistantScene.settings.get_last_played_level()
	
	if last_level.empty():
		$BG/VBox/Continue._de_activate_button()
	
	$BG/VBox/Continue.connect("button_up",self,"_on_continue_pressed")
	$BG/VBox/NewGame.connect("button_up",self,"_on_new_game_pressed")
	$BG/VBox/Settings.connect("button_up",self,"_on_settings_pressed")
	$BG/VBox/Quit.connect("button_up",self,"_on_quit_pressed")
	
	pass

func _on_continue_pressed():
	
	pass

func _on_new_game_pressed():
	PersistantScene.lm.go_to_scene("Level_00")
	pass

func _on_settings_pressed():
	get_parent().open_menu("SettingsMenu")
	pass

func _on_quit_pressed():
	get_tree().quit()
	pass
