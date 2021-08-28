extends JG_Audio
class_name MusicController

export var crossfade_time = 3

var play_lists = []
var active_playlist = null

func _ready():
	yield(get_tree(),"idle_frame")
	apply_new_music(PersistantScene.settings.music_vol)
	
	play_lists = Extentions.get_children_of_type(self,[MusicPlayList])
	for p in play_lists:
		p.setup()
	
	yield(get_tree(),"idle_frame")
	_try_play_last_autoplay()
	pass

func apply_new_music(new_music):
	var music_index = AudioServer.get_bus_index("Music")
	
	if music_index>0:
		var new_music_vol = Extentions.percent2bus(new_music)
		AudioServer.set_bus_volume_db(music_index,new_music_vol)
	else:
		print("There is no music bus")
	
	pass

func play(playlist:String,element_name:String=""):
	var l = _get_play_list_by_name(playlist)
	
	if l == null:
		if playlist.empty():
			return
		print ("Couldnt find playlist " + str(playlist))
		return
	
	if active_playlist != null:
		if l.name == active_playlist.name:
			return
		active_playlist.call_stop()
	
	active_playlist = l
	active_playlist.play(element_name)
	pass

func add_play_list(new_list:DynamicMusicPlayList):
	var existing_l = _get_play_list_by_dynamic(new_list)
	if existing_l != null:
		return
	
	var list = MusicPlayList.new()
	
	list.loop = new_list.loop
	list.def_play_mode = new_list.def_play_mode
	list.auto_play = new_list.auto_play
	list.name = new_list.name
	
	add_child(list)
	
	for c in new_list.get_children():
		var s = PackedScene.new()
		s.pack(c)
		
		var cloned_child = s.instance()
		list.add_child(cloned_child)
	
	list.setup()
	play_lists.append(list)
	
	_try_play_last_autoplay()
	pass

func remove_play_list(list_to_remove:DynamicMusicPlayList):
	var l = _get_play_list_by_dynamic(list_to_remove)
	if l == null:
		return
	
	play_lists.erase(l)
	l.queue_free()
	pass

func _try_play_last_autoplay():
	var last = _get_last_auto_play()
	if last != null and not last.was_autoplayed:
		play(last.name)
		last.was_autoplayed = true
	pass

func _get_play_list_by_name(list_name:String):
	for l in play_lists:
		if l.name == list_name:
			return l
	return null

func _get_play_list_by_dynamic(dynamic_playlist:DynamicMusicPlayList):
	for l in play_lists:
		if l.name == dynamic_playlist.name:
			return l
	return null

func _get_last_auto_play():
	var last = null
	for l in play_lists:
		if l.auto_play:
			last = l
	return last
