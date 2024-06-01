extends Label

func _ready() -> void:
	modulate = Color.TRANSPARENT


func _input(event: InputEvent) -> void:
	if modulate != Color.WHITE:
		var t = create_tween()
		t.tween_property(self, "modulate",Color.WHITE,1.2)
		t.tween_interval(5)
		t.tween_property(self, "modulate",Color.TRANSPARENT,0.7)
