extends Node

signal o2_changed(delta: int, depleted: bool)

enum NPCS {VAX,COUPLE,RADIO}

var player: Player
var active_conversation: ConversationScreen


func _ready():
	var fetch_p = func():
		player = get_tree().get_first_node_in_group("Player")
	fetch_p.call_deferred()

func increase_oxygen(o2):
	if player:
		player.increase_oxygen(o2)	
func decrease_oxygen(o2):
	if player:
		player.decrease_oxygen(o2)


func win_over():
	pass


func emote(emotion: String):
	pass
