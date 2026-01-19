extends Node

func func_ready() -> void:
	
	if Gamestate.current_mision == Gamestate.mision.WAITING_ON_CELL:
		Gamestate.current_mision = Gamestate.mision.BLACKROOM_1
		sync_all()
	
	if Gamestate.current_mision == Gamestate.mision.FOLLOW_SCIENTIST:
		Gamestate.current_mision = Gamestate.mision.BLACKROOM_1
		new_char_state()

func new_char_state():
	var main = get_tree().current_scene
	
	main.off_scene_characters.erase(2)
	
	if not main.off_scene_characters.has(3):
		main.off_scene_characters[3] = {}
	main.off_scene_characters[3]["scene"] = "Cafe"
	main.off_scene_characters[3]["position"] = "ScientistCafe"
	main.off_scene_characters[3]["animation"] = &"spin"

func sync_all():
	new_char_state()
	
	var main = get_tree().current_scene
	
	if not main.off_scene_characters.has(1):
		main.off_scene_characters[1] = {}
	main.off_scene_characters[1]["scene"] = "MainHall"
	main.off_scene_characters[1]["position"] = Vector2(8.0, -167.833)
	main.off_scene_characters[1]["animation"] = &"idle_back"
	
	Gamestate.open_doors = ["prison_door", "door_black_room"]
