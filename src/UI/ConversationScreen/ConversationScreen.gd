extends Control
class_name ConversationScreen

@export var npc: Globals.NPCs

@onready var player_portrait = %PlayerPortrait
@onready var npc_portrait = %NPCPortrait
@onready var animation_player = %AnimationPlayer
@onready var oxygen_bar: ProgressBar = $OxygenBar

var dialog_resource: DialogueResource

func _unhandled_input(_event):
	accept_event()


func _ready():
	appear.call_deferred()


func appear():
	Globals.active_conversation = self
	Globals.emote()
	
	var t = create_tween()
	t.tween_property(self,"modulate",Color.WHITE,0.2).from(Color.TRANSPARENT)
	animation_player.play("new_animation")
	#DialogueManager.show_example_dialogue_balloon(dialog)
	const BALLOON = preload("res://UI/DialogBox/balloon.tscn")
	var b = BALLOON.instantiate()
	add_child(b)
	b.start(dialog_resource,"start")
	DialogueManager.dialogue_ended.connect(close)


func change_texture(texture: Texture2D, player: bool):
	var portrait: TextureRect = %PlayerPortrait if player else %NPCPortrait
	portrait.texture = texture


func close(_resource = Resource.new()):
	Globals.completed_npcs[Globals.active_conversation.npc] = ""
	animation_player.play("close")
	if Globals.completed_npcs.keys().size() >= 6:
		SC.change_scene(preload("res://UI/end_screen.tscn"))
	await animation_player.animation_finished
	Globals.active_conversation = null
	get_parent().remove_child(self)
	queue_free()
