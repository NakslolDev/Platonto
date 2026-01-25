extends Node

func func_ready():
	
	if Gamestate.current_mision == Gamestate.mision.RETURN_COFFEE_2:
		Gamestate.current_mision = Gamestate.mision.LAB
	
	if Gamestate.current_mision == Gamestate.mision.LAB: # A proposito que entre desde RETURN COFFEE
		Actions.first_lab_ff()
