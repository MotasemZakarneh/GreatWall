extends MoveSystem
class_name MoveByNav

"""
Must have a sibling of MoveToPoint
Does not act on its own, must be called externally
When this is Called the object will move by Navigation
"""

signal on_move_started
signal on_stopped

@export var nav_group = "AIPath"
@export var saftey_dir_threshold = 0.065

var is_moving : bool = false
var target_point : Node2D = null
var target_pos : Vector2 = Vector2.ZERO
var nav : Navigation2D = null
var path = []
var mover : AIMover = null
var dir : Vector2 = Vector2.ZERO
var last_non_zero_dir : Vector2 = Vector2.ZERO
var last_non_zero_dir_safe : Vector2 = Vector2.ZERO
var body = null
var saftey_counter = 0

func _ready():
	body = get_parent()
	nav = get_tree().get_nodes_in_group(nav_group)[0]
	mover = get_parent().get_node("AIMover")
	pass

func _move_fixed_update(delta):
	dir = Vector2.ZERO
	_update_movement()
	_update_non_zero_dir(delta)
	pass

func _update_movement():
	if not is_moving:
		return
	path = nav.get_simple_path(body.global_position,_get_target_pos())
	if path.size() == 0:
		_stop_movement()
		return
	
	while path.size()>0:
		if mover.is_in_move_range(path[0]):
			break
		path.remove(0)
	
	if path.size() == 0:
		_stop_movement()
		return
	
	mover.move_to_pos(path[0])
	dir = path[0] - body.global_position
	dir = dir.normalized()
	pass

func move_to_point(_target_point:Node2D):
	if _target_point == null:
		return
	
	if mover.is_in_move_range(_target_point.global_position):
		target_point = _target_point
		target_pos = _target_point.global_position
		is_moving = true
		emit_signal("on_move_started")
	pass

func move_to_pos(_target_pos : Vector2):
	if mover.is_in_move_range(_target_pos):
		target_point = null
		target_pos = _target_pos
		is_moving = true
		emit_signal("on_move_started")
	pass

func _update_non_zero_dir(delta):
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

func _get_target_pos():
	if target_point != null:
		return target_point.global_position
	return target_pos

func _stop_movement():
	if is_moving:
		is_moving = false
		emit_signal("on_stopped")
	pass
