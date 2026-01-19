extends Node

func func_ready() -> void:
	if Gamestate.current_mision == Gamestate.mision.WAITING_ON_CELL:
		Gamestate.current_mision = Gamestate.mision.NONE
