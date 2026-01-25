extends Sprite2D

@export var num: int

func _ready() -> void:
	Actions.take_needle.connect(_take)
	Actions.put_needle.connect(_put)
	if Gamestate.current_mision == Gamestate.mision.FREE:
		visible = (num == 2)


func _take(n):
	if num == n:
		visible = false

func _put(n):
	if num == n:
		visible = true
