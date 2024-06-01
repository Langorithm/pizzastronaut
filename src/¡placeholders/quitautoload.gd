extends Node

func _input(event):
	if event.as_text() == "Q":
		get_tree().quit()
