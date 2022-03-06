extends JG_Audio
class_name MusicElement

signal on_stopped(element)
signal has_reached_cross_fade(element)

@export var fade_time = 2
@export var music : AudioStream = null
@export var bus = "Music"
@export var volume = 1
@export var loop = false

const music_template = preload("res://01_JG/Audio/Music/MusicTemplate.tscn")

var music_player : AudioStreamPlayer = null
var tween : Tween = null

var is_stopping = false
var is_starting = false

func _process(_delta):
	if music_player == null:
		return
	
	if not music_player.playing:
		return
	
	if is_stopping:
		return
	
	var remaining = music_player.stream.get_length() - music_player.get_playback_position()
	if remaining < _get_fade_time():
		emit_signal("has_reached_cross_fade",self)
		call_stop()
	pass

func setup():
	music_player = music_template.instance()
	add_child(music_player)
	
	music_player.stream = music
	music_player.bus = bus
	var db_vol = Extentions.percent2db(0)
	music_player.volume_db = db_vol
	
	tween = create_tween()
	tween.stop()
	#tween.name = "Tween"
	#add_child(tween)
	tween.connect("tween_completed",_on_tween_completed)
	pass

func play():
	if music_player.stream == null:
		return
	if music_player.stream.get_length()<_get_fade_time():
		return
	if music_player.playing:
		return
	
	music_player.play()
	var start_val = music_player.volume_db
	var final_val = Extentions.percent2db(volume)
	var _er = tween.interpolate_property(music_player,"volume_db",start_val,final_val,_get_fade_time(),tween.TRANS_SINE,tween.EASE_IN_OUT)
	is_starting = true
	_er = tween.start()
	pass

func call_stop():
	if is_stopping:
		return
	
	is_stopping = true
	var start_val = music_player.volume_db
	var final_val = Extentions.percent2db(0)
	var _er = tween.interpolate_property(music_player,"volume_db",start_val,final_val,_get_fade_time(),tween.TRANS_SINE,tween.EASE_IN_OUT)
	_er = tween.start()
	pass

func _get_fade_time():
	if fade_time>0:
		return fade_time
	return PersistantScene.music_controller.crossfade_time

func _on_tween_completed(_obj,_key):
	if is_stopping:
		emit_signal("on_stopped",self)
		music_player.stop()
	
	_clean_tween()
	pass

func _clean_tween():
	if is_stopping:
		is_stopping = false
		tween.stop()
	if is_starting:
		is_starting = false
	pass
