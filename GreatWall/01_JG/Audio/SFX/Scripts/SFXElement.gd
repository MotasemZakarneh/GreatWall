extends JG_Audio
class_name SFXElement

@export var weigth = 3 
@export var audio_clip : Resource = null
@export var rnd_pitch = Vector2(-0.1,0.1)
@export var max_dist = 2000
@export var attenuation = 1.5
@export var bus = "SFX"
@export var volume = 1.0

const sfx_template = preload("res://01_JG/Audio/SFX/SFXTemplate.tscn")
const sfx_template_no_dist = preload("res://01_JG/Audio/SFX/SFXTemplateNoDist.tscn")
var voices = []

func setup():
	for i in weigth:
		var template = sfx_template
		if max_dist<=0:
			template = sfx_template_no_dist
		
		var cloned = template.instance()
		cloned.bus = bus
		cloned.stream = audio_clip
		cloned.volume_db = Extentions.percent2db(volume)
	
		voices.append(cloned)
		add_child(cloned)
	pass

func try_play_element(caller:Node2D)->bool:
	var free_player = get_free_player()
	
	if free_player == null:
		return false
	
	if caller != null and max_dist>0:
		free_player.global_position = caller.global_position
	
	free_player.pitch_scale = 1 + _get_rnd_pitch()
	
	if max_dist>0:
		free_player.max_distance = max_dist
		free_player.attenuation = attenuation
	
	free_player.play()
	return true

func has_free_player():
	for v in voices:
		if v.playing:
			continue
		return true
	return false

func _get_rnd_pitch():
	return randf_range(rnd_pitch.x,rnd_pitch.y)

func get_free_player():
	for v in voices:
		if v.playing:
			continue
		return v
	return null
