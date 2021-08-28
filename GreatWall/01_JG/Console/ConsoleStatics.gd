extends Resource
class_name ConsoleStatics

var main_inst = null

func was_main_born():
	return main_inst != null

func assign_main_cons(main_cons : Node):
	main_inst = main_cons
	main_inst.connect("tree_exited",self,"clean_up")
	#print("Main Was Born " + str(resource_path) + " :: " + str(resource_local_to_scene))
	pass

func clean_up():
	main_inst = null
	#print("Main Weas Cleaned " + str(resource_path))
	pass
