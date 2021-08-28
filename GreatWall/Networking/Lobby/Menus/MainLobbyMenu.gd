extends BaseMenu

signal on_back_pressed
signal on_create_pressed

export (PackedScene) var player_display_scene
export (PackedScene) var match_display_scene
export (NodePath) var player_displays_node_path
export (NodePath) var matches_displays_node_path

var player_displays_head : VBoxContainer = null
var matches_displays_head : Node = null
var chat_box = null

func _ready():
	player_displays_head = get_node(player_displays_node_path)
	matches_displays_head = get_node(matches_displays_node_path)
	pass

func refresh_matches_data(matches_data):
	for m in matches_data:
		var match_data = matches_data[m]
		add_match(match_data)
		
	pass

func add_match(match_data):
	var new_display = match_display_scene.instance()
	matches_displays_head.add_child(new_display)
	
	var id = match_data["id"]
	var match_name = match_data["name"]
	var privacy = match_data["pw"]!=""
	var curr_count = match_data["players"].size()
	var max_size = match_data["max_players"]
	var _host = match_data["host"]
	var map = match_data["map"]
	
	#match_data= {"id":id,"name":match_name,
	#"pw":match_pw,"players":[caller],"host":caller,"max_players":match_size}
	new_display.setup(id,match_name,curr_count,max_size,privacy,map)
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

func clear_clients_list():
	for c in player_displays_head.get_children():
		c.queue_free()
	pass

func _on_BackButton_button_down():
	emit_signal("on_back_pressed")
	pass

func _on_CreateButton_button_down():
	emit_signal("on_create_pressed")
	pass

func _on_ChatBox_on_text_submitted(_new_text):
	pass # Replace with function body.
