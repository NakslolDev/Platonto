extends Node2D

@export var texture_no_cup: Sprite2D
@export var texture_cup: Sprite2D
@export var texture_coming: Sprite2D

func _ready():
	_switch_coffee(false)
	Actions.coffee_cup.connect(_switch_coffee)

func _switch_coffee(on: bool, coffee := false):
	texture_no_cup.visible = !on
	texture_cup.visible = on
	texture_coming.visible = false
	
	if coffee:
		await get_tree().create_timer(1.0).timeout
		texture_coming.visible = true
		await get_tree().create_timer(3.0).timeout
		texture_coming.visible = false
