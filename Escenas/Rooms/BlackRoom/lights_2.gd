extends Node2D

@export var sound_high: AudioStreamPlayer
@export var sound_low: AudioStreamPlayer

@export var door: Node2D

var on: Array[int]

var gen_wait_time := 1.0

signal check
signal check_color

func _ready() -> void:
	
	for child in get_children():
		if not child is Area2D: continue
		child.visible = false
	
	Actions.start_test_2.connect(_start_test_2)


func _start_test_2():
	
	await get_tree().create_timer(2.0).timeout
	
	gen_wait_time = 0.75
	
	light_up(1)
	await check
	if check_in(1):
		Actions.punish_player()
		await Actions.punish_end
	await get_tree().create_timer(randf_range(0.5,1.5)).timeout
	
	light_up(2)
	await check
	if not check_in(2):
		Actions.punish_player()
		await Actions.punish_end
	await get_tree().create_timer(randf_range(0.5,1.5)).timeout
	
	_move_3()
	
	light_up(3)
	await check
	if not check_in(3):
		Actions.punish_player()
		await Actions.punish_end
	await get_tree().create_timer(randf_range(0.5,1.5)).timeout
	
	_move_456()
	
	light_up(4, false)
	light_up(5, false)
	light_up(6)
	await check
	if not check_in(6):
		Actions.punish_player()
		await Actions.punish_end
	await get_tree().create_timer(randf_range(0.5,1.5)).timeout
	
	_move_7()
	
	light_up(7)
	await check
	if not check_in(7):
		Actions.punish_player()
		await Actions.punish_end
	await get_tree().create_timer(randf_range(1.5,2.5)).timeout
	
	light_up(8)
	light_up(10, false, 1)
	light_up(9, false, 2)
	await check
	if not check_in(8):
		Actions.punish_player()
		await Actions.punish_end
	await get_tree().create_timer(randf_range(1.5,2.5)).timeout
	
	light_up(11, true, 2)
	await get_tree().create_timer(randf_range(2.0,2.5)).timeout
	
	light_up(12, true, 1)
	await get_tree().create_timer(randf_range(2.0,2.5)).timeout
	
	light_up(13, true, 1)
	await get_tree().create_timer(randf_range(2.0,2.5)).timeout
	
	gen_wait_time = 1.5
	light_up(14)
	await check
	if not check_in(14):
		Actions.punish_player()
		await Actions.punish_end
	await get_tree().create_timer(1.5).timeout
	
	gen_wait_time = 0.5
	
	light_up(15)
	await check
	if check_in(15):
		Actions.punish_player()
		await Actions.punish_end
	await get_tree().create_timer(0.5).timeout
	
	light_up(16)
	await check
	if not check_in(16):
		Actions.punish_player()
		await Actions.punish_end
	await get_tree().create_timer(0.5).timeout
	
	light_up(17)
	await check
	if not check_in(17):
		Actions.punish_player()
		await Actions.punish_end
	await get_tree().create_timer(0.5).timeout
	
	gen_wait_time = 0.75
	
	light_up(18)
	await check
	if not check_in(18):
		Actions.punish_player()
		await Actions.punish_end
	await get_tree().create_timer(1.0).timeout
	
	light_up(29)
	light_up(30)
	await check
	if not (check_in(29) and check_in(30)):
		Actions.punish_player()
		await Actions.punish_end
	await get_tree().create_timer(1.0).timeout
	
	
	gen_wait_time = 1.25
	
	light_up(19, false)
	light_up(20, false)
	light_up(21, false)
	light_up(22, false)
	light_up(23)
	await check
	if not (check_in(19) and check_in(20) and check_in(21) and check_in(22) and check_in(23)):
		Actions.punish_player()
		await Actions.punish_end
	await get_tree().create_timer(1.0).timeout
	
	gen_wait_time = 1.5
	
	_move_2_4567()
	light_up(24, false)
	light_up(25, false)
	light_up(26, false)
	light_up(27, false)
	light_up(28)
	await check
	if not (check_in(24) and check_in(25) and check_in(26) and check_in(27) and check_in(28)):
		Actions.punish_player()
		await Actions.punish_end
	await get_tree().create_timer(1.0).timeout
	
	Actions.exit_test_2_ff()
	await Actions.continue_test
	
	Gamestate.finished_blackroom = true
	door.open_door()

func light_up(number: int, main := true, disapear_on := 0):
	
	var area = find_child(str(number))
	area.visible = true
	check_color.emit()
	
	for i in 3:
		if main: sound_low.play()
		await get_tree().create_timer(gen_wait_time).timeout
		if disapear_on == i + 1: 
			if main: check.emit()
			area.visible = false
			return
	if main: sound_high.play()
	await get_tree().create_timer(gen_wait_time).timeout
	
	if main: check.emit()
	area.visible = false

func check_in(number: int) -> bool:
	return on.has(number)


func _move_3():
	
	var obj1 := find_child(str(3))
	
	var tween := get_tree().create_tween()
	
	tween.set_parallel(true)
	
	tween.tween_property(obj1, "position:x", obj1.position.x + 50.0, 3.5)
	tween.tween_property(obj1, "position:y", obj1.position.y - 100.0, 3.5)

