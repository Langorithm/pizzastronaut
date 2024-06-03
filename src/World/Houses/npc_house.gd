extends Area2D
class_name NPCHouse

const CONVERSATION_SCREEN = preload("res://UI/ConversationScreen/ConversationScreen.tscn")

@export var npc: Globals.NPCs
@export var conversation: DialogueResource
@onready var sprite_2d:Sprite2D = $Sprite2D



func activate() -> ConversationScreen:
	var ui_layer: CanvasLayer = get_tree().get_first_node_in_group("UI_Layer")
	var conversation_screen: ConversationScreen = CONVERSATION_SCREEN.instantiate()
	ui_layer.add_child(conversation_screen)
	conversation_screen.npc = npc
	conversation_screen.dialog_resource = conversation
	conversation_screen.appear()

	conversation_screen.tree_exiting.connect(
		func():
			set_collision_layer_value(2, false)
			(material as ShaderMaterial).set_shader_parameter("active", true)
			(get_overlapping_bodies()[0] as Player).show_emote()
			monitoring = false
	)
	
	return conversation_screen


func _on_body_entered(body):
	(body as Player).show_emote("exclamation")

func _on_body_exited(body):
	body.show_emote()
