extends Control
class_name ConversationScreen

@export var npc_texture: Texture2D

@onready var player_portrait = %PlayerPortrait
@onready var npc_portrait = %NPCPortrait
@onready var animation_player = %AnimationPlayer


func _unhandled_input(event):
	accept_event()


func appear():
	assert(npc_texture, "NPC texture missing")
	npc_portrait.texture = npc_texture
	
	var t = create_tween()
	t.tween_property(self,"modulate",Color.WHITE,0.2).from(Color.TRANSPARENT)
	animation_player.play("new_animation")


func _on_button_2_button_down():
	get_parent().remove_child(self)
	queue_free()
