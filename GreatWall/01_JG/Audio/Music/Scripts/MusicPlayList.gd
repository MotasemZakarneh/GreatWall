extends JG_Audio
class_name MusicPlayList

enum DefPlayMode{Chronogical,ContinueAtLast,RndTrack}
export (DefPlayMode) var def_play_mode = DefPlayMode.Chronogical
export var loop = true
export var is_playing = false
export var auto_play = false

var elements = []
var active_element = null
var was_autoplayed = false
var was_setup = false

var last_element_name = ""
var played_rnd_tracks = []

func setup():
	if was_setup:
		return
	
	was_setup = true
	elements = Extentions.get_children_of_type(self,[MusicElement])
	
	if elements.size() == 1:
		var s = PackedScene.new()
		s.pack(elements[0])
		var copy_element = s.instance()
		copy_element.name = "Copy_"+copy_element.name
		elements[0].get_parent().add_child(copy_element)
		elements.append(copy_element)
	
	for e in elements:
		e.setup()
		e.connect("has_reached_cross_fade",self,"_on_started_cross_fade")
	pass

func play_and_clear_data(_element_name = ""):
	last_element_name = ""
	played_rnd_tracks.clear()
	play()
	pass

func play(element_name = ""):
	if elements.size()==0:
		return
	
	var e = null
	
	if not element_name.empty():
		e = _get_element_by_name(element_name)
	elif element_name.empty() and _is_continue_at_last_element() and not last_element_name.empty():
		e = _get_element_by_name(last_element_name)
	elif element_name.empty() and _is_rnd_track():
		e = _get_rnd_element()
	elif element_name.empty() and _is_chronogical():
		e = elements[0]
	else:
		e = elements[0]
	
	if e == null:
		return
	
	if active_element == e:
		print("Trying to start, and stop same element, not allowed")
		return
	
	_call_stop()
	
	active_element = e
	active_element.play()
	is_playing = true
	pass

func ext_call_stop():
	if active_element != null:
		last_element_name = active_element.name
	_call_stop()
	pass

func _call_stop():
	if active_element != null:
		active_element.call_stop()
		active_element = null
		is_playing = false
	pass

func _get_element_by_name(element_name):
	for e in elements:
		if e.name == element_name:
			return e
	return null

func _get_rnd_element():
	randomize()
	var randomizables = []
	for e in elements:
		randomizables.append(e)
	
	for played in played_rnd_tracks:
		randomizables.erase(played)
	#Added so that, once a loop is completed
	#then we can avoid the last played track
	if not last_element_name.empty():
		var last_ele = _get_element_by_name(last_element_name)
		if randomizables.has(last_ele):
			randomizables.erase(last_ele)
	
	#So that, when we are looping clips, we never, get same clip twice
	if active_element != null and randomizables.has(active_element):
		randomizables.erase(active_element)
	
	if randomizables.size() == 0:
		return null
	
	var rnd_index = randi() % randomizables.size()
	var rnd_element = randomizables[rnd_index]
	
	played_rnd_tracks.append(rnd_element)
	return rnd_element

func _on_started_cross_fade(element):
	var index = _get_index(element)
	
	#for continue, and chronogical
	var new_index = index + 1
	if _is_rnd_track():
		var rnd_element = _get_rnd_element()
		if rnd_element == null and loop:
			played_rnd_tracks.clear()
			rnd_element = _get_rnd_element()
		new_index = _get_index(rnd_element)
		if new_index == -1:
			is_playing = false
			return
	
	if new_index >= elements.size() and loop:
		new_index = 0
	elif new_index >= elements.size() and not loop:
		is_playing = false
		if _is_continue_at_last_element():
			last_element_name = ""
		return
	 
	play(elements[new_index].name)
	pass

func _get_index(element):
	var i = -1
	if element == null:
		return i
	
	for e in elements:
		i = i + 1
		if e == element:
			return i
	return i

func _get_index_of_name(element_name):
	var i = -1
	for e in elements:
		i = i + 1
		if e.name == element_name:
			return i
	return i

func _is_continue_at_last_element():
	return def_play_mode == DefPlayMode.ContinueAtLast

func _is_rnd_track():
	return def_play_mode == DefPlayMode.RndTrack

func _is_chronogical():
	return def_play_mode == DefPlayMode.Chronogical
