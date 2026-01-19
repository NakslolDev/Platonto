extends Node2D

@export var identifier: String

@export var left: Node
@export var right: Node

var open: bool
var player_in: bool

@export var auto_open := false
@export var require_card := false


func _ready():
	Actions.open_door.connect(_open_door)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name.begins_with("Player") and auto_open:
		if require_card and not Gamestate.card: return
		open_door()
		player_in = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name.begins_with("Player") and auto_open:
		if require_card and not Gamestate.card: return
		close_door()
		player_in = false


func _open_door(id: String):
	if id == identifier:
		open_door()


func open_door():
	while open:
		await get_tree().process_frame # esto es guarro, pero no tengo tiempo para pulirlo
	open_right()
	open_left()
	await get_tree().create_timer(0.5).timeout
	open = true

func open_right():
	var tween := get_tree().create_tween()
	var position_end: float = right.position.x + 16
	tween.tween_property(right, "position:x", position_end, 0.5)

func open_left():
	var tween := get_tree().create_tween()
	var position_end: float = left.position.x - 16
	tween.tween_property(left, "position:x", position_end, 0.5)

func close_door():
	while not open:
		await get_tree().process_frame # esto es guarro, pero no tengo tiempo para pulirlo
	close_right()
	close_left()
	await get_tree().create_timer(0.5).timeout
	open = false

func close_right():
	var tween := get_tree().create_tween()
	var position_end: float = right.position.x - 16
	tween.tween_property(right, "position:x", position_end, 0.5)

func close_left():
	var tween := get_tree().create_tween()
	var position_end: float = left.position.x + 16
	tween.tween_property(left, "position:x", position_end, 0.5)
