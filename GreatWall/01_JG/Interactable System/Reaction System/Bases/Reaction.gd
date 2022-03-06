extends ReactionSystem
class_name Reaction

@export var waits_till_done = false
@export var reaction_delay = 0.0
@export var reaction_duration = 0.0

signal on_completed
const reaction_group = "Reaction"
var is_done = false
var frame_timer : Timer = null

func _ready():
	frame_timer = Timer.new()
	frame_timer.one_shot = true
	if not is_in_group(reaction_group):
		add_to_group(reaction_group)
	pass

func react():
	is_done = false
	await get_tree().idle_frame
	
	if reaction_delay>0:
		await _wait_for_time_async(reaction_delay)
	
	_react()
	while (not is_done) and waits_till_done:
		await _wait_for_frame_async()
	
	if reaction_duration>0:
		await _wait_for_time_async(reaction_duration)
	
	emit_signal("on_completed")
	pass

func _complete_reaction():
	is_done = true
	pass

#override this function in order to have special functionality for
#reactions, and the "is_done" must be set to true at the end
func _react():
	_complete_reaction()
	pass

func _wait_for_time_async(t:float):
	var timer : Timer = Timer.new()
	timer.wait_time = t
	timer.one_shot = true
	timer.start()
	await timer.timeout
	timer.queue_free()
	pass

func _wait_for_frame_async():
	frame_timer.wait_time = get_process_delta_time()
	frame_timer.start()
	await frame_timer.timeout
	pass
