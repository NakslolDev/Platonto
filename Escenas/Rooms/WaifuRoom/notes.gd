extends Sprite2D


func _ready() -> void:
	Actions.leave_notes.connect(_show)
	if Gamestate.current_mision == Gamestate.mision.LAB:
		visible = false
	else:
		visible = true

func _show():
	visible = true
