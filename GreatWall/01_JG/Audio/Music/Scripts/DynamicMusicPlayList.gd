extends JG_Audio
class_name DynamicMusicPlayList

export(MusicPlayList.DefPlayMode) var def_play_mode
export var auto_remove_on_dest = false
export var loop = true
export var auto_play = false

func _ready():
	yield(get_tree(),"idle_frame")
	var _er = connect("tree_exiting",self,"_on_destroy")
	PersistantScene.music_controller.add_play_list(self)
	pass

func _on_destroy():
	if auto_remove_on_dest:
		PersistantScene.music_controller.remove_play_list(self)
	pass
