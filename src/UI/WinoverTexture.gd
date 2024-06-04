extends CanvasItem

@export var npc: Globals.NPCs

func _ready():
	if not npc in Globals.won_npcs:
		modulate = Color("2d2d2d83")
