extends Node

func _ready() -> void:
	if Gamestate.current_mision == Gamestate.mision.LAB: return
	
	Actions.play_animation.emit(Actions.char.Player, "idle_right")

func func_ready():
	
	if Gamestate.current_mision == Gamestate.mision.LAB:
		Actions.room_ff()
		Gamestate.current_mision = Gamestate.mision.FREE
		Gamestate.open_doors.append("waifu_door")
		Gamestate.open_doors.erase("door_lab")
		return
	
	while Input.get_vector("A", "D", "W", "S") == Vector2.ZERO:
		await get_tree().process_frame
	
	Actions.play_animation.emit(Actions.char.Player, "stop")
