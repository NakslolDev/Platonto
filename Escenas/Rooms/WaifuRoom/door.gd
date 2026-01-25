extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Actions.door_room_visible.connect(_show)
	visible = true

func _show(b: bool):
	visible = b
