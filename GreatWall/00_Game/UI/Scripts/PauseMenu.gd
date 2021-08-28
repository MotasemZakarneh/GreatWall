extends BaseMenu

func _i_ready():
	var _er = $BG/VBox/Quit.connect("button_up",self,"_on_quit_pressed")
	_er = $BG/VBox/Settings.connect("button_up",self,"_on_settings_pressed")
	_er = $BG/VBox/Restart.connect("button_up",self,"_on_restart_pressed")
	_er = $BG/VBox/Resume.connect("button_up",self,"_on_resume_pressed")
	pass

func _i_on_open():
	get_tree().paused = true
	pass

func _on_quit_pressed():
	get_tree().quit()
	pass

func _on_settings_pressed():
	get_parent().open_menu("SettingsMenu")
	pass

func _on_restart_pressed():
	var _er = get_tree().reload_current_scene()
	pass

func _on_resume_pressed():
	get_parent().close_menu(name)
	get_tree().paused = false
	pass

func _i_on_back_pressed():
	_on_resume_pressed()
	pass
