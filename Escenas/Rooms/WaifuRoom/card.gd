extends Sprite2D


func _ready() -> void:
	Actions.leave_card.connect(_show)
	Actions.take_card.connect(_hide)
	if Gamestate.current_mision == Gamestate.mision.LAB or Gamestate.current_mision == Gamestate.mision.WAITING_ON_CELL or Gamestate.card:
		visible = false
	else:
		visible = true

func _show():
	visible = true

func _hide():
	visible = false
