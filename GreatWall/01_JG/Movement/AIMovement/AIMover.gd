extends MoveSystem
class_name AIMover

"""
Childed to KinematicBody2D
Moves to a target point
Has stopping/arrival settings
Must be called by something else
can't act on its own
"""

signal on_move_started
signal on_stopped
signal on_started_slowing

@export var saftey_dir_threshold = 0.065
@export var body_is_parent = true
@export var max_speed = 100
@export var slowing_rad = 20
@export var stopping_rad = 5
@export var slowing_factor = 1.5
@export var stopping_speed = 3

var is_moving : bool = false
var dist : float = 0
var usable_speed : float = 0
var dir : Vector2 = Vector2.ZERO

var target_point : Node2D = null
var target_pos : Vector2 = Vector2.ZERO
var body : KinematicBody2D = null
var snap : bool = false
var is_slowing : bool = false
var last_non_zero_dir : Vector2 = Vector2.ZERO
var last_non_zero_dir_safe : Vector2 = Vector2.ZERO
var saftey_counter = 0

func _ready():
	if body_is_parent:
		body = get_parent()
	pass

func setup(_body:KinematicBody2D):
	body = _body
	pass

func _move_fixed_update(delta):

	if body == null:
		return
	
	_update_non_zero_move_dir(delta)
	if not is_moving:
		dir = Vector2.ZERO
		return
	
	_update_calculations()
	
	if dist>slowing_rad:
		is_slowing = false
	elif dist<=slowing_rad and dist>stopping_rad:
		usable_speed = _slowing_down(dist,usable_speed)
	elif dist<=stopping_rad:
		usable_speed = _stopping(dist,usable_speed)
		if usable_speed<stopping_speed:
			is_moving = false
			usable_speed = 0
			emit_signal("on_stopped")
	
	var vel = dir * usable_speed
	var _rem_vel = body.move_and_slide(vel)
	pass

func move_to_point(_target_point:Node2D, _snap:bool = false):
	if _target_point == null:
		return
	
	if is_in_move_range(_target_point.global_position):
		target_point = _target_point
		target_pos = target_point.global_position
		snap = _snap
		is_moving = true
		emit_signal("on_move_started")
	pass

func move_to_pos(_target_pos:Vector2, _snap:bool = false):
	if is_in_move_range(_target_pos):
		target_pos = _target_pos
		target_point = null
		snap = _snap
		is_moving = true
		emit_signal("on_move_started")
	pass

func is_in_move_range(pos:Vector2):
	var test_dist = pos.distance_to(body.global_position)
	return test_dist>slowing_rad

func _slowing_down(curr_dist,curr_speed):
	if snap:
		return curr_speed
	
	if not is_slowing:
		is_slowing = true
		emit_signal("on_started_slowing")
	var fraction = (curr_dist/slowing_rad)*slowing_factor
	var damped_speed = curr_speed * fraction
	return damped_speed

func _update_non_zero_move_dir(delta):
	if dir != Vector2.ZERO:
		last_non_zero_dir = dir
		
		if last_non_zero_dir_safe != last_non_zero_dir:
			saftey_counter = saftey_counter + delta/saftey_dir_threshold
		else:
			saftey_counter = 0
		if saftey_counter>=1:
			last_non_zero_dir_safe = last_non_zero_dir
			saftey_counter = 0
	pass

func _stopping(_curr_dist,_curr_speed):
	if snap:
		return 0
	
	return 0

func _update_calculations():
	if target_point != null:
		target_pos = target_point.global_position
	
	dir = target_pos - body.global_position
	usable_speed = max_speed
	dist = dir.length()
	dir = dir.normalized()
	pass
