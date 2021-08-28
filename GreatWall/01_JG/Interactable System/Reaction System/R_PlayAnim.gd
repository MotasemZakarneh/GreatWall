extends Reaction
class_name R_PlayAnim

export(NodePath) var p = ""
export var player_group = ""
export var anim_name = ""

func _react():
	if anim_name.empty():
		_complete_reaction()
		return
	
	var player : AnimationPlayer = null
	if not p.empty():
		player = get_node(p)
	elif not player_group.empty():
		player = get_tree().get_nodes_in_group(player_group)[0]
	else:
		_complete_reaction()
		return
	
	player.play(anim_name)
	yield(player,"animation_finished")
	_complete_reaction()
	pass
