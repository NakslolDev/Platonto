extends Node

@export var second := true

func func_ready() -> void:
	
	if Gamestate.current_mision == Gamestate.mision.WAITING_ON_CELL:
		if second:
			Gamestate.current_mision = Gamestate.mision.BLACKROOM_2
			Actions.change_outfit.emit("b")
		else:
			Gamestate.current_mision = Gamestate.mision.BLACKROOM_1
		sync_all()
		Gamestate.finished_blackroom = true
		$"../BottomDoor".open_door()
	
	if Gamestate.current_mision == Gamestate.mision.FOLLOW_SCIENTIST:
		Gamestate.current_mision = Gamestate.mision.BLACKROOM_1
		new_char_state()
	
	if Gamestate.current_mision == Gamestate.mision.BLACKROOM_2:
		new_char_state() # porsia

func new_char_state():
	var main = get_tree().current_scene
	
	main.off_scene_characters.erase(3)
	
	if not main.off_scene_characters.has(2):
		main.off_scene_characters[2] = {}
	main.off_scene_characters[2]["scene"] = "Cafe"
	main.off_scene_characters[2]["position"] = "ScientistCafe"
	main.off_scene_characters[2]["animation"] = &"spin" # idle drinking coffee
	
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
	main.off_scene_characters[1]["animation"] = &"spin" #
	
	Gamestate.open_doors = ["prison_door", "door_black_room"]
	Gamestate.open_cells = [2,3]
