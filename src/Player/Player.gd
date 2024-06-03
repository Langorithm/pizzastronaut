extends CharacterBody2D
class_name Player

signal oxygen_level_changed(ammount_added: int, current_oxygen: int)

@export_category("Speed")
@export var max_speed: int = 400
@export var speed_levels: int = 4
@export_category("Oxygen")
@export var max_oxygen: int = 10
@export var oxygen_depleted_per_round: int = 1
@export var round_duration_secs: float = 6
@export var grace_period_secs: float = 2

const JETPACK_THRUSTER = preload("res://Sound/SFX/Jetpack_Thruster.ogg")
var randomized_thruster

var acc: float
var speed_lvl_v: int = 0
var speed_lvl_h: int = 0
var oxygen: int

@onready var oxygen_timer = $OxygenTimer
@onready var activation_area = %ActivationArea

@onready var animated_sprite_2d = %AnimatedSprite2D
@onready var smoke_vfxr = %SmokeVFXR
@onready var smoke_vfxl = %SmokeVFXL
@onready var smoke_vfxu = %SmokeVFXU
@onready var smoke_vfxd = %SmokeVFXD
@onready var emotes = %Emotes

@onready var _transition_screen = $"../Border/Transition_Layer"


func _ready():
	oxygen = max_oxygen
	add_to_group("Player", true)
	acc = float(max_speed)/float(speed_levels)
	oxygen_timer.wait_time = round_duration_secs
	
	#use a different timer to start the oxygen timer
	get_tree().create_timer(grace_period_secs).timeout.connect(oxygen_timer.start)
	
	randomized_thruster = AudioStreamRandomizer.new()
	randomized_thruster.add_stream(0,JETPACK_THRUSTER) 
	randomized_thruster.random_pitch = 1.1
	

func _physics_process(_delta):
	var new_vel =Vector2(speed_lvl_h, speed_lvl_v) * acc 
	if new_vel != velocity:
		velocity = lerp(velocity,new_vel,0.1)
	
	move_and_slide()


func increase_oxygen(o2):
	var oxygen_added:int = max(o2,0)
	oxygen += oxygen_added
	if oxygen_added:
		oxygen_level_changed.emit(oxygen_added, oxygen)
func decrease_oxygen(o2):
	var oxygen_removed:int = max(o2,0)
	oxygen -= oxygen_removed
	if oxygen_removed:
		oxygen_level_changed.emit(-oxygen_removed, oxygen)

func pass_out():
	var color_rect = _transition_screen.get_child(0)
	var t = create_tween()
	var dark_blue = Color("00172b").darkened(0.8)
	t.set_parallel(false)
	t.tween_property(color_rect, "color", dark_blue, 0.75)
	t.tween_callback(
		func():
			global_position = Vector2.ZERO
			speed_lvl_h = 0
			speed_lvl_v = 0
	)
	t.tween_property(color_rect, "color", Color.TRANSPARENT.darkened(0.8), 1.25).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)


func accelerate(step: int, is_horizontal:bool):
	if is_horizontal:
		animated_sprite_2d.flip_h = step > 0
		speed_lvl_h += step
		speed_lvl_h = clamp(speed_lvl_h, -speed_levels, speed_levels)
	else:
		speed_lvl_v += step
		speed_lvl_v = clamp(speed_lvl_v, -speed_levels, speed_levels)

func show_emote(emote_name: String = ""):
	if emote_name:
		emotes.play(emote_name)
	else:
		var current_emote = emotes.animation
		emotes.play(current_emote, -1, true)
		await emotes.animation_finished
		emotes.play("RESET")


func try_activate():
	if velocity.length() < acc:
		var buildings = activation_area.get_overlapping_areas()
		if buildings and buildings[0].has_method("activate"):
			var conversation_screen:ConversationScreen = buildings[0].activate()
			oxygen_timer.stop()
			show_emote()
			conversation_screen.tree_exiting.connect(
				func():
					await get_tree().create_timer(grace_period_secs).timeout
					oxygen_timer.start()
			)
			speed_lvl_h = 0
			speed_lvl_v = 0


func _unhandled_input(event):
	if event.is_action_pressed("move_up"):
		accelerate(-1,false)
		propel(smoke_vfxd)
	if event.is_action_pressed("move_right"):
		accelerate(+1,true)
		propel(smoke_vfxl)
	if event.is_action_pressed("move_down"):
		accelerate(+1,false)
		propel(smoke_vfxu)
	if event.is_action_pressed("move_left"):
		accelerate(-1,true)
		propel(smoke_vfxr)
	if event.is_action_pressed("activate"):
		try_activate()



func propel(thruster: AnimatedSprite2D):
	thruster.stop()
	thruster.play.call_deferred("propel")
	SM.play(randomized_thruster,SM.CH_SFX)

	
func _on_oxygen_timer_timeout():
	decrease_oxygen(oxygen_depleted_per_round)

