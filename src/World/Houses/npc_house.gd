extends Area2D
class_name NPCHouse

const CONVERSATION_SCREEN = preload("res://UI/ConversationScreen/ConversationScreen.tscn")

@export var npc_texture: Texture2D
@onready var sprite_2d:Sprite2D = $Sprite2D


func activate():
	
	var ui_layer: CanvasLayer = get_tree().get_first_node_in_group("UI_Layer")
	var conversation_screen: ConversationScreen = CONVERSATION_SCREEN.instantiate()
	ui_layer.add_child(conversation_screen)
	conversation_screen.npc_texture = npc_texture
	conversation_screen.appear()
