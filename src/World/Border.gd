extends Area2D




func _on_body_exited(body):
	(body as Player).pass_out()
