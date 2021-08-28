extends MenusController

func _process(_delta):
	if Input.is_action_just_released("ui_cancel"):
		if active_menu == null:
			open_menu("PauseMenu")
		elif active_menu.name == "PauseMenu":
			_on_back_pressed()
	pass
