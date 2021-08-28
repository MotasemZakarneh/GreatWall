extends JG_Audio
class_name SFXDynamicGroup

export var remove_on_dest = false
export var play_rnd = true

func _ready():
	yield(get_tree(),"idle_frame")
	var _er = connect("tree_exiting",self,"_on_destroy")
	PersistantScene.sfx_manager.add_group(self)
	pass

func _on_destroy():
	if remove_on_dest:
		PersistantScene.sfx_manager.remove_group(self)
	pass
