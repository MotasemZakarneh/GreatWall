extends TopDownISO
class_name IsoCharaAnimator

#"""
#This Script does not effect the parent.
#instead it looks for an AnimatedSprite in the siblings.
#call the public functions, the ones that, do not start with _
#
#Note: Leave the active_anim_set (CharaAnimData) to empty so it palys defaults.
#
#Note 2: _anims_sets is an array of resources Files, that is of type: CharaAnimSet
#
#Note 3: SpriteSheets are the only thing supported now.
#
#Note 4: SpriteSheets must be named in this Pattern
#
#CharaName_AnimSet_AnimName.extention
#for example:
#MC_Sword_Walk is an animation Sprite Sheet for the character MC
#with the Set of Sword, (example sword walk, sword run, sword attack)
#and at the end is the animation name, this one is Walk.
#
#Note 5: SpriteSheets, Must Contain All Needed Directions Of A Single Animation
#The Directions For All SpriteSheets must be ordered the same as the const Array
#
#"""

@export var start_debug = false
@export var make_one_min_val = 0.5

var v_dir = Vector2()
var active_anim = ""
var active_tags = []
var sprite : AnimatedSprite2D
var dir = ""
var active_anim_set = ""
var anims_sets = []
var chara_name = ""
var active_anim_full_name = ""

const directions = {
	Vector2.RIGHT : "Right",Vector2.LEFT:"Left",Vector2.UP:"Up",Vector2.DOWN:"Down",
	Vector2.ONE :"BotRight",Vector2(-1,1):"BotLeft",
	-Vector2.ONE:"TopLeft",Vector2(1,-1):"TopRight"
}

func _ready():
	sprite = get_parent().get_node("AnimatedSprite")
	pass

#Must be called at the moment the character spawns, so we build the animations
func setup_anims(_chara_name:String,_anims_sets:Array,start_set:String = "",start_dir:Vector2 = Vector2.DOWN):
	if(_anims_sets.size() == 0):
		print("Anim Sets Size can not be zero, recall this function, with proper _anim_sets")
	self.chara_name = _chara_name
	self.anims_sets = _anims_sets
	
	var s : SpriteFrames = Extentions.get_sprite_frames_all(anims_sets)
	sprite.frames = s
	set_active_anim_set(start_set)
	update_dir(start_dir)
	if start_debug:
		print("Created Animations Of Names :: " + str(s.get_animation_names()))
	pass

#Changes, the active animations Set
func set_active_anim_set(new_set:String):
	active_anim_set = new_set
	pass

#Tries To Play An Animation
func play_anim(anim:String):
	active_anim = anim
	var anim_set = "_"
	if not active_anim_set.empty():
		anim_set = "_" + active_anim_set +"_"
	
	var anim_name = chara_name + anim_set + active_anim + "_" + dir
	if sprite.animation == anim_name:
		return 
	if not sprite.frames.has_animation(anim_name):
		print(anim_name + " Is Not Defined " + get_parent().name)
		print(sprite.frames.get_animation_names())
		return
	sprite.play(anim_name)
	active_anim_full_name = anim_name
	pass

#Facing Direction, Must Be Continiously Updated
func update_dir(new_v_dir:Vector2):
	v_dir = new_v_dir
	v_dir = Extentions.make_one_w_min(v_dir,make_one_min_val)
	
	if v_dir == Vector2.ZERO:
		v_dir = Vector2(0,1)
		v_dir = Extentions.make_one_w_min(v_dir,make_one_min_val)
	
	var new_dir = directions[v_dir]
	if new_dir != self.dir:
		self.dir = new_dir
		if active_anim == "":
			return
		play_anim(active_anim)
	pass

func set_tags(_tags:Array):
	active_tags = _tags
	pass

func is_tag(tags):
	if tags is Array:
		for test_tag in tags:
			for t in active_tags:
				if t == test_tag:
					return true
	for t in active_tags:
		if t == tags:
			return true
	return false
