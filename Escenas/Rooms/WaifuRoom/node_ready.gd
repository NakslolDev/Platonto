extends Node

func _ready() -> void:
	if Gamestate.current_mision == Gamestate.mision.LAB: return
	if Gamestate.current_mision == Gamestate.mision.WAITING_ON_CELL:
		sync_all()
		return
	Actions.play_animation.emit(Actions.char.Player, "idle_right")

func func_ready():
	
	if Gamestate.current_mision == Gamestate.mision.LAB or Gamestate.current_mision == Gamestate.mision.WAITING_ON_CELL:
		Actions.room_ff()
		Gamestate.current_mision = Gamestate.mision.FREE
		Gamestate.open_doors.append("waifu_door")
		Gamestate.open_doors.erase("door_lab")
		return
	
	while Input.get_vector("A", "D", "W", "S") == Vector2.ZERO:
		await get_tree().process_frame
	
	Actions.play_animation.emit(Actions.char.Player, "stop")

func sync_all():
	
	Actions.instant_blackout.emit()
	
	Actions.load_character.emit(Actions.char.Waifu, "Waifu", "idle_front")
	
	Actions.change_outfit.emit("b")
	
	var main = get_tree().current_scene
	
	main.off_scene_characters.erase(3)
	
	if not main.off_scene_characters.has(2):
		main.off_scene_characters[2] = {}
	main.off_scene_characters[2]["scene"] = "Cafe"
	main.off_scene_characters[2]["position"] = "ScientistCafe"
	main.off_scene_characters[2]["animation"] = &"coffee" # idle drinking coffee
	
	if not main.off_scene_characters.has(4):
		main.off_scene_characters[4] = {}
	main.off_scene_characters[4]["scene"] = "Cafe"
	main.off_scene_characters[4]["position"] = "GuardExit" 
	main.off_scene_characters[4]["animation"] = &"idle_back"
	
	if not main.off_scene_characters.has(5):
		main.off_scene_characters[5] = {}
	main.off_scene_characters[5]["scene"] = "Exit"
	main.off_scene_characters[5]["position"] = "GuardControl"
	main.off_scene_characters[5]["animation"] = &"idle_left"
	
	Gamestate.open_doors = ["prison_door", "door_black_room"]
	Gamestate.open_cells = [2,3]
	
	if not main.off_scene_characters.has(6):
		main.off_scene_characters[6] = {}
	main.off_scene_characters[6]["scene"] = "Prison"
	main.off_scene_characters[6]["position"] = "Vegetal"
	main.off_scene_characters[6]["animation"] = &"idle_back"
	
	if not main.off_scene_characters.has(7):
		main.off_scene_characters[7] = {}
	main.off_scene_characters[7]["scene"] = "Prison"
	main.off_scene_characters[7]["position"] = "Prisoner1"
	main.off_scene_characters[7]["animation"] = &"idle_front"
	
	if not main.off_scene_characters.has(8):
		main.off_scene_characters[8] = {}
	main.off_scene_characters[8]["scene"] = "Prison"
	main.off_scene_characters[8]["position"] = "Prisoner2"
	main.off_scene_characters[8]["animation"] = &"idle_front"
	
	if not main.off_scene_characters.has(9):
		main.off_scene_characters[9] = {}
	main.off_scene_characters[9]["scene"] = "Prison"
	main.off_scene_characters[9]["position"] = "Prisoner3"
	main.off_scene_characters[9]["animation"] = &"idle_back"
	
	if not main.off_scene_characters.has(10):
		main.off_scene_characters[10] = {}
	main.off_scene_characters[10]["scene"] = "Prison"
	main.off_scene_characters[10]["position"] = "Prisoner4"
	main.off_scene_characters[10]["animation"] = &"spin"
