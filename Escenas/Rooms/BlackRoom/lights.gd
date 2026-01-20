extends Node2D

@export var sound_high: AudioStreamPlayer
@export var sound_low: AudioStreamPlayer

@export var door: Node2D

var on := 0

var gen_wait_time := 1.0

signal check

func _ready() -> void:
	
	for child in get_children():
		if not child is Area2D: continue
		child.visible = false
	
	Actions.start_test_1.connect(_start_test_1)


func _start_test_1():
	
	await get_tree().create_timer(2.0).timeout
	
	for i in range(1,4):
		light_up(i)
		await check
		if check_in(i):
			Actions.punish_player()
			await Actions.punish_end
		await get_tree().create_timer(randf_range(1.5,3.5)).timeout
	
	Actions.explain_yellow_mellow_ff()
	await Actions.continue_test
	
	light_up(4)
	await check
	if not check_in(4):
		Actions.punish_player()
		await Actions.punish_end
	await get_tree().create_timer(randf_range(1.5,3.5)).timeout
	
	light_up(5)
	await check
	if not check_in(5):
		Actions.punish_player()
		await Actions.punish_end
	
	light_up(5)
	bait(6, false, true)
	await check
	if check_in(5):
		Actions.punish_player()
		await Actions.punish_end
	await get_tree().create_timer(randf_range(1.5,3.5)).timeout
	
	light_up(7, false)
	light_up(8, false)
	light_up(9)
	await check
	if not check_in(9):
		Actions.punish_player()
		await Actions.punish_end
	await get_tree().create_timer(randf_range(1.5,3.5)).timeout
	
	light_up(10)
	bait(11, false, false)
	await check
	if check_in(10):
		Actions.punish_player()
		await Actions.punish_end
	await get_tree().create_timer(randf_range(1.5,3.5)).timeout
	
	light_up(12)
	door.open_door()


func light_up(number: int, main := true):
	
	var area = find_child(str(number))
	
	area.visible = true
	
	for i in 3:
		if main: sound_low.play()
		await get_tree().create_timer(gen_wait_time).timeout
	if main: sound_high.play()
	await get_tree().create_timer(gen_wait_time).timeout
	
	if main: check.emit()
	area.visible = false

func bait(number: int, main := true, full := false):
	
	var area = find_child(str(number))
	
	area.visible = true
	
	if full:
		for i in 4:
			if main: sound_low.play()
			await get_tree().create_timer(gen_wait_time).timeout
	else:
		for i in 2:
			if main: sound_low.play()
			await get_tree().create_timer(gen_wait_time).timeout
	
	area.visible = false

func check_in(number: int) -> bool:
	return number == on
