extends MoveSystem
class_name MoveInputReader

export var up_map = "ui_up"
export var down_map = "ui_down"
export var right_map = "ui_right"
export var left_map = "ui_left"

export var saftey_input_threshold = 0.065
export var min_input_length = 0.1

var input = Vector2()
var last_non_zero_input = Vector2()
var last_non_zero_input_safe = Vector2(0,1)
var saftey_counter = 0

func _process(delta):
	_set_move_input()
	_set_last_non_zero_input(delta)
	pass

func _set_move_input():
	input.x = 0
	
	if Input.is_action_pressed(right_map):
		input.x += 1
	if Input.is_action_pressed(left_map):
		input.x -= 1
	
	input.y = 0
	
	if Input.is_action_pressed(up_map):
		input.y -= 1
	if Input.is_action_pressed(down_map):
		input.y += 1
	pass

func is_last_input_valid():
	return input.length()>min_input_length

func _set_last_non_zero_input(delta):
	if input != Vector2.ZERO:
		last_non_zero_input = input
		
		if last_non_zero_input_safe != last_non_zero_input:
			saftey_counter = saftey_counter + delta/saftey_input_threshold
		else:
			saftey_counter = 0
		if saftey_counter>=1:
			last_non_zero_input_safe = last_non_zero_input
			saftey_counter = 0
	pass
