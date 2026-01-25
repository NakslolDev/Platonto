extends Control

@export var cubes: Array[Sprite2D]

var exiting := false
var exit_index := 0
@export var exit_delay := 0.5 
var exit_elapsed := 0.0

func _process(delta):
	if Input.is_action_pressed("esc"):
		process_exit(delta)
		if Actions.animated_characters != []:
			stop_exit()
	else:
		stop_exit()


func process_exit(delta):
	if not exiting:
		exiting = true
		exit_index = 0
		exit_elapsed = 0.0
	
	exit_elapsed += delta
	
	if exit_elapsed < exit_delay:
		return
	
	exit_elapsed = 0.0
	
	if exit_index >= cubes.size():
		get_tree().change_scene_to_file("res://Escenas/MainMenu/main_menu.tscn")
		return
	
	cubes[exit_index].visible = true
	exit_index += 1


func stop_exit():
	if not exiting:
		return

	exiting = false
	exit_elapsed = 0.0
	exit_index = 0

	for i in cubes:
		i.visible = false
