extends HSlider


var idx: int = -1

func _ready() -> void:
	var r = RegEx.new()
	r.compile("\\[(\\w+)\\]")
	var search = r.search(name)
	var slider_channel_name = search.get_string(1)
	assert(search, "Invalid slider name, could not find bus")
	idx = AudioServer.get_bus_index(slider_channel_name)

	value_changed.connect(apply_value_to_volume)

	apply_value_to_volume()


func apply_value_to_volume() -> void:
	AudioServer.set_bus_volume_db(idx,linear_to_db(value))

