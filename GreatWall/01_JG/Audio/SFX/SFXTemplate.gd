extends AudioStreamPlayer2D

export var play_once = true
export var stop_threshold = 0.07

func _process(_delta):
	if playing and stream != null and stream.get("loop"):
		var total_len = stream.get_length()
		var curr_pos = get_playback_position()
		var remaining = total_len - curr_pos
		var remaining_percent = remaining/total_len
		if remaining_percent <= stop_threshold:
			stop()
	pass
