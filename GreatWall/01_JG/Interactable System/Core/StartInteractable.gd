extends Node2D
class_name StartInteractable

export var auto_inst_fade_out = false
export var auto_fade_out = true
export var auto_play_interactable = true

func _ready():
	
	yield(get_tree(),"idle_frame")
	if auto_play_interactable:
		$Interactable.interact()
		yield($Interactable,"on_interactable_finished")
	if auto_fade_out:
		if auto_inst_fade_out:
			$Fader.inst_fade_out()
		else:
			$Fader.def_fade_out()
	
	pass
