extends Node2D

@export var number: int
var opened := false

@export var gate: Node2D 

func _ready() -> void:
	Actions.open_gate.connect(open)
	if Gamestate.open_cells.has(number):
		Gamestate.open_cells.erase(number)
		open(number)


func open(num: int):
	if num != 0 and num != number or opened:
		return
	
	opened = true
	
	var tween := get_tree().create_tween()
	var position_end := gate.position.x - 16
	tween.tween_property(gate, "position:x", position_end, 1.0)
	
	Gamestate.open_cells.append(number)
