extends HBoxContainer

@onready var dev_cards_flow_container: HFlowContainer = %DevCardsFlowContainer
@onready var card_details: VBoxContainer = %CardDetails
@onready var picture: TextureRect = %Picture
@onready var description: RichTextLabel = %Description
@onready var links_container: HFlowContainer = %LinksContainer


func _ready() -> void:
	pass # Replace with function body.


func _on_dev_cards_flow_container_child_entered_tree(node: DevCard) -> void:
	node.pressed.connect(
		func():
			picture.texture = node.dev_picture
			description.text = node.dev_description
	)
