extends Sprite2D


func _ready() -> void:
	Actions.leave_notes.connect(_show)
	if Gamestate.current_mision == Gamestate.mision.LAB or Gamestate.current_mision == Gamestate.mision.WAITING_ON_CELL:
		visible = false
	else:
		visible = true

func _show():
	visible = true
