extends Node2D

@export var left: Node
@export var right: Node

@export var weird_wall: Sprite2D

func _ready(): 
	close_door()

func open_door():
	open_right()
	open_left()
	
	var tween := get_tree().create_tween()
	tween.tween_property(weird_wall, "scale:x", 2.0, 0.15)

func open_right():
	var tween := get_tree().create_tween()
	var position_end: float = right.position.x + 16
	tween.tween_property(right, "position:x", position_end, 0.15)

func open_left():
	var tween := get_tree().create_tween()
	var position_end: float = left.position.x - 16
	tween.tween_property(left, "position:x", position_end, 0.15)

func close_door():
	close_right()
	close_left()
	
	var tween := get_tree().create_tween()
	tween.tween_property(weird_wall, "scale:x", 0.0, 0.15)

func close_right():
	var tween := get_tree().create_tween()
	var position_end: float = right.position.x - 16
	tween.tween_property(right, "position:x", position_end, 0.15)

func close_left():
	var tween := get_tree().create_tween()
	var position_end: float = left.position.x + 16
	tween.tween_property(left, "position:x", position_end, 0.15)
