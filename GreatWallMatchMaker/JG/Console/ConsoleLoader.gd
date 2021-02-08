extends Object
class_name ConsoleLoader

const main_console = preload("res://JG/Console/Console.tscn")
const main_console_group = "Console"

static func get_main(caller : Node):
	return get_console(caller,main_console,main_console_group)

static func get_console(caller : Node,scene:PackedScene,group : String):
	var consoles = caller.get_tree().get_nodes_in_group(group)
	var console_node : Node = null
	if consoles.size()==0:
		console_node = scene.instance()
		caller.get_tree().root.add_child(console_node)
	else:
		console_node = consoles[0]
	return console_node
