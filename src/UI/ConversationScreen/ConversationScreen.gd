extends Control
class_name ConversationScreen

@export var npc_texture: Texture2D
@export var npc: Globals.NPCS

@onready var player_portrait = %PlayerPortrait
@onready var npc_portrait = %NPCPortrait
@onready var animation_player = %AnimationPlayer

var dialog_resource: DialogueResource


func _unhandled_input(event):
	accept_event()


func _ready():
	appear.call_deferred()


func appear():
	assert(npc_texture, "NPC texture missing")
	npc_portrait.texture = npc_texture
	
	Globals.active_conversation = self
	
	var t = create_tween()
	t.tween_property(self,"modulate",Color.WHITE,0.2).from(Color.TRANSPARENT)
	animation_player.play("new_animation")
	#DialogueManager.show_example_dialogue_balloon(dialog)
	const BALLOON = preload("res://UI/DialogBox/balloon.tscn")
	var b = BALLOON.instantiate()
	add_child(b)
	b.start(dialog_resource,"start")
	DialogueManager.dialogue_ended.connect(close)


func _on_button_2_button_down():
	#close()
	pass


func close(_resource):
	animation_player.play("close")
	await animation_player.animation_finished
	Globals.active_conversation = null
	get_parent().remove_child(self)
	queue_free()
