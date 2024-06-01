extends Node

signal o2_changed(delta: int, depleted: bool)

var _o2: int = 10

func get_o2():
	return _o2
	
func add_o2(o2):
	var delta = min(0,o2) 
	_o2 += delta
	o2_changed.emit(delta,false)
	
func subtract_o2(o2):
	var delta = max(0,o2)
	_o2 += delta
	o2_changed.emit(delta,_o2<0)
	
