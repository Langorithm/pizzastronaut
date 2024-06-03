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


func _ready():
	oxygen = max_oxygen
	add_to_group("Player", true)
	acc = max_speed/speed_levels
	oxygen_timer.wait_time = round_duration_secs
	
	#use a different timer to start the oxygen timer
	get_tree().create_timer(grace_period_secs).timeout.connect(oxygen_timer.start)
	

func _physics_process(delta):
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


func accelerate(step: int, is_horizontal:bool):
	if is_horizontal:
		animated_sprite_2d.flip_h = step > 0
		speed_lvl_h += step
		speed_lvl_h = clamp(speed_lvl_h, -speed_levels, speed_levels)
	else:
		speed_lvl_v += step
		speed_lvl_v = clamp(speed_lvl_v, -speed_levels, speed_levels)


func try_activate():
	if velocity.length() < acc:
		var buildings = activation_area.get_overlapping_areas()
		if buildings and buildings[0].has_method("activate"):
			var conversation_screen:ConversationScreen = buildings[0].activate()
			oxygen_timer.stop()
			conversation_screen.tree_exiting.connect(
				func():
					await get_tree().create_timer(grace_period_secs)
					oxygen_timer.start()
			)
			speed_lvl_h = 0
			speed_lvl_v = 0


func _unhandled_input(event):
	if event.is_action_pressed("move_up"):
		accelerate(-1,false)
		smoke_vfxd.play("propel")
	if event.is_action_pressed("move_right"):
		accelerate(+1,true)
		smoke_vfxl.play("propel")
	if event.is_action_pressed("move_down"):
		accelerate(+1,false)
		smoke_vfxu.play("propel")
	if event.is_action_pressed("move_left"):
		accelerate(-1,true)
		smoke_vfxr.play("propel")
	if event.is_action_pressed("activate"):
		try_activate()
	


func _on_oxygen_timer_timeout():
	decrease_oxygen(oxygen_depleted_per_round)
