extends ProgressBar

@export var increased_color: Color = Color.GREEN
@export var decreased_color: Color = Color.RED

var player_max
var oxygen_color

func _ready():
	oxygen_color = modulate
	var fetch_player = func():
		var p:Player = get_tree().get_first_node_in_group("Player") as Player
		value = p.oxygen
		#player_max = p.max_oxygen
		max_value = p.max_oxygen
		p.oxygen_level_changed.connect(update_value)
	fetch_player.call_deferred()


func update_value(ammount_changed, new_value):
	var color = increased_color if ammount_changed > 0 else decreased_color 
	var percentage = new_value/100
	
	var t = create_tween()
	t.set_parallel(true)
	t.tween_property(self,"modulate",color,0.5)
	t.tween_property(self,"value",new_value,0.5
		).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	t.set_parallel(false)
	t.tween_property(self,"modulate",oxygen_color,0.7).from(color).set_ease(Tween.EASE_IN)
	
	
