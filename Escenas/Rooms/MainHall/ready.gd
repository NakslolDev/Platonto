extends Node


func func_ready() -> void:
	
	if Gamestate.current_mision == Gamestate.mision.WAITING_ON_CELL:
		Gamestate.current_mision = Gamestate.mision.NONE
	
	if Gamestate.current_mision == Gamestate.mision.FOLLOW_SCIENTIST:
		Actions.enter_black_room_first_ff()
	
	if Gamestate.current_mision == Gamestate.mision.BLACKROOM_1:
		Actions.close_door.emit("door_black_room")
		Gamestate.current_mision = Gamestate.mision.GO_GET_COFEE_1
		Actions.exit_black_room_first_ff()
	
	if Gamestate.current_mision == Gamestate.mision.BLACKROOM_2:
		Actions.close_door.emit("door_black_room")
		Gamestate.current_mision = Gamestate.mision.GO_GET_COFEE_2
