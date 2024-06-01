extends CharacterBody2D
class_name Player

@export var max_speed: int = 400
@export var speed_levels: int = 4

var acc: float
var speed_lvl_v: int = 0
var speed_lvl_h: int = 0

@onready var activation_area = %ActivationArea


func _ready():
	add_to_group("Player", true)
	acc = max_speed/speed_levels
	

func _physics_process(delta):
	var new_vel =Vector2(speed_lvl_h, speed_lvl_v) * acc 
	if new_vel != velocity:
		velocity = lerp(velocity,new_vel,0.1)
	
	move_and_slide()


func accelerate(step: int, is_horizontal:bool):
	if is_horizontal:
		speed_lvl_h += step
		speed_lvl_h = clamp(speed_lvl_h, -speed_levels, speed_levels)
	else:
		speed_lvl_v += step
		speed_lvl_v = clamp(speed_lvl_v, -speed_levels, speed_levels)


func try_activate():
	if velocity.length() < acc:
		var buildings = activation_area.get_overlapping_areas()
		if buildings and buildings[0].has_method("activate"):
			buildings[0].activate()
			create_tween().tween_property(self,"velocity",Vector2.ZERO,0.15)
			

func _unhandled_input(event):
	if event.is_action_pressed("move_up"):
		accelerate(-1,false)
	if event.is_action_pressed("move_right"):
		accelerate(+1,true)
	if event.is_action_pressed("move_down"):
		accelerate(+1,false)
	if event.is_action_pressed("move_left"):
		accelerate(-1,true)
	if event.is_action_pressed("activate"):
		try_activate()
	
