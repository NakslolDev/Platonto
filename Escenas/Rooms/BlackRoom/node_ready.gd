extends Node

@export var second := true
@export var door: Node2D

func func_ready() -> void:
	
	if Gamestate.current_mision == Gamestate.mision.WAITING_ON_CELL:
		if second:
			Gamestate.current_mision = Gamestate.mision.BLACKROOM_2
			Actions.change_outfit.emit("b")
			Gamestate.normal_ropes = true
		else:
			Gamestate.current_mision = Gamestate.mision.BLACKROOM_1
		sync_all()
		Gamestate.finished_blackroom = true
		door.open_door()
	
	if Gamestate.current_mision == Gamestate.mision.FOLLOW_SCIENTIST:
		Gamestate.current_mision = Gamestate.mision.BLACKROOM_1
		sync_all()
	
	if Gamestate.current_mision == Gamestate.mision.BLACKROOM_2:
		Gamestate.entered_black_room_second_time = true
		sync_all() # porsia

func new_char_state():
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

func sync_all():
	new_char_state()
	
	var main = get_tree().current_scene
	
	if not main.off_scene_characters.has(1):
		main.off_scene_characters[1] = {}
	main.off_scene_characters[1]["scene"] = "MainHall"
	main.off_scene_characters[1]["position"] = Vector2(8.0, -167.833)
	main.off_scene_characters[1]["animation"] = &"notes"
	
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
