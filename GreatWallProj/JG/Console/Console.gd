extends CanvasLayer
class_name Console

export var activate_on_start = true
export var group_name = "Console"
signal on_entered_command(command)
var line : LineEdit
var label : RichTextLabel
var panel : Panel
var written_lines = []

func _ready():
	line = $Cont/Panel/VBox/LineEdit
	label = $Cont/Panel/VBox/Label
	panel = $Cont/Panel
	var _er = line.connect("text_entered",self,"_on_send_command")
	add_to_group(group_name)
	write_line("Console Initialized")
	panel.visible = activate_on_start
	if activate_on_start:
		line.grab_focus()
	pass

func _input(ev):
	if ev is InputEventKey and Input.is_key_pressed(KEY_QUOTELEFT):
		request_switch()
	pass

func _on_send_command(command:String):
	var msg = "Command Entered :: " + command
	write_line_col(msg,Color.aqua)
	emit_signal("on_entered_command",command)
	line.text = ""
	pass

func write_line(new_text:String):
	var t = "\n" +new_text
	written_lines.append(t)
	label.bbcode_text = label.bbcode_text + t
	pass

func write(new_text:String):
	if written_lines.size() == 0:
		written_lines.append(new_text)
		label.bbcode_text = label.bbcode_text + new_text
		return
	
	var last_text = written_lines[written_lines.size()-1]
	last_text = last_text + new_text
	written_lines[written_lines.size()-1] = last_text
	label.bbcode_text = label.bbcode_text + new_text
	pass

func write_line_er(new_text : String):
	write_line_col(new_text,Color.red)
	pass

func write_line_war(new_text : String):
	write_line_col(new_text,Color.yellow)
	pass

func write_line_col(new_text : String,col:Color):
	write_line(get_colored(new_text,col))
	pass

func get_colored(new_text:String,col:Color):
	var start = "[color=#"+str(col.to_html())+"]"
	var end = "[/color]"
	var total = start+new_text+end
	return total

func request_switch():
	panel.visible = !panel.visible
	yield (get_tree(),"idle_frame")
	if $Cont/Panel.visible:
		line.grab_focus()
	line.text = ""
	pass
