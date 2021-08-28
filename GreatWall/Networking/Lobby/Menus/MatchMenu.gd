extends BaseMenu

signal on_back_pressed
signal on_tried_to_start_game

export(NodePath) var back_button = null
export(NodePath) var displays_head_path = null
export(PackedScene) var display_template = null

var displays_head = null

func _ready():
	displays_head = get_node(displays_head_path)
	pass

func add_player_display(player,player_name):
	var displayer = display_template.instance()
	displays_head.add_child(displayer)
	displayer.setup(player,player_name)
	pass

func remove_player_display(player):
	for c in displays_head.get_children():
		if c.is_owned_by(player):
			c.queue_free()
	pass

func set_can_start_game(state):
	var b : Button = get_node(back_button)
	b.visible = state
	pass

func _on_StartGame_button_up():
	emit_signal("on_tried_to_start_game")
	pass

func _on_BackButton_button_up():
	emit_signal("on_back_pressed")
	pass
