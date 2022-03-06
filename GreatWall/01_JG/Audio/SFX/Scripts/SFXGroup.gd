extends JG_Audio
class_name SFXGroup

@export var play_rnd = true

var last_played_element = -1
var elements = []
var was_setup = false

func setup():
	if was_setup:
		return
	
	was_setup = true
	elements = Extentions.get_children_of_type(self,[SFXElement])
	for e in elements:
		e.setup()
	pass

func play(element_name:String,caller:Node2D):
	var playable_ele = _get_playable_element(element_name)
	if playable_ele != null:
		playable_ele.try_play_element(caller)
	pass

func _get_playable_element(element_name:String)->SFXElement:
	if element_name != "":
		return _get_free_element_by_name(element_name)
	elif play_rnd:
		return _get_free_rnd_element()
	else:
		return _get_free_next_element()
	pass

func _get_free_rnd_element():
	var free_elements = []
	
	for e in elements:
		if e.has_free_player():
			free_elements.append(e)
	
	if free_elements.size() == 0:
		return null
	
	var rnd_index = randi()%free_elements.size()
	return free_elements[rnd_index]

func _get_free_next_element():
	var attempts = elements.size()
	var next_player = null
	
	while attempts>0:
		attempts = attempts - 1
		last_played_element = last_played_element + 1
		if last_played_element >= elements.size():
			last_played_element = 0
		var test_ele = elements[last_played_element]
		if test_ele.has_free_player():
			next_player = test_ele
			break
	
	return next_player

func _get_free_element_by_name(element_name):
	for e in elements:
		if e.name == element_name:
			if e.has_free_player():
				return e
	return null
