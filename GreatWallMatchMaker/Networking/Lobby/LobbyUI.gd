extends CanvasLayer
class_name LobbyUI

signal on_back_pressed

export(PackedScene) var player_display_scene
export (NodePath) var player_displays_node_path
export (NodePath) var line_edit_node_path
export (NodePath) var chat_node_path
export var auto_hide = true

var player_displays_head : VBoxContainer = null

func _ready():
	if not is_in_group("LobbyUI"):
		add_to_group("LobbyUI")
	player_displays_head = get_node(player_displays_node_path)
	if auto_hide:
		hide_ui()
	pass

func refresh_players(players_data):
	for c in player_displays_head.get_children():
		c.queue_free()
	for p in players_data:
		var n = players_data[p]
		add_player_by_name(p,n)
	pass

func add_player(player,address,port):
	var n : Control = player_display_scene.instance()
	player_displays_head.add_child(n)
	n.setup(player,address,port)
	n.rect_position = Vector2.ZERO
	pass

func add_player_by_name(player,player_name):
	var n : Control = player_display_scene.instance()
	player_displays_head.add_child(n)
	n.setup_by_name(player,player_name)
	n.rect_position = Vector2.ZERO
	pass

func remove_player(player):
	var player_display = null
	for c in player_displays_head.get_children():
		if c.is_owned_by(player):
			player_display = c
			break
	if player_display == null:
		return
	player_display.queue_free()
	pass

func _on_LineEdit_text_entered(new_text):
	var line_edit = get_node(line_edit_node_path)
	line_edit.text = ""
	var chat : RichTextLabel = get_node(chat_node_path)
	chat.bbcode_text = chat.bbcode_text + "\n" + new_text
	pass

func clear_clients_list():
	for c in player_displays_head.get_children():
		c.queue_free()
	pass

func hide_ui():
	$Control.visible = false
	pass

func show_ui():
	$Control.visible = true
	pass

func _on_BackButton_button_down():
	emit_signal("on_back_pressed")
	pass
