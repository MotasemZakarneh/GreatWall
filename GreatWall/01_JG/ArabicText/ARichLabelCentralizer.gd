tool
extends Node
class_name ARichLabelCentralizer

export var do_work = true

func _ready():
	if not is_in_group("TextModifier"):
		add_to_group("TextModifier")
	pass

func modify_text(curr_text:String):
	if curr_text.empty():
		return curr_text
	
	var start = "[center]"
	var end = "[/center]"
	var new_text = start+curr_text+end
	return new_text
