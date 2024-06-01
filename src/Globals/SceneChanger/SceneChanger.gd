extends Node

const TRANSITION_LAYER = preload("res://Globals/SceneChanger/Transition_Layer.tscn")

var _transition_screen: ColorRect

func _ready() -> void:
	var layer = TRANSITION_LAYER.instantiate()
	add_child(layer)
	_transition_screen = layer.get_child(0)
	#var top_layer = CanvasLayer.new()
	#add_child(top_layer)
	#top_layer.layer = 100
#
	#_transition_screen = ColorRect.new()
	#top_layer.add_child(_transition_screen )
	#_transition_screen .color = Color.TRANSPARENT
	#_transition_screen .set_anchors_preset(Control.PRESET_FULL_RECT)

func change_scene(scene: PackedScene) -> void:
	var tree = get_tree()
	var t = create_tween()
	t.set_parallel(false)
	t.tween_property(_transition_screen , "color", Color.BLACK, 0.75)
	t.tween_callback(tree.change_scene_to_packed.bind(scene))
	t.tween_property(_transition_screen , "color", Color.TRANSPARENT.darkened(1), 1.25)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
