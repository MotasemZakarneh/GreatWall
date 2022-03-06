extends CanvasLayer
class_name Console

@export var activate_on_start = true
@export var group_name = "Console"
@export var auto_popup_on_write = true

signal on_entered_command(command)
signal on_was_set_up

var line : LineEdit
var label : RichTextLabel
var panel : Panel
var written_lines = []
var was_set_up = false

func _ready():
	set_up()
	pass

func set_up():
	if was_set_up:
		return
	
	was_set_up = true
	line = $Cont/Panel/VBox/LineEdit
	label = $Cont/Panel/VBox/Label
	panel = $Cont/Panel
	var _er = line.connect("text_entered",_on_send_command)
	add_to_group(group_name)
	write("Console Initialized")
	panel.visible = activate_on_start
	if activate_on_start:
		line.grab_focus()
	_er = connect("on_entered_command",_on_command_entered)
	emit_signal("on_was_set_up")
	pass

func _input(ev):
	if ev is InputEventKey and Input.is_key_pressed(KEY_QUOTELEFT):
		request_switch()
	pass

func _on_send_command(command:String):
	command = command.to_lower()
	var msg = "Command Entered :: " + command
	write_cmd(msg)
	emit_signal("on_entered_command",command)
	line.text = ""
	show_up()
	pass

func write(new_text):
	if not was_set_up:
		await on_was_set_up
	var txt = "null"
	if new_text != null:
		txt = str(new_text)
	
	var t = "\n" +txt
	written_lines.append(t)
	label.bbcode_text = label.bbcode_text + t
	show_up()
	pass

func write_close(new_text):
	if not was_set_up:
		await on_was_set_up
	
	var txt = "null"
	if new_text != null:
		txt = str(new_text)
	
	if written_lines.size() == 0:
		written_lines.append(txt)
		label.bbcode_text = label.bbcode_text + txt
		show_up()
		return
	
	var last_text = written_lines[written_lines.size()-1]
	last_text = last_text + txt
	written_lines[written_lines.size()-1] = last_text
	label.bbcode_text = label.bbcode_text + txt
	show_up()
	pass

func write_er(new_text):
	write_col(new_text,Color.RED)
	pass

func write_warn(new_text):
	write_col(new_text,Color.YELLOW)
	pass

func write_good(new_text):
	write_col(new_text,Color.GREEN)
	pass

func write_cmd(new_text):
	write_col(new_text,Color.AQUA)
	pass

func write_col(new_text,col:Color):
	write(get_colored(new_text,col))
	pass

func get_colored(new_text,col:Color):
	var start = "[color=#"+str(col.to_html())+"]"
	var end = "[/color]"
	var total = start+new_text+end
	return total

func request_switch():
	panel.visible = !panel.visible
	
	if get_tree() == null:
		return
	
	await get_tree().idle_frame
	if $Cont/Panel.visible:
		line.grab_focus()
	line.text = ""
	pass

func show_up():
	if auto_popup_on_write and not panel.visible:
		request_switch()
	pass

func _on_command_entered(command:String):
	if command == "cls":
		label.bbcode_text = ""
		write_cmd("Command Entered :: cls")
		pass
	pass


const main_console = preload("res://01_JG/Console/MainConsole.tscn")
const main_console_group = "MainConsole"

static func get_main(caller : Node):
	return get_console(caller,main_console,main_console_group)

static func get_console(caller : Node,scene:PackedScene,group : String):
	if group == "":
		return null
	
	var consoles = caller.get_tree().get_nodes_in_group(group)
	var console_node : Node = null
	if consoles.size()==0:
		if scene == null:
			return null
		console_node = scene.instance()
		if not console_node.is_in_group(group):
			console_node.add_to_group(group)
		caller.get_tree().root.call_deferred("add_child",console_node)
	else:
		console_node = consoles[0]
	return console_node
