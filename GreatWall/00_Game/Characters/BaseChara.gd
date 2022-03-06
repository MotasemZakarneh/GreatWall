extends CharacterBody2D
class_name BaseChara

@export var chara_name = "MC"
@export var anim_sets : Array[Resource] =[]
@export var active_set = "3"
@export var rnd_idles_count = 1
@export var idle_anim_name = "Idle"
@export var move_anim_name = "Walk"

var animator : IsoCharaAnimator = null
var curr_idle_index = 1

func _ready():
	animator = $IsoCharaAnimator
	animator.setup_anims(chara_name,anim_sets,active_set)
	_i_ready()
	pass

func _i_ready():
	
	pass

func play_anim(new_anim:String,tags : Array = []):
	animator.play_anim(new_anim)
	animator.set_tags(tags)
	pass

func is_animator_tag(tags):
	return animator.is_tag(tags)

func _get_idle_anim_name():
	return idle_anim_name+str(curr_idle_index)

func _set_new_idle_anim():
	if rnd_idles_count == 1:
		curr_idle_index = 1
		return
	curr_idle_index = (randi()%rnd_idles_count) + 1
	pass
