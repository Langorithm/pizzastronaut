extends Node


var last_event
var last_drag_start_position: Vector2
var dragging: bool
var already_fed: bool = false
var min_drag_distance: float = 15
var drag_sent: bool = false


func _input(event):
	if event is InputEventSingleScreenDrag:
		var drag_dist = max(abs(event.relative.x), abs(event.relative.y))
		if not drag_sent and drag_dist > min_drag_distance:
			var new_input = InputEventAction.new()
			new_input.pressed = true

			if abs(event.relative.x) > abs(event.relative.y):
				if event.relative.x > 0:
					new_input.action = "move_right"
				else:
					new_input.action = "move_left"
			else:
				if event.relative.y > 0:
					new_input.action = "move_down"
				else:
					new_input.action = "move_up"
			Input.parse_input_event(new_input)
			drag_sent = true
			await get_tree().create_timer(0.2).timeout
			drag_sent = false


	elif event is InputEventSingleScreenTap:
		var new_input = InputEventAction.new()
		new_input.action = "activate"
		new_input.pressed = true
		Input.parse_input_event(new_input)
