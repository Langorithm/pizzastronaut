extends Control
class_name DevCard

signal pressed

@export var dev_name : String
@export_multiline var dev_description : String
@export var dev_picture: Texture2D


@onready var name_label: Label = %NameLabel
@onready var picture_texture: TextureRect = %PictureTexture



func _ready() -> void:
	if dev_picture:
		picture_texture.texture = dev_picture
	name_label.text = dev_name


func _on_button_pressed() -> void:
	pressed.emit()
