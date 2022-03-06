extends Object

class SafeWaiter:
	var caller : Node = null
	var frame_timer : Timer = null
	
	func setup(caller):
		self.caller = caller
		frame_timer = Timer.new()
		frame_timer.one_shot = true
		caller.add_child(frame_timer)
		pass
	
	func wait_for_time_async(t:float):
		var timer : Timer = Timer.new()
		timer.wait_time = t
		timer.one_shot = true
		timer.start()
		caller.add_child(timer)
		await timer.timeout
		timer.queue_free()
		pass
	
	func wait_for_frame_async():
		frame_timer.wait_time = caller.get_process_delta_time()
		frame_timer.start()
		await frame_timer.timeout
		pass

