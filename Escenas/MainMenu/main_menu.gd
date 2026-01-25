extends Control


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	restart()

func restart():
	Gamestate.current_mision = Gamestate.mision.WAITING_ON_CELL
	Gamestate.waifudebugin = false
	Gamestate.wait_before_trans = false
	Gamestate.card = false
	Gamestate.open_doors = []
	Gamestate.open_cells = []
	Gamestate.cup = false
	Gamestate.finished_blackroom = false
	Gamestate.in_cup = []
	Gamestate.waifu_in_center_of_lab = false
	Gamestate.entered_black_room_second_time = false
	
	Actions.animated_characters = []
	Actions.lock_cam = false
	Actions.displace_cam = Vector2.ZERO
	Actions.static_cam = Vector2.ZERO

func _on_play_pressed() -> void:
	Gamestate.start_in_middle = false
	get_tree().change_scene_to_file("res://Escenas/main/main.tscn")

func _on_play_middle_pressed() -> void:
	Gamestate.start_in_middle = true
	get_tree().change_scene_to_file("res://Escenas/main/main.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
