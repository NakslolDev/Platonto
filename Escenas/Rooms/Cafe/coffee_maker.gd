extends Node2D

@export var texture_no_cup: Sprite2D
@export var texture_cup: Sprite2D

func _ready():
	_switch_coffee(false)
	Actions.coffee_cup.connect(_switch_coffee)

func _switch_coffee(on: bool):
	texture_no_cup.visible = !on
	texture_cup.visible = on
