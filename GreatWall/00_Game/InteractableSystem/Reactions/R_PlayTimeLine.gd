extends Reaction
class_name R_PlayTimeLine

export var dialog_name = "L_00_Intro"
export var dialog_scene_path = "res://00_Game/Scenes/LDialogNode.tscn"
const dialog_canvas_group = "Dialogs Canvas"

func _react():
	if dialog_name.empty():
		_complete_reaction()
		return
	
	var dialog = Dialogic.start(dialog_name,true,dialog_scene_path)
	var canvas = _get_dialogs_canvas()
	canvas.add_child(dialog)
	
	yield(dialog,"timeline_end")
	while not Extentions.is_node_null(dialog):
		yield(get_tree(),"idle_frame")
		continue
	
	_complete_reaction()
	pass

func _get_dialogs_canvas():
	var canvases = get_tree().get_nodes_in_group(dialog_canvas_group)
	if not canvases.size() == 0:
		return canvases[0]
	
	var canvas = CanvasLayer.new()
	canvas.name = "Dialogs Canvas"
	get_tree().current_scene.add_child(canvas)
	var new_index = 0
	
	var gameuis = get_tree().get_nodes_in_group("GameUI")
	
	if gameuis.size() != 0:
		var gameui : Node = gameuis[0]
		var gameui_index = gameui.get_index()
		if gameui_index>0:
			new_index = gameui_index
	
	get_tree().current_scene.move_child(canvas,new_index)
	canvas.add_to_group(dialog_canvas_group)
	return canvas