func _move_456():
	
	var obj1 := find_child(str(4))
	var obj2 := find_child(str(5))
	var obj3 := find_child(str(6))
	
	var tween := get_tree().create_tween()
	
	tween.set_parallel(true)
	
	tween.tween_property(obj1, "position:x", obj1.position.x - 176.0, 3.5)
	tween.tween_property(obj3, "position:x", obj3.position.x + 176.0, 3.5)
	tween.tween_property(obj2, "position:x", obj2.position.x + 88.0, 1.75)
	
	get_tree().create_timer(1.5).timeout.connect(func():
		var tween2 := get_tree().create_tween()
		tween2.tween_property(obj2, "position:x", obj2.position.x - 88.0, 1.75)
	)

func _move_7():
	
	var obj1 := find_child(str(7))
	
	var tween := get_tree().create_tween()
	
	tween.set_parallel(true)
	
	tween.tween_property(obj1, "position:x", obj1.position.x - 150.0, 3.5)
	
	tween.tween_property(obj1, "position:y", obj1.position.y + 80.0, 0.75)
	
	get_tree().create_timer(0.75).timeout.connect(func():
		var tween2 := get_tree().create_tween()
		tween2.tween_property(obj1, "position:y", obj1.position.y - 80.0, 0.75)
	)
	get_tree().create_timer(1.5).timeout.connect(func():
		var tween2 := get_tree().create_tween()
		tween2.tween_property(obj1, "position:y", obj1.position.y + 80.0, 0.75)
	)
	get_tree().create_timer(2.25).timeout.connect(func():
		var tween2 := get_tree().create_tween()
		tween2.tween_property(obj1, "position:y", obj1.position.y - 80.0, 0.75)
	)

func _move_2_4567():
	var obj1 := find_child(str(24))
	var obj2 := find_child(str(25))
	var obj3 := find_child(str(26))
	var obj4 := find_child(str(27))
	
	var tween := get_tree().create_tween()
	
	tween.set_parallel(true)
	
	tween.tween_property(obj1, "position:y", obj1.position.y - 80.0, 1.0)
	tween.tween_property(obj3, "position:y", obj3.position.y - 80.0, 1.0)
	tween.tween_property(obj2, "position:y", obj2.position.y + 80.0, 1.0)
	tween.tween_property(obj4, "position:y", obj4.position.y + 80.0, 1.0)
	
	get_tree().create_timer(1.0).timeout.connect(func():
		var tween2 := get_tree().create_tween()
		tween2.set_parallel(true)
		tween2.tween_property(obj1, "position:y", obj1.position.y + 80.0, 1.0)
		tween2.tween_property(obj3, "position:y", obj3.position.y + 80.0, 1.0)
		tween2.tween_property(obj2, "position:y", obj2.position.y - 80.0, 1.0)
		tween2.tween_property(obj4, "position:y", obj4.position.y - 80.0, 1.0)
	)
	
	get_tree().create_timer(2.0).timeout.connect(func():
		var tween2 := get_tree().create_tween()
		tween2.set_parallel(true)
		tween2.tween_property(obj1, "position:y", obj1.position.y - 80.0, 1.0)
		tween2.tween_property(obj3, "position:y", obj3.position.y - 80.0, 1.0)
		tween2.tween_property(obj2, "position:y", obj2.position.y + 80.0, 1.0)
		tween2.tween_property(obj4, "position:y", obj4.position.y + 80.0, 1.0)
	)
	
	get_tree().create_timer(3.0).timeout.connect(func():
		var tween2 := get_tree().create_tween()
		tween2.set_parallel(true)
		tween2.tween_property(obj1, "position:y", obj1.position.y + 80.0, 1.0)
		tween2.tween_property(obj3, "position:y", obj3.position.y + 80.0, 1.0)
		tween2.tween_property(obj2, "position:y", obj2.position.y - 80.0, 1.0)
		tween2.tween_property(obj4, "position:y", obj4.position.y - 80.0, 1.0)
	)
	
	get_tree().create_timer(4.0).timeout.connect(func():
		var tween2 := get_tree().create_tween()
		tween2.set_parallel(true)
		tween2.tween_property(obj1, "position:y", obj1.position.y - 80.0, 1.0)
		tween2.tween_property(obj3, "position:y", obj3.position.y - 80.0, 1.0)
		tween2.tween_property(obj2, "position:y", obj2.position.y + 80.0, 1.0)
		tween2.tween_property(obj4, "position:y", obj4.position.y + 80.0, 1.0)
	)
	
	get_tree().create_timer(5.0).timeout.connect(func():
		var tween2 := get_tree().create_tween()
		tween2.set_parallel(true)
		tween2.tween_property(obj1, "position:y", obj1.position.y + 80.0, 1.0)
		tween2.tween_property(obj3, "position:y", obj3.position.y + 80.0, 1.0)
		tween2.tween_property(obj2, "position:y", obj2.position.y - 80.0, 1.0)
		tween2.tween_property(obj4, "position:y", obj4.position.y - 80.0, 1.0)
	)
