extends CanvasLayer

@export(NodePath) var network_manager_path = ""

@export(NodePath) var discon_button_head_path = ""
@export(NodePath) var con_buttons_head_path = ""
@export(NodePath) var status_path = ""

var network_manager : NetworkManager = null
var status : Label = null
var con_buttons_head = null
var discon_button_head = null

func _ready():
	status = get_node(status_path)
	con_buttons_head = get_node(con_buttons_head_path)
	discon_button_head = get_node(discon_button_head_path)
	if not has_node(network_manager_path) or not get_node(network_manager_path) is NetworkManager:
		print("Must Supply Path To A NetworkManager, else this UI Will not function properly, returning")
		return
	network_manager = get_node(network_manager_path)
	discon_button_head.visible = false
	con_buttons_head.visible = true
	
	network_manager.connect("on_connected_to_server",self,"_on_connected_successfully")
	network_manager.connect("on_connection_to_server_failed",self,"_on_connection_failed")
	pass

func _on_Address_text_changed(new_text):
	if network_manager == null:
		return
	network_manager.address = new_text
	pass

func _on_Port_text_changed(new_text):
	if network_manager == null:
		return
	network_manager.port = int(new_text)
	pass

func _on_Host_button_down():
	if network_manager == null:
		return
	if network_manager.is_connected_to_net():
		return
	var result = network_manager.start_server_def()
	var msg = "Status: Hosted Successfully"
	if result != OK:
		msg = "Status: Could Not Host Had Error : " + str(result)
	else:
		discon_button_head.visible = true
		con_buttons_head.visible = false
	status.text = msg
	pass

func _on_Join_button_down():
	if network_manager == null:
		return
	if network_manager.is_connected_to_net():
		return
	var result = network_manager.start_client_def()
	var msg = "Status: Attempting To Join"
	if result != OK:
		msg = "Status: Could Not Join Had Error : " + str(result)
	else:
		discon_button_head.visible = true
		con_buttons_head.visible = false
	status.text = msg
	pass


func _on_Disconnect_button_down():
	if network_manager == null:
		return
	if not network_manager.is_connected_to_net():
		return
	if network_manager.is_server_running:
		network_manager.stop_server()
	else:
		network_manager.stop_client()
	status.text = "Status: Disconnected Successfully"
	con_buttons_head.visible = true
	discon_button_head.visible = false
	pass

func _on_connected_successfully(local_player):
	status.text = str(local_player) + " : Connected Sucecssfully"
	pass

func _on_connection_failed():
	status.text = "Connection To Server Failed"
	pass
