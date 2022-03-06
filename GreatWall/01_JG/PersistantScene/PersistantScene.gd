extends Node
signal on_destroy_persistant

var sfx_manager : SFXManager = null
var music_controller : MusicController = null
var localizer : Localizer = null
var settings : SimpleSettings = null
var lm : LevelsManager = null

func _ready():
	sfx_manager = get_node("SFXManager")
	localizer = get_node("Localizer")
	settings = get_node("SimpleSettings")
	music_controller = get_node("MusicController")
	lm = get_node("LevelsManager")
	
	var _er = connect("tree_exiting",_on_destroy)
	pass

func _on_destroy():
	emit_signal("on_destroy_persistant")
	pass
