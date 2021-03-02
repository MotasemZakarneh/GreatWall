extends Object
class_name ConsoleLoader

const main_console = preload("res://JG/Console/Console.tscn")
const main_console_group = "Console"
const statics = preload("res://JG/Console/ConsoleStatics.tres")

static func get_main(caller : Node):
	var main_cons = null
	
	if not statics.was_main_born():
		main_cons = get_console(caller,main_console,main_console_group)
		statics.assign_main_cons(main_cons)
	else:
		main_cons = statics.main_inst
	
	return main_cons

static func get_console(caller : Node,scene:PackedScene,group : String):
	var consoles = caller.get_tree().get_nodes_in_group(group)
	var console_node : Node = null
	if consoles.size()==0:
		console_node = scene.instance()
		caller.get_tree().root.call_deferred("add_child",console_node)
	else:
		console_node = consoles[0]
	return console_node
