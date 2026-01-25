extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Actions.fall_cup.connect(_play)
	visible = false

func _play(player_pos: Vector2):
	position = player_pos
	position.y -= 2
	visible = true
	var tween := get_tree().create_tween()
	var position_end := position.x + 50
	tween.tween_property(self, "position:x", position_end, 0.5)
	position_end = position.x + 80
	tween.tween_property(self, "position:x", position_end, 0.4)
	position_end = position.x + 90
	tween.tween_property(self, "position:x", position_end, 0.3)
