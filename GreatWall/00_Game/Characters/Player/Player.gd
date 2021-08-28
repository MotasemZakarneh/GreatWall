extends BaseChara

export var speed = 100
export var cam_follow_player = false

var velocity = Vector2.ZERO
var input_reader : MoveInputReader
var is_interacting = false

func _i_ready():
	input_reader = get_node("MoveInputReader")
	if not cam_follow_player:
		$Camera2D.set_as_toplevel(true)
	var interactables = get_tree().get_nodes_in_group(Interactable.interactable_group)
	for i in interactables:
		i.connect("on_interactable_finished",self,"_on_interaction_finished")
		i.connect("on_interactable_started",self,"_on_interaction_started")
	
	_set_new_idle_anim()
	play_anim(_get_idle_anim_name())
	pass

func _process(_delta):
	animator.set_active_anim_set(active_set)
	if is_interacting:
		return
	
	_update_movement()
	pass

func _update_movement():
	animator.update_dir(input_reader.last_non_zero_input)
	var anim = _get_idle_anim_name()
	velocity = Vector2.ZERO
	
	if input_reader.is_last_input_valid():
		velocity = input_reader.input.normalized()*speed
		anim = move_anim_name
	
	var _rem_vel = move_and_slide(velocity)
	play_anim(anim)
	pass

func _on_interaction_finished(_i):
	is_interacting = false
	pass

func _on_interaction_started(_i):
	is_interacting = true
	pass
