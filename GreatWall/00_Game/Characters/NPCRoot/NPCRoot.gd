extends BaseChara

var move_by_nav : MoveByNav = null

func _i_ready():
	move_by_nav = get_node("MoveByNav")
	var _er = move_by_nav.connect("on_move_started",self,"_on_move_started")
	_er = move_by_nav.connect("on_stopped",self,"_on_move_completed")
	_set_new_idle_anim()
	play_anim(_get_idle_anim_name())
	pass

func _process(_delta):
	animator.update_dir(move_by_nav.last_non_zero_dir_safe)
	pass

func _on_move_started():
	play_anim(move_anim_name)
	pass

func _on_move_completed():
	_set_new_idle_anim()
	play_anim(_get_idle_anim_name())
	pass
