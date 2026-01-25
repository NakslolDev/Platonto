extends Node

signal text(String)
signal player_lock(lock: bool)
signal text_finished
signal player_push_back


enum char {Player, Waifu, Scientist, General, Militar01, Militar02, Vegetal, Prisoner01, Prisoner02, Prisoner03, Prisoner04}

signal load_character(char: char, position: String)
signal unload_character(char: char)
signal change_room(char: char, to_room: String, position: String)

signal move_char(char: char, runing: bool, rout: Array[Vector2])
signal movement_done(char: char)
signal play_animation(char: char, String)

var animated_characters: Array[char]

var lock_cam := false
var displace_cam := Vector2.ZERO
var static_cam := Vector2.ZERO

signal get_char_position(char: char)
signal return_position(pos: Vector2)
var temporal_position: Vector2

func _ready():
	self.return_position.connect(_on_return_pos)

func _on_return_pos(pos: Vector2):
	temporal_position = pos

func find_char_position(chara: char) -> Vector2:
	get_char_position.emit(chara)
	await get_tree().physics_frame
	return temporal_position

func show_text(id: String):
	text.emit(id)

func freeze_player_ff():
	player_lock.emit(true)

func unfreeze_player_ff():
	player_lock.emit(false)

func text_freeze_player_ff():
	player_lock.emit(true)
	await self.text_finished
	player_lock.emit(false)

func player_push_back_ff():
	player_push_back.emit()


func npc_conected(id: char) -> bool:
	for characters in move_char.get_connections():
		var node = characters["callable"].get_object()
		if node.identifier == id:
			return true
	for characters in play_animation.get_connections(): # comprueva ambas señales por si acaso
		var node = characters["callable"].get_object()
		if node.identifier == id:
			return true
	return false

func unload_char(_char: char):
	if animated_characters.has(_char):
		animated_characters.erase(_char)

func _movement_done(character: char) -> void:
	while true:
		var kind = await self.movement_done
		if kind == character:
			return


func npc_test_ff():
	
	var npc_identif := char.Waifu
	
	if animated_characters.has(npc_identif):
		push_warning("there is an animation playing: ", npc_identif)
		return
	if not npc_conected(npc_identif):
		push_warning("npc not conected: ", npc_identif)
		return
	
	animated_characters.append(npc_identif)
	
	play_animation.emit(npc_identif, "stop")
	
	var running := false
	var rout: Array[Vector2] = [Vector2(100,0), Vector2(0, 3), Vector2(0,-6), Vector2(0,3)]
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	var animation := "spin"
	play_animation.emit(npc_identif, animation)
	
	var wait_time := 3.0
	await get_tree().create_timer(wait_time).timeout
	
	rout = [Vector2(-100,0)]
	
	play_animation.emit(npc_identif, "stop")
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	animation = "spin"
	play_animation.emit(npc_identif, animation)
	
	animated_characters.erase(npc_identif)

func player_test_ff():
	
	var npc_identif := char.Player
	
	if animated_characters.has(npc_identif):
		return
	if not npc_conected(npc_identif):
		return
	
	animated_characters.append(npc_identif)
	
	play_animation.emit(npc_identif, "stop")
	
	var running := false
	var rout: Array[Vector2] = [Vector2(100,0)]
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	var animation := "spin"
	play_animation.emit(npc_identif, animation)
	player_lock.emit(true)
	
	var wait_time := 3.0
	await get_tree().create_timer(wait_time).timeout
	
	player_lock.emit(false)
	
	rout = [Vector2(-100,0)]
	
	play_animation.emit(npc_identif, "stop")
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	animated_characters.erase(npc_identif)

func waifu_go_to_testhall_debug_ff():
	var npc_identif := char.Waifu
	
	if animated_characters.has(npc_identif):
		return
	if not npc_conected(npc_identif):
		return
	
	play_animation.emit(npc_identif, "stop")
	animated_characters.append(npc_identif)
	
	var running := true
	var rout: Array[Vector2] = [Vector2(-13.0, 0.0), Vector2(0.0, 160.0)] 
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	var wait_time := 0.5
	await get_tree().create_timer(wait_time).timeout
	
	var new_room := "TestHall"
	var position := "Default"
	change_room.emit(npc_identif, new_room, position, "none")
	
	animated_characters.erase(npc_identif)

func spawn_waifu_debug_ff():
	
	Gamestate.waifudebugin = true
	
	var npc_identif := char.Waifu
	var spawnpoint := "WaifuPoint01"
	load_character.emit(npc_identif, spawnpoint)

func despawn_waifu_debug_ff():
	
	Gamestate.waifudebugin = false
	
	var npc_identif := char.Waifu
	unload_character.emit(npc_identif)


signal open_gate(number: int)
signal open_door(identif: String)
@warning_ignore("unused_signal") # si se usa... Pero en otro script
signal close_door(identif: String)
signal card_accepted()


func open_door_ff(id: String):
	if Gamestate.open_doors.has(id): return
	card_accepted.emit()
	open_door.emit(id)

func open_gate_ff(id: int):
	if Gamestate.open_cells.has(id): return
	card_accepted.emit()
	open_gate.emit(id)


func first_animation_ff():
	
	lock_cam = true
	
	first_anim_waifu()
	first_anim_scientist()
	first_anim_general()
	first_anim_militar1()
	first_anim_militar2()
	
	var c := char
	load_character.emit(c.Vegetal, "Vegetal", &"idle_back")
	load_character.emit(c.Prisoner01, "Prisoner1", &"idle_front")
	load_character.emit(c.Prisoner02, "Prisoner2", &"idle_front")
	load_character.emit(c.Prisoner03, "Prisoner3", &"idle_back")
	load_character.emit(c.Prisoner04, "Prisoner4", &"spin")

func first_anim_waifu():
	var npc_identif := char.Waifu
	
	animated_characters.append(npc_identif)
	
	var spawnpoint := "WaifuPrison"
	load_character.emit(npc_identif, spawnpoint)
	await get_tree().process_frame
	
	var running := false
	var rout: Array[Vector2] = [Vector2(390, 0.0), Vector2(0.0, -10.0)] 
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	var wait_time := 1.0
	await get_tree().create_timer(wait_time).timeout
	
	var text_id := "Prison1"
	text.emit(text_id)
	
	await text_finished
	
	running = false
	rout = [Vector2(0.0, 10.0), Vector2(160, 0.0), Vector2(0.0, -10.0)] 
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	wait_time = 1.0
	await get_tree().create_timer(wait_time).timeout
	
	text_id = "Prison2"
	text.emit(text_id)
	
	await text_finished
	
	wait_time = 0.5
	await get_tree().create_timer(wait_time).timeout
	
	running = false
	rout = [Vector2(0.0, 10.0), Vector2(30, 0.0)] 
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	text_id = "PrisonDead"
	text.emit(text_id)
	
	await text_finished
	
	running = true
	rout = [Vector2(150, 0.0), Vector2(0, 5.0)] 
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	await text_finished
	
	wait_time = 0.5
	await get_tree().create_timer(wait_time).timeout
	
	running = false
	rout = [Vector2(-150, 0.0)] 
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	wait_time = 0.5
	await get_tree().create_timer(wait_time).timeout
	
	text_id = "PrisonDead3"
	text.emit(text_id)
	
	await text_finished
	
	wait_time = 1.2
	await get_tree().create_timer(wait_time).timeout
	
	running = false
	rout = [Vector2(-86.0, 0.0), Vector2(0.1, 0.0)] 
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	animated_characters.erase(npc_identif)

func first_anim_scientist():
	
	var npc_identif := char.Scientist
	
	animated_characters.append(npc_identif)
	
	var spawnpoint := "ScientistPrison"
	load_character.emit(npc_identif, spawnpoint)
	await get_tree().process_frame
	
	var running := false
	var rout: Array[Vector2] = [Vector2(390, 0.0), Vector2(0.0, -10.0)] 
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	await text_finished
	
	running = false
	rout = [Vector2(0.0, 10.0), Vector2(145, 0.0), Vector2(0.0, -10.0)] 
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	await text_finished
	
	var wait_time = 0.5
	await get_tree().create_timer(wait_time).timeout
	
	running = false
	rout = [Vector2(0.0, 10.0), Vector2(40, 0.0)] 
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	await text_finished
	
	await text_finished
	
	await text_finished
	
	running = false
	rout = [Vector2(-72.0, 0.0), Vector2(0.0, -20.0)] 
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	wait_time = 0.5
	await get_tree().create_timer(wait_time).timeout
	
	var animation := "idle_back"
	play_animation.emit(npc_identif, animation)
	
	wait_time = 1.5
	await get_tree().create_timer(wait_time).timeout
	
	animation = "idle_front"
	play_animation.emit(npc_identif, animation)
	
	wait_time = 0.5
	await get_tree().create_timer(wait_time).timeout
	
	open_gate.emit(2)
	Gamestate.current_mision = Gamestate.mision.FOLLOW_SCIENTIST
	lock_cam = false
	
	animated_characters.erase(npc_identif)

func first_anim_general():
	
	var npc_identif := char.General
	
	animated_characters.append(npc_identif)
	
	var spawnpoint := "GeneralPrison"
	load_character.emit(npc_identif, spawnpoint)
	await get_tree().process_frame
	
	var running := false
	var rout: Array[Vector2] = [Vector2(390, 0.0), Vector2(0.0, -10.0)] 
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	await text_finished
	
	var wait_time := 0.3
	await get_tree().create_timer(wait_time).timeout
	
	running = false
	rout = [Vector2(0.0, 10.0), Vector2(155, 0.0), Vector2(0.0, -15.0)] 
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	await text_finished
	
	wait_time = 1.3
	await get_tree().create_timer(wait_time).timeout
	
	running = false
	rout = [Vector2(0.0, 15.0), Vector2(30, 0.0)] 
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	wait_time = 2.0
	await get_tree().create_timer(wait_time).timeout
	
	var text_id := "PrisonDead2"
	text.emit(text_id)
	
	await text_finished
	
	await text_finished
	
	wait_time = 0.3
	await get_tree().create_timer(wait_time).timeout
	
	running = false
	rout = [Vector2(0.0, 10.0), Vector2(30.0, 0.0), Vector2(0.0, -10.0), Vector2(-0.1, 0.0)] 
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	animated_characters.erase(npc_identif)

func first_anim_militar1():
	
	var npc_identif := char.Militar01
	
	animated_characters.append(npc_identif)
	
	var spawnpoint := "Mili1Prison"
	load_character.emit(npc_identif, spawnpoint)
	await get_tree().process_frame
	
	var running := false
	var rout: Array[Vector2] = [Vector2(390, 0.0), Vector2(0.0, -10.0)] 
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	await text_finished
	
	var wait_time := 0.2
	await get_tree().create_timer(wait_time).timeout
	
	running = false
	rout = [Vector2(0.0, 10.0), Vector2(155, 0.0), Vector2(0.0, -10.0)] 
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	await text_finished
	
	wait_time = 0.4
	await get_tree().create_timer(wait_time).timeout
	
	running = false
	rout = [Vector2(0.0, 10.0), Vector2(40, 0.0)] 
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	await text_finished
	
	await text_finished
	
	running = true
	rout = [Vector2(150, 0.0)] 
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	unload_character.emit(npc_identif)
	
	animated_characters.erase(npc_identif)

func first_anim_militar2():
	
	var npc_identif := char.Militar02
	
	animated_characters.append(npc_identif)
	
	var spawnpoint := "Mili2Prison"
	load_character.emit(npc_identif, spawnpoint)
	await get_tree().process_frame
	
	var wait_time := 0.5
	await get_tree().create_timer(wait_time).timeout
	
	var running := false
	var rout: Array[Vector2] = [Vector2(390, 0.0), Vector2(0.0, -10.0)] 
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	await text_finished
	
	wait_time = 0.1
	await get_tree().create_timer(wait_time).timeout
	
	running = false
	rout = [Vector2(0.0, 10.0), Vector2(155, 0.0), Vector2(0.0, -10.0)] 
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	await text_finished
	
	wait_time = 0.6
	await get_tree().create_timer(wait_time).timeout
	
	running = false
	rout = [Vector2(0.0, 10.0), Vector2(40, 0.0)] 
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	await text_finished
	
	await text_finished
	
	running = true
	rout = [Vector2(150, 0.0)] 
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	unload_character.emit(npc_identif)
	
	animated_characters.erase(npc_identif)


func follow_waifu_ff():
	
	var npc_identif := char.Waifu
	
	if animated_characters.has(npc_identif):
		push_warning("there is an animation playing: ", npc_identif)
		return
	if not npc_conected(npc_identif):
		push_warning("npc not conected: ", npc_identif)
		return
	
	Gamestate.wait_before_trans = true
	
	animated_characters.append(npc_identif)
	
	await text_finished
	
	var running := false
	var rout: Array[Vector2] = [Vector2(-496, 0.0)] 
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	animated_characters.erase(npc_identif)

func follow_waifu_2_ff():
	
	var npc_identif := char.Waifu
	
	while animated_characters.has(npc_identif):
		await get_tree().process_frame # esto es guarro, pero no tengo tiempo para pulirlo
	if not npc_conected(npc_identif):
		push_warning("npc not conected: ", npc_identif)
		return
	
	animated_characters.append(npc_identif)
	
	var running := false
	var rout: Array[Vector2] = [Vector2(0.0, -90.0)] 
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	var wait_time := 0.5
	await get_tree().create_timer(wait_time).timeout
	
	var door_id := "prison_door"
	open_door.emit(door_id)
	
	await get_tree().create_timer(wait_time).timeout
	
	running = false
	rout = [Vector2(0.0, -8.0)] 
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	var new_room := "MainHall"
	var position := "Waifu1"
	change_room.emit(npc_identif, new_room, position, "none")
	
	Gamestate.wait_before_trans = false
	
	animated_characters.erase(npc_identif)

func enter_black_room_first_ff():
	
	var npc_identif := char.Waifu
	
	if animated_characters.has(npc_identif):
		push_warning("there is an animation playing: ", npc_identif)
		return
	if not npc_conected(npc_identif):
		push_warning("npc not conected: ", npc_identif)
		return
	
	animated_characters.append(npc_identif)
	animated_characters.append(char.Player)
	
	player_lock.emit(true)
	displace_cam = Vector2(0.0, -32.0)
	
	var running := false
	var rout: Array[Vector2] = [Vector2(-120, 0.0), Vector2(0.0, -40.0)] 
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	await get_tree().create_timer(1.0).timeout
	
	var text_id := "BlackRoomHere"
	text.emit(text_id)
	
	await text_finished
	
	var door := "door_black_room"
	open_door.emit(door)
	
	await get_tree().create_timer(1.0).timeout
	
	running = false
	rout = [Vector2(0.0, 32.0), Vector2(120, 0.0), Vector2(0.0, 16.0)] 
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	text_id = "BlackRoomThere"
	text.emit(text_id)
	
	await text_finished
	
	running = false
	rout = [Vector2(0.0, -144.0)] 
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	player_lock.emit(false)
	displace_cam = Vector2.ZERO
	
	animated_characters.erase(npc_identif)
	animated_characters.erase(char.Player)

func cam_place_black_room_ff():
	static_cam = Vector2(0.0, -120.0)

func cam_quit_black_room_ff():
	static_cam = Vector2.ZERO

signal punish_end
func punish_player():
	
	player_lock.emit(true)
	play_animation.emit(char.Player, "shock")
	
	await get_tree().create_timer(2.0).timeout
	
	player_lock.emit(false)
	play_animation.emit(char.Player, "stop")
	
	punish_end.emit()

signal start_test_1
func start_blackroom_1_ff():
	await text_finished
	start_test_1.emit()

signal continue_test
func explain_yellow_mellow_ff():
	
	var text_id := "empezartest2"
	text.emit(text_id)
	
	await text_finished
	await get_tree().create_timer(1.0).timeout
	continue_test.emit()

func exit_black_room_first_ff():
	
	var npc_identif := char.Waifu
	
	if animated_characters.has(npc_identif):
		push_warning("there is an animation playing: ", npc_identif)
		return
	if not npc_conected(npc_identif):
		push_warning("npc not conected: ", npc_identif)
		return
	
	animated_characters.append(npc_identif)
	animated_characters.append(char.Player)
	
	player_lock.emit(true)
	
	play_animation.emit(npc_identif, "stop")
	
	var running := true
	var rout: Array[Vector2] = [Vector2(0.0, 120.0), Vector2(-120.0, 0.0), Vector2(0.0, -16.0)] 
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	await get_tree().create_timer(0.5).timeout
	
	var text_id := "finaltest1"
	text.emit(text_id)
	
	await text_finished
	
	running = false
	rout = [Vector2(0.0, 16.0)] 
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	await get_tree().create_timer(0.5).timeout
	
	play_animation.emit(npc_identif, "idle_right")
	
	await get_tree().create_timer(0.5).timeout
	
	play_animation.emit(npc_identif, "idle_left")
	
	await get_tree().create_timer(0.5).timeout
	
	play_animation.emit(npc_identif, "idle_back")
	
	await get_tree().create_timer(1.0).timeout
	
	play_animation.emit(npc_identif, "walk_back")
	
	running = true
	rout = [Vector2(0.0, -20.0)] 
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	play_animation.emit(char.Player, "coffee") # hold coffee
	Gamestate.cup = true
	get_item.emit()
	
	rout = [Vector2(0.0, 20.0)] 
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	play_animation.emit(npc_identif, "idle_back")
	
	await get_tree().create_timer(1.0).timeout
	
	play_animation.emit(npc_identif, "stop")
	
	running = false
	rout = [Vector2(-100.0, 0.0)] 
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	await get_tree().create_timer(0.5).timeout
	
	text_id = "vecafe1"
	text.emit(text_id)
	
	await text_finished
	
	running = false
	rout = [Vector2(164.0, 0.0)] 
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	play_animation.emit(npc_identif, "idle_left")
	
	player_lock.emit(false)
	play_animation.emit(char.Player, "stop")
	
	animated_characters.erase(char.Player)
	animated_characters.erase(npc_identif)

func waifu_notes_ff():
	play_animation.emit(char.Waifu, "notes")

func waifu_no_more_notes_ff():
	play_animation.emit(char.Waifu, "idle_left")

signal coffee_cup(on: bool)

const MILK := Gamestate.coffee_food.MILK
const SUGAR := Gamestate.coffee_food.SUGAR
const COFFEE := Gamestate.coffee_food.COFFEE

signal get_item

func coffee_machine_ff():
	
	if Gamestate.in_cup.has(COFFEE): return
	
	player_lock.emit(true)
	animated_characters.append(char.Player)
	
	if Gamestate.in_cup == [MILK, SUGAR]:
		coffee_cup.emit(true, true)
		await get_tree().create_timer(5.0).timeout
		Gamestate.in_cup.append(COFFEE)
		get_item.emit()
		coffee_cup.emit(false)
		player_lock.emit(false)
		animated_characters.erase(char.Player)
	else:
		coffee_cup.emit(true)
		animation_on_coffee_machine()

func milk_ff():
	if Gamestate.in_cup.has(MILK): return
	if Gamestate.in_cup == []:
		get_item.emit()
		Gamestate.in_cup.append(MILK)

func sugar_ff():
	if Gamestate.in_cup.has(SUGAR): return
	if Gamestate.in_cup == [MILK]:
		get_item.emit()
		Gamestate.in_cup.append(SUGAR)
	else:
		player_lock.emit(true)
		animated_characters.append(char.Player)
		animation_on_sugar()

func animation_on_coffee_machine():
	
	var npc_identif := char.Scientist
	
	if animated_characters.has(npc_identif):
		push_warning("there is an animation playing: ", npc_identif)
		return
	if not npc_conected(npc_identif):
		push_warning("npc not conected: ", npc_identif)
		return
	
	animated_characters.append(npc_identif)
	
	play_animation.emit(npc_identif, "idle_right")
	
	var text_id := "sobresalto"
	text.emit(text_id)
	
	await text_finished
	await get_tree().create_timer(1.0).timeout
	
	
	play_animation.emit(npc_identif, "stop")
	var running := true
	var rout: Array[Vector2] = [Vector2(0.0,-6.0), Vector2(108.0,0.0)]
	
	move_char.emit(npc_identif, running, rout)
	
	await get_tree().create_timer(0.5).timeout
	
	running = false
	rout = [Vector2(16.0,0.0)]
	play_animation.emit(char.Player, "walk_left")
	move_char.emit(char.Player, running, rout)
	
	await _movement_done(char.Player)
	play_animation.emit(char.Player, "idle_left")
	
	await _movement_done(npc_identif)
	
	play_animation.emit(npc_identif, "idle_back")
	
	await get_tree().create_timer(1.0).timeout
	coffee_cup.emit(false)
	await get_tree().create_timer(1.0).timeout
	
	text_id = "explicacafe1"
	text.emit(text_id)
	
	play_animation.emit(npc_identif, "idle_right")
	await text_finished
	
	running = false
	rout = [Vector2(-41.0,0.0)]
	
	play_animation.emit(npc_identif, "stop")
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	play_animation.emit(npc_identif, "idle_back")
	await get_tree().create_timer(1.0).timeout
	Gamestate.in_cup.append(MILK)
	get_item.emit()
	
	await get_tree().create_timer(0.5).timeout
	
	text_id = "explicacafe2"
	text.emit(text_id)
	
	await text_finished
	
	running = false
	rout = [Vector2(-40.0,0.0)]
	
	play_animation.emit(npc_identif, "stop")
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	play_animation.emit(npc_identif, "idle_back")
	await get_tree().create_timer(1.0).timeout
	Gamestate.in_cup.append(SUGAR)
	get_item.emit()
	
	await get_tree().create_timer(0.5).timeout
	
	text_id = "explicacafe3"
	text.emit(text_id)
	
	await text_finished
	
	running = false
	rout = [Vector2(81.0,0.0)]
	
	play_animation.emit(npc_identif, "stop")
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	play_animation.emit(npc_identif, "idle_back")
	
	coffee_cup.emit(true, true)
	await get_tree().create_timer(5.0).timeout
	Gamestate.in_cup.append(COFFEE)
	get_item.emit()
	coffee_cup.emit(false)
	
	await get_tree().create_timer(0.5).timeout
	
	text_id = "explicacafe4"
	text.emit(text_id)
	
	await text_finished
	
	running = false
	rout = [Vector2(6.0, 0.0)]
	
	play_animation.emit(npc_identif, "walk_right")
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	get_item.emit()
	
	running = false
	rout = [Vector2(-6.0, 0.0)]
	
	play_animation.emit(npc_identif, "walk_right")
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	play_animation.emit(npc_identif, "idle_right")
	await get_tree().create_timer(0.5).timeout 
	
	player_lock.emit(false)
	play_animation.emit(char.Player, "stop")
	animated_characters.erase(char.Player)
	
	running = false
	rout = [Vector2(-108.0,0.0), Vector2(0.0,6.0)]
	
	play_animation.emit(npc_identif, "stop")
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	play_animation.emit(npc_identif, "coffee") # idle drinking coffee
	
	animated_characters.erase(npc_identif)

func animation_on_sugar():
	
	var npc_identif := char.Scientist
	
	if animated_characters.has(npc_identif):
		push_warning("there is an animation playing: ", npc_identif)
		return
	if not npc_conected(npc_identif):
		push_warning("npc not conected: ", npc_identif)
		return
	
	animated_characters.append(npc_identif)
	
	play_animation.emit(npc_identif, "idle_right")
	
	var text_id := "sobresalto"
	text.emit(text_id)
	
	await text_finished
	await get_tree().create_timer(1.0).timeout
	
	
	play_animation.emit(npc_identif, "stop")
	var running := true
	var rout: Array[Vector2] = [Vector2(0.0,-6.0), Vector2(27.0,0.0)]
	
	move_char.emit(npc_identif, running, rout)
	
	await get_tree().create_timer(0.1).timeout
	
	running = false
	rout = [Vector2(0,10)]
	play_animation.emit(char.Player, "walk_back")
	move_char.emit(char.Player, running, rout)
	
	await _movement_done(char.Player)
	play_animation.emit(char.Player, "idle_back")
	
	await _movement_done(npc_identif)
	
	running = false
	rout = [Vector2(0.0, 6.0), Vector2(0.0, -6.0)]
	
	play_animation.emit(npc_identif, "walk_front")
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	play_animation.emit(npc_identif, "idle_front")
	
	await get_tree().create_timer(0.5).timeout
	
	text_id = "explicacafe1"
	text.emit(text_id)
	
	await text_finished
	
	running = false
	rout = [Vector2(40.0,0.0)]
	
	play_animation.emit(npc_identif, "stop")
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	play_animation.emit(npc_identif, "idle_back")
	await get_tree().create_timer(1.0).timeout
	Gamestate.in_cup.append(MILK)
	get_item.emit()
	
	await get_tree().create_timer(0.5).timeout
	
	text_id = "explicacafe2"
	text.emit(text_id)
	
	await text_finished
	
	running = false
	rout = [Vector2(-40.0,0.0)]
	
	play_animation.emit(npc_identif, "stop")
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	play_animation.emit(npc_identif, "idle_back")
	await get_tree().create_timer(1.0).timeout
	Gamestate.in_cup.append(SUGAR)
	get_item.emit()
	
	await get_tree().create_timer(0.5).timeout
	
	text_id = "explicacafe3"
	text.emit(text_id)
	
	await text_finished
	
	running = false
	rout = [Vector2(81.0,0.0)]
	
	play_animation.emit(npc_identif, "stop")
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	play_animation.emit(npc_identif, "idle_back")
	
	coffee_cup.emit(true, true)
	await get_tree().create_timer(5.0).timeout
	Gamestate.in_cup.append(COFFEE)
	get_item.emit()
	coffee_cup.emit(false)
	
	await get_tree().create_timer(0.5).timeout
	
	text_id = "explicacafe4"
	text.emit(text_id)
	
	await text_finished
	
	running = false
	rout = [Vector2(-81.0, 0.0)]
	
	play_animation.emit(npc_identif, "stop")
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	running = false
	rout = [Vector2(0.0, 6.0)]
	
	play_animation.emit(npc_identif, "walk_front")
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	get_item.emit()
	
	running = false
	rout = [Vector2(0.0, -6.0)]
	
	play_animation.emit(npc_identif, "walk_front")
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	play_animation.emit(npc_identif, "idle_front")
	await get_tree().create_timer(0.5).timeout 
	
	player_lock.emit(false)
	play_animation.emit(char.Player, "stop")
	animated_characters.erase(char.Player)
	
	running = false
	rout = [Vector2(-27.0,0.0), Vector2(0.0,6.0)]
	
	play_animation.emit(npc_identif, "stop")
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	play_animation.emit(npc_identif, "coffee") # idle drinking coffee
	
	animated_characters.erase(npc_identif)

signal change_outfit(String)

signal fall_cup(Vector2)
func fall_with_coffee_ff():
	
	if not Input.is_action_pressed("run"):
		return
	
	var npc_identif := char.Player
	
	if animated_characters.has(npc_identif):
		push_warning("there is an animation playing: ", npc_identif)
		return
	if not npc_conected(npc_identif):
		push_warning("npc not conected: ", npc_identif)
		return
	
	animated_characters.append(char.Player)
	animated_characters.append(char.Waifu)
	
	play_animation.emit(npc_identif, "fall")
	
	Gamestate.cup = false
	Gamestate.in_cup = []
	
	var player_pos := await find_char_position(npc_identif)
	
	fall_cup.emit(player_pos)
	
	var running := true
	var rout: Array[Vector2] = [Vector2(16.0,0.0)]
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	play_animation.emit(char.Waifu, "idle_left")
	var text_id := "PrisonDead" # es solo un efecto de sonido que estoy reutilizando
	text.emit(text_id)
	
	running = false
	rout = [Vector2(16.0,0.0)]
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	player_lock.emit(true)
	
	await get_tree().create_timer(1.0).timeout
	
	player_pos = await find_char_position(npc_identif)
	
	npc_identif = char.Waifu # Ahora se va a mover waifu
	
	var waifu_pos := await find_char_position(npc_identif)
	
	var movement_y_needed: float = player_pos.y - waifu_pos.y
	var movement_x_needed: float = player_pos.x - waifu_pos.x + 16
	
	running = true
	rout = [Vector2(0.0,movement_y_needed), Vector2(movement_x_needed, 0.0)]
	
	play_animation.emit(npc_identif, "stop")
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	await get_tree().create_timer(0.5).timeout
	
	text_id = "fell1"
	text.emit(text_id)
	
	await text_finished
	
	play_animation.emit(char.Player, "idle_right")
	
	await get_tree().create_timer(1.0).timeout
	
	play_animation.emit(npc_identif, "idle_right")
	
	await get_tree().create_timer(1.0).timeout
	
	play_animation.emit(npc_identif, "idle_left")
	
	await get_tree().create_timer(0.5).timeout
	
	text_id = "fell2"
	text.emit(text_id)
	
	await text_finished
	
	await get_tree().create_timer(0.5).timeout
	
	waifu_pos = await find_char_position(npc_identif)
	
	movement_y_needed = -76.0 - waifu_pos.y
	movement_x_needed = -112.0 - waifu_pos.x
	
	running = false
	rout = [Vector2(movement_x_needed, 0.0), Vector2(0.0,movement_y_needed)]
	
	play_animation.emit(npc_identif, "stop")
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	animated_characters.erase(char.Player)
	animated_characters.erase(char.Waifu)
	
	await get_tree().create_timer(1.0).timeout
	
	open_blackroom_door_2()

func give_coffee_ff():
	
	var npc_identif := char.Waifu
	
	if animated_characters.has(npc_identif):
		push_warning("there is an animation playing: ", npc_identif)
		return
	if not npc_conected(npc_identif):
		push_warning("npc not conected: ", npc_identif)
		return
	
	animated_characters.append(char.Player)
	animated_characters.append(npc_identif)
	
	player_lock.emit(true)
	
	var player_pos := await find_char_position(char.Player)
	
	npc_identif = char.Waifu # Ahora se va a mover waifu
	
	var waifu_pos := await find_char_position(npc_identif)
	
	var movement_y_needed: float = player_pos.y - waifu_pos.y
	var movement_x_needed: float = player_pos.x - waifu_pos.x + 20
	
	var running := false
	var rout: Array[Vector2] = [Vector2(0.0,movement_y_needed), Vector2(movement_x_needed, 0.0)]
	
	play_animation.emit(npc_identif, "stop")
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	await get_tree().create_timer(0.5).timeout
	
	var text_id := "givecoffee1"
	text.emit(text_id)
	await text_finished
	
	running = false
	rout = [Vector2(-8.0, 0.0)]
	
	play_animation.emit(npc_identif, "walk_left")
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	get_item.emit()
	Gamestate.cup = false
	Gamestate.in_cup = []
	
	rout = [Vector2(8.0, 0.0)]
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	play_animation.emit(npc_identif, "idle_left")
	
	
	await get_tree().create_timer(1.0).timeout
	
	play_animation.emit(npc_identif, "coffee") #drink coffee
	
	await get_tree().create_timer(3.0).timeout
	
	play_animation.emit(npc_identif, "idle_left")
	
	await get_tree().create_timer(1.0).timeout
	
	text_id = "givecoffee2"
	text.emit(text_id)
	await text_finished
	
	player_pos = await find_char_position(char.Player)
	
	waifu_pos = await find_char_position(npc_identif)
	
	movement_y_needed = -76.0 - waifu_pos.y
	movement_x_needed = -112.0 - waifu_pos.x
	
	running = false
	rout = [Vector2(movement_x_needed, 0.0), Vector2(0.0,movement_y_needed)]
	
	play_animation.emit(npc_identif, "stop")
	move_char.emit(npc_identif, running, rout)
	
	await get_tree().create_timer(0.1).timeout
	
	running = false
	rout = [Vector2(movement_x_needed - 6, 0.0)]
	
	play_animation.emit(char.Player, "walk_right")
	move_char.emit(char.Player, running, rout)
	
	await _movement_done(char.Player)
	play_animation.emit(char.Player, "idle_right")
	
	await _movement_done(npc_identif)
	
	animated_characters.erase(char.Player)
	animated_characters.erase(char.Waifu)
	
	await get_tree().create_timer(1.0).timeout
	
	open_blackroom_door_2()

func open_blackroom_door_2():
	
	var npc_identif := char.Waifu
	
	if animated_characters.has(npc_identif):
		push_warning("there is an animation playing: ", npc_identif)
		return
	if not npc_conected(npc_identif):
		push_warning("npc not conected: ", npc_identif)
		return
	
	animated_characters.append(npc_identif)
	animated_characters.append(char.Player)
	
	open_door.emit("door_black_room")
	Gamestate.current_mision = Gamestate.mision.BLACKROOM_2
	
	await get_tree().create_timer(0.5).timeout
	
	var text_id := "segundotest"
	text.emit(text_id)
	
	await text_finished
	
	
	var running := false
	var rout: Array[Vector2] = [Vector2(0.0, 34.0), Vector2(20.0, 0.0)] 
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	await get_tree().create_timer(1.0).timeout
	
	play_animation.emit(npc_identif, "idle_left")
	
	await get_tree().create_timer(1.0).timeout
	
	text_id = "venunsegundo"
	text.emit(text_id)
	
	await text_finished
	
	await get_tree().create_timer(0.5).timeout
	
	
	var player_pos := await find_char_position(char.Player)
	
	var waifu_pos := await find_char_position(npc_identif)
	
	var movement_y_needed: float = waifu_pos.y - player_pos.y
	var movement_x_needed: float =  waifu_pos.x - player_pos.x - 15.6
	
	running = false
	rout = [Vector2(0.0,movement_y_needed), Vector2(movement_x_needed, 0.0)]
	
	play_animation.emit(char.Player, "stop")
	move_char.emit(char.Player, running, rout)
	await _movement_done(char.Player)
	
	await get_tree().create_timer(1.0).timeout
	
	running = false
	rout = [Vector2(0.0, 10.0)]
	
	play_animation.emit(npc_identif, "stop")
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	play_animation.emit(char.Player, "idle_front")
	
	running = false
	rout = [Vector2(-15.0, 0.0), Vector2(0.0, -6.0)]
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	await get_tree().create_timer(1.0).timeout
	play_animation.emit(char.Player, "idle_right")
	await get_tree().create_timer(0.5).timeout
	change_outfit.emit("b")
	get_item.emit()
	await get_tree().create_timer(0.5).timeout
	
	play_animation.emit(char.Player, "idle_front")
	
	running = false
	rout = [Vector2(0.0, 5.0), Vector2(15.0, 0.0)]
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	play_animation.emit(char.Player, "idle_right")
	
	running = false
	rout = [Vector2(0.0, -10.0)]
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	play_animation.emit(npc_identif, "idle_left")
	
	await get_tree().create_timer(1.5).timeout
	
	text_id = "ropa"
	text.emit(text_id)
	await text_finished
	
	running = false
	rout = [Vector2(100.0, 0.0), Vector2(0.0, -112.0)]
	
	play_animation.emit(npc_identif, "stop")
	move_char.emit(npc_identif, running, rout)
	
	await get_tree().create_timer(2.0).timeout
	player_lock.emit(false)
	play_animation.emit(char.Player, "stop")
	
	await _movement_done(npc_identif)
	
	if Gamestate.entered_black_room_second_time:
		animated_characters.erase(char.Player)
		animated_characters.erase(npc_identif)
		return
	
	play_animation.emit(npc_identif, "notes") # notes
	
	animated_characters.erase(char.Player)
	animated_characters.erase(npc_identif)


signal start_test_2
func start_blackroom_2_ff():
	await text_finished
	start_test_2.emit()

func exit_test_2_ff():
	var text_id := "exittest"
	text.emit(text_id)
	
	await text_finished
	continue_test.emit()


func exit_black_room_second_ff():
	
	var npc_identif := char.Waifu
	
	if animated_characters.has(npc_identif):
		push_warning("there is an animation playing: ", npc_identif)
		return
	if not npc_conected(npc_identif):
		push_warning("npc not conected: ", npc_identif)
		return
	
	animated_characters.append(npc_identif)
	animated_characters.append(char.Player)
	
	player_lock.emit(true)
	
	play_animation.emit(npc_identif, "stop")
	
	var running := true
	var rout: Array[Vector2] = [Vector2(0.0, 120.0), Vector2(-120.0, 0.0), Vector2(0.0, -16.0)] 
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	await get_tree().create_timer(0.5).timeout
	
	var text_id := "finaltest2"
	text.emit(text_id)
	
	await text_finished
	
	await get_tree().create_timer(0.5).timeout
	
	get_item.emit()
	Gamestate.cup = true
	play_animation.emit(char.Player, "coffee") # hold cup
	
	await get_tree().create_timer(0.5).timeout
	
	text_id = "otrocafeporfa"
	text.emit(text_id)
	
	await text_finished
	
	await get_tree().create_timer(0.5).timeout
	
	running = false
	rout = [Vector2(0.0, 16.0), Vector2(120.0, 0.0), Vector2(0.0, -112.0)] 
	
	move_char.emit(npc_identif, running, rout)
	
	await get_tree().create_timer(3.0).timeout
	player_lock.emit(false)
	play_animation.emit(char.Player, "stop")
	animated_characters.erase(char.Player)
	
	await _movement_done(npc_identif)
	play_animation.emit(npc_identif, "notes") # notes
	
	animated_characters.erase(npc_identif)


func give_2_coffee_ff():
	
	var npc_identif := char.Waifu
	
	if animated_characters.has(npc_identif):
		push_warning("there is an animation playing: ", npc_identif)
		return
	if not npc_conected(npc_identif):
		push_warning("npc not conected: ", npc_identif)
		return
	
	animated_characters.append(char.Player)
	player_lock.emit(true)
	animated_characters.append(npc_identif)
	
	var player_pos := await find_char_position(char.Player)
	
	var waifu_pos := await find_char_position(npc_identif)
	
	var movement_y_needed: float = player_pos.y - waifu_pos.y -10
	var movement_x_needed: float = player_pos.x - waifu_pos.x
	
	var running := false
	var rout: Array[Vector2] = [Vector2(movement_x_needed, 0.0), Vector2(0.0,movement_y_needed)]
	
	play_animation.emit(npc_identif, "stop")
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	get_item.emit()
	Gamestate.cup = false
	Gamestate.in_cup = []
	
	await get_tree().create_timer(1.0).timeout
	
	play_animation.emit(npc_identif, "coffee") #drink coffee
	
	await get_tree().create_timer(3.0).timeout
	
	play_animation.emit(npc_identif, "stop")
	
	await get_tree().create_timer(1.0).timeout
	
	var text_id = "givecoffee3"
	text.emit(text_id)
	await text_finished
	
	await get_tree().create_timer(0.5).timeout 
	
	running = false
	
	var idle_side: String
	
	if player_pos.x > 8:
		rout = [Vector2(-10.0, 0.0), Vector2(0.0, 20.0), Vector2(10.0, 0.0), Vector2(0.0, -6.0)]
		idle_side = "idle_left"
	else:
		rout = [Vector2(10.0, 0.0), Vector2(0.0, 20.0), Vector2(-10.0, 0.0), Vector2(0.0, -6.0)]
		idle_side = "idle_right"
	
	move_char.emit(npc_identif, running, rout)
	
	await get_tree().create_timer(0.3).timeout
	play_animation.emit(char.Player, idle_side)
	await get_tree().create_timer(0.3).timeout
	play_animation.emit(char.Player, "idle_front")
	
	await _movement_done(npc_identif)
	
	play_animation.emit(npc_identif, "idle_back")
	
	await get_tree().create_timer(1.0).timeout
	
	text_id = "ven"
	text.emit(text_id)
	
	await get_tree().create_timer(1.0).timeout
	
	running = false
	
	waifu_pos = await find_char_position(npc_identif)
	
	movement_y_needed = -40 - waifu_pos.y
	movement_x_needed = 160 - waifu_pos.x
	
	rout = [Vector2(0.0, movement_y_needed), Vector2(movement_x_needed, 0.0), Vector2(0.0, -48.0)]
	play_animation.emit(npc_identif, "stop")
	move_char.emit(npc_identif, running, rout)
	
	await get_tree().create_timer(0.2).timeout
	
	player_pos = await find_char_position(char.Player)
	
	movement_y_needed = -40 - player_pos.y
	movement_x_needed = 160 - player_pos.x
	
	rout = [Vector2(0.0, movement_y_needed), Vector2(movement_x_needed, 0.0), Vector2(0.0, -40.0)]
	play_animation.emit(char.Player, "stop")
	move_char.emit(char.Player, running, rout)
	
	await _movement_done(char.Player)
	
	await get_tree().create_timer(1.0).timeout
	
	open_door.emit("door_lab")
	
	await get_tree().create_timer(1.0).timeout
	
	running = false
	rout = [Vector2(0.0, -10.0)]
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	await get_tree().create_timer(1.0).timeout
	
	var new_room := "Lab"
	var position := "Waifu1"
	change_room.emit(npc_identif, new_room, position, "idle_front")
	
	await get_tree().create_timer(1.0).timeout
	
	running = false
	rout = [Vector2(0.0, -16.0)]
	
	move_char.emit(char.Player, running, rout)
	
	animated_characters.erase(npc_identif)
	animated_characters.erase(char.Player)


signal take_needle(int)
signal put_needle(int)

signal change_font(normal: bool)

signal hurt
signal needle

signal activate_headache
signal deactivate_headache

signal blackout
signal blackin

func first_lab_ff():
	
	var npc_identif := char.Waifu
	
	if animated_characters.has(npc_identif):
		push_warning("there is an animation playing: ", npc_identif)
		return
	if not npc_conected(npc_identif):
		push_warning("npc not conected: ", npc_identif)
		return
	
	animated_characters.append(char.Player)
	player_lock.emit(true)
	animated_characters.append(npc_identif)
	
	await get_tree().create_timer(1.0).timeout
	
	var text_id := "laboratorio1"
	text.emit(text_id)
	
	await text_finished
	
	var running := false
	var rout: Array[Vector2] = [Vector2(0.0, -48.0), Vector2(96.0, 0.0)]
	
	play_animation.emit(npc_identif, "stop")
	move_char.emit(npc_identif, running, rout)
	
	await get_tree().create_timer(1.0).timeout
	player_lock.emit(false)
	play_animation.emit(char.Player, "stop")
	animated_characters.erase(char.Player)
	
	
	await _movement_done(npc_identif)
	
	play_animation.emit(npc_identif, "notes") # read notes
	
	await get_tree().create_timer(4.0).timeout
	
	running = false
	rout = [Vector2(0.0, -24.0), Vector2(8.0, 0.0)]
	
	play_animation.emit(npc_identif, "stop")
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	play_animation.emit(npc_identif, "notes") # read notes
	
	await get_tree().create_timer(3.0).timeout
	
	running = false
	rout = [Vector2(0.0, 40.0)]
	
	play_animation.emit(npc_identif, "stop")
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	play_animation.emit(npc_identif, "idle_right")
	
	await get_tree().create_timer(1.0).timeout
	
	play_animation.emit(npc_identif, "notes") # read notes
	
	await get_tree().create_timer(1.0).timeout
	
	play_animation.emit(npc_identif, "idle_right")
	
	await get_tree().create_timer(1.0).timeout
	
	get_item.emit()
	take_needle.emit(1)
	
	await get_tree().create_timer(0.5).timeout
	
	running = false
	rout = [Vector2(0.0, -16.0), Vector2(-104.0, 0.0)]
	
	play_animation.emit(npc_identif, "stop")
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	play_animation.emit(npc_identif, "idle_front")
	
	while Gamestate.printing:
		await text_finished
		await get_tree().create_timer(0.5).timeout
	
	text_id = "veninyeccion"
	text.emit(text_id)
	
	text_freeze_player_ff()
	
	Gamestate.waifu_in_center_of_lab = true
	
	animated_characters.erase(npc_identif)

func get_injection_ff():
	
	var npc_identif := char.Waifu
	
	if animated_characters.has(npc_identif):
		push_warning("there is an animation playing: ", npc_identif)
		return
	if not npc_conected(npc_identif):
		push_warning("npc not conected: ", npc_identif)
		return
	
	animated_characters.append(char.Player)
	player_lock.emit(true)
	play_animation.emit(char.Player, "idle_back")
	animated_characters.append(npc_identif)
	
	var text_id := "inyeccion1"
	text.emit(text_id)
	
	await text_finished
	
	await get_tree().create_timer(1.0).timeout
	
	change_font.emit(true)
	needle.emit()
	
	await get_tree().create_timer(1.0).timeout
	
	var running := false
	var rout: Array[Vector2] = [Vector2(-40.0, 0.0), Vector2(0.0, 24.0)]
	
	play_animation.emit(npc_identif, "stop")
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	play_animation.emit(npc_identif, "idle_left")
	
	await get_tree().create_timer(1.0).timeout
	put_needle.emit(2)
	await get_tree().create_timer(1.0).timeout
	
	play_animation.emit(npc_identif, "idle_right")
	
	await get_tree().create_timer(0.5).timeout
	
	text_id = "inyeccion2"
	text.emit(text_id)
	
	await text_finished
	
	play_animation.emit(char.Player, "idle_left")
	
	await get_tree().create_timer(1.5).timeout
	
	hurt.emit()
	play_animation.emit(char.Player, "hurt") # hurt
	activate_headache.emit()
	
	await get_tree().create_timer(2.0).timeout
	
	text_id = "inyeccion3"
	text.emit(text_id)
	
	running = true
	rout = [Vector2(80.0, 0.0), Vector2(0.0, -24.0), Vector2(64.0, 0.0), Vector2(0.0, -28.0)]
	
	play_animation.emit(npc_identif, "stop")
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	play_animation.emit(npc_identif, "idle_right")
	
	await get_tree().create_timer(0.5).timeout
	take_needle.emit(3)
	get_item.emit()
	await get_tree().create_timer(0.5).timeout
	
	var player_pos := await find_char_position(char.Player)
	
	var waifu_pos := await find_char_position(npc_identif)
	
	var movement_y_needed: float = player_pos.y - waifu_pos.y
	var movement_x_needed: float = player_pos.x - waifu_pos.x + 12
	
	running = true
	rout = [Vector2(0.0,movement_y_needed), Vector2(movement_x_needed, 0.0)]
	
	play_animation.emit(npc_identif, "stop")
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	await get_tree().create_timer(0.5).timeout
	
	needle.emit()
	blackout.emit()
	change_font.emit(false)
	
	await get_tree().create_timer(5.0).timeout
	
	var new_room := "WaifuRoom"
	var position := "Waifu1"
	change_room.emit(npc_identif, new_room, position, "idle_front")
	
	deactivate_headache.emit()
	
	get_tree().current_scene.change_room("WaifuRoom")
	
	animated_characters.erase(char.Player)
	animated_characters.erase(npc_identif)

signal leave_card
signal take_card
signal leave_notes
signal door_room_visible(bool)

func room_ff():
	
	var npc_identif := char.Waifu
	
	if animated_characters.has(npc_identif):
		push_warning("there is an animation playing: ", npc_identif)
		return
	if not npc_conected(npc_identif):
		push_warning("npc not conected: ", npc_identif)
		return
	
	displace_cam = Vector2(-24.0, -48.0)
	
	animated_characters.append(char.Player)
	player_lock.emit(true)
	play_animation.emit(char.Player, "idle_back")
	animated_characters.append(npc_identif)
	
	await get_tree().create_timer(1.0).timeout
	
	blackin.emit()
	
	await get_tree().create_timer(4.0).timeout
	
	var text_id := "room1"
	text.emit(text_id)
	
	await text_finished
	
	var running := false
	var rout: Array[Vector2] = [Vector2(-56.0, 0.0), Vector2(0.0, 40.0)]
	
	play_animation.emit(npc_identif, "stop")
	move_char.emit(npc_identif, running, rout)
	
	await get_tree().create_timer(1.0).timeout
	play_animation.emit(char.Player, "idle_left")
	
	await _movement_done(npc_identif)
	
	play_animation.emit(npc_identif, "idle_left")
	
	await get_tree().create_timer(1.0).timeout
	
	text_id = "room2"
	text.emit(text_id)
	
	await text_finished
	
	await get_tree().create_timer(1.0).timeout
	
	leave_notes.emit()
	
	await get_tree().create_timer(1.0).timeout
	
	running = false
	rout = [Vector2(0.0, -88.0)]
	
	play_animation.emit(npc_identif, "stop")
	move_char.emit(npc_identif, running, rout)
	
	await get_tree().create_timer(1.5).timeout
	play_animation.emit(char.Player, "idle_back")
	
	await _movement_done(npc_identif)
	
	play_animation.emit(npc_identif, "idle_left")
	
	await get_tree().create_timer(1.0).timeout
	
	text_id = "room3"
	text.emit(text_id)
	
	await text_finished
	
	await get_tree().create_timer(1.0).timeout
	
	leave_card.emit()
	
	await get_tree().create_timer(1.0).timeout
	
	running = false
	rout = [Vector2(16.0, 0.0), Vector2(0.0, -10.0)]
	
	play_animation.emit(npc_identif, "stop")
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	await get_tree().create_timer(1.0).timeout
	
	play_animation.emit(npc_identif, "idle_front")
	text_id = "room4"
	text.emit(text_id)
	
	await text_finished
	
	play_animation.emit(npc_identif, "stop")
	door_room_visible.emit(false)
	
	await get_tree().create_timer(0.5).timeout
	
	running = false
	rout = [Vector2(0.0, -12.0)]
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	play_animation.emit(npc_identif, "idle_front")
	
	await get_tree().create_timer(0.5).timeout
	
	door_room_visible.emit(true)
	
	await get_tree().create_timer(1.0).timeout
	
	player_lock.emit(false)
	displace_cam = Vector2.ZERO
	play_animation.emit(char.Player, "stop")
	
	animated_characters.erase(char.Player)
	animated_characters.erase(npc_identif)

func take_card_ff():
	take_card.emit()
	get_item.emit()
	Gamestate.card = true


func exit_ending_ff():
	player_lock.emit(true)
	blackout.emit()
	
	Gamestate.ending = Gamestate.end.EXIT
	
	await get_tree().create_timer(5.0).timeout
	
	await get_tree().process_frame
	
	get_tree().change_scene_to_file("res://Escenas/EndScreen/ending.tscn")

signal gun
signal alarm

func prison_ending_ff():
	
	var npc_identif := char.Prisoner01
	
	if animated_characters.has(npc_identif):
		push_warning("there is an animation playing: ", npc_identif)
		return
	if not npc_conected(npc_identif):
		push_warning("npc not conected: ", npc_identif)
		return
	
	animated_characters.append(char.Player)
	player_lock.emit(true)
	animated_characters.append(npc_identif)
	
	var player_pos := await find_char_position(char.Player)
	
	var prisoner_pos := await find_char_position(npc_identif)
	
	var movement_x_needed: float = player_pos.x - prisoner_pos.x
	
	await get_tree().create_timer(1.0).timeout
	
	play_animation.emit(char.Player, "idle_left")
	
	prisoner2_escape()
	prisoner3_escape()
	prisoner4_escape()
	
	var running := true
	var rout: Array[Vector2] = [Vector2(0.0, 16.0), Vector2(movement_x_needed, 0.0)]
	
	play_animation.emit(npc_identif, "stop")
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	play_animation.emit(char.Player, "idle_front")
	play_animation.emit(npc_identif, "idle_back")
	
	load_character.emit(char.General, "PSGeneral")
	
	
	load_character.emit(char.Militar01, "PSMilitar1")
	
	
	load_character.emit(char.Militar02, "PSMilitar2")
	
	await get_tree().process_frame
	
	play_animation.emit(char.General, "idle_right")
	play_animation.emit(char.Militar01, "gun") # holding gun
	play_animation.emit(char.Militar02, "gun") # holding gun
	
	await get_tree().create_timer(0.5).timeout
	
	var text_id := "prisonescape1"
	text.emit(text_id)
	
	await text_finished
	
	await get_tree().create_timer(0.3).timeout
	alarm.emit()
	await get_tree().create_timer(1.5).timeout
	
	text_id = "prisonescape2"
	text.emit(text_id)
	
	await text_finished
	
	text_id = "prisonescape3"
	text.emit(text_id)
	
	await text_finished
	
	play_animation.emit(char.Player, "idle_left")
	play_animation.emit(npc_identif, "idle_left")
	
	await get_tree().create_timer(0.5).timeout
	
	displace_cam = Vector2(-100.0, 50.0)
	
	await get_tree().create_timer(1.0).timeout
	
	text_id = "prisonescape4"
	text.emit(text_id)
	
	await text_finished
	
	text_id = "prisonescape5"
	text.emit(text_id)
	
	await get_tree().create_timer(1.0).timeout
	
	gun.emit()
	
	await get_tree().create_timer(0.1).timeout
	
	Gamestate.ending = Gamestate.end.PRISON
	
	await get_tree().process_frame
	
	get_tree().change_scene_to_file("res://Escenas/EndScreen/ending.tscn")

func prisoner2_escape():
	
	var npc_identif := char.Prisoner02
	
	if animated_characters.has(npc_identif):
		push_warning("there is an animation playing: ", npc_identif)
		return
	if not npc_conected(npc_identif):
		push_warning("npc not conected: ", npc_identif)
		return
	
	animated_characters.append(npc_identif)
	
	var running := true
	var rout: Array[Vector2] = [Vector2(-47.0, 0.0), Vector2(0.0, 61.0), Vector2(-300.0, 0.0)]
	
	play_animation.emit(npc_identif, "stop")
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	unload_char(npc_identif)

func prisoner3_escape():
	
	var npc_identif := char.Prisoner03
	
	if animated_characters.has(npc_identif):
		push_warning("there is an animation playing: ", npc_identif)
		return
	if not npc_conected(npc_identif):
		push_warning("npc not conected: ", npc_identif)
		return
	
	animated_characters.append(npc_identif)
	
	var running := true
	var rout: Array[Vector2] = [Vector2(31.0, 0.0), Vector2(0.0, 56.0), Vector2(-300.0, 0.0)]
	
	play_animation.emit(npc_identif, "stop")
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	unload_char(npc_identif)

func prisoner4_escape():
	
	var npc_identif := char.Prisoner04
	
	if animated_characters.has(npc_identif):
		push_warning("there is an animation playing: ", npc_identif)
		return
	if not npc_conected(npc_identif):
		push_warning("npc not conected: ", npc_identif)
		return
	
	animated_characters.append(npc_identif)
	
	var running := true
	var rout: Array[Vector2] = [Vector2(65.0, 0.0), Vector2(0.0, 73.0), Vector2(-300.0, 0.0)]
	
	play_animation.emit(npc_identif, "stop")
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	unload_char(npc_identif)


func drugs_ending_ff():
	
	var npc_identif := char.Player
	
	if animated_characters.has(npc_identif):
		push_warning("there is an animation playing: ", npc_identif)
		return
	if not npc_conected(npc_identif):
		push_warning("npc not conected: ", npc_identif)
		return
	
	animated_characters.append(npc_identif)
	player_lock.emit(true)
	play_animation.emit(npc_identif, "idle_left")
	
	take_needle.emit(2)
	
	await get_tree().create_timer(1.0).timeout
	
	Gamestate.current_mision = Gamestate.mision.DRUGGED_ENDING
	needle.emit()
	change_font.emit(true)
	
	await get_tree().create_timer(2.0).timeout
	
	play_animation.emit(npc_identif, "stop")
	player_lock.emit(false)
	animated_characters.erase(npc_identif)

var decision: bool
signal decide
signal decided

func drugs_ending_2_ff():
	
	var npc_identif := char.Waifu
	
	load_character.emit(npc_identif, "Waifu2")
	await get_tree().process_frame
	
	if animated_characters.has(npc_identif):
		push_warning("there is an animation playing: ", npc_identif)
		return
	if not npc_conected(npc_identif):
		push_warning("npc not conected: ", npc_identif)
		return
	
	animated_characters.append(npc_identif)
	animated_characters.append(char.Player)
	player_lock.emit(true)
	
	var running := false
	var rout: Array[Vector2] = [Vector2(40.0, 0.0)]
	
	play_animation.emit(npc_identif, "stop")
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	var text_id := "PrisonDead"
	text.emit(text_id)
	
	await text_finished
	
	var player_pos := await find_char_position(char.Player)
	
	var waifu_pos := await find_char_position(npc_identif)
	
	var movement_x_needed: float = player_pos.x - waifu_pos.x - 16
	var movement_y_needed: float = player_pos.y - waifu_pos.y
	
	running = true
	rout = [Vector2(0.0, movement_y_needed), Vector2(movement_x_needed, 0.0)]
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	await get_tree().create_timer(0.5).timeout
	
	text_id = "drugs1"
	text.emit(text_id)
	
	await text_finished
	
	var go_up: bool = player_pos.y > -40.0
	
	movement_y_needed = 16.0
	if go_up: movement_y_needed *= -1
	
	running = false
	rout = [Vector2(0.0, movement_y_needed), Vector2(72.0, 0.0)]
	
	move_char.emit(npc_identif, running, rout)
	
	await get_tree().create_timer(0.5).timeout
	play_animation.emit(char.Player, "idle_right")
	
	await _movement_done(npc_identif)
	play_animation.emit(npc_identif, "idle_back")
	await get_tree().create_timer(1.0).timeout
	play_animation.emit(npc_identif, "idle_left")
	
	text_id = "drugs2"
	text.emit(text_id)
	
	await text_finished
	
	hurt.emit()
	play_animation.emit(char.Player, "hurt") # hurt
	activate_headache.emit()
	
	await get_tree().create_timer(0.5).timeout
	
	running = true
	rout = [Vector2(0.0, -movement_y_needed), Vector2(-32.0, 0.0)]
	
	play_animation.emit(npc_identif, "stop")
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	play_animation.emit(npc_identif, "panic")
	
	text_id = "drugs3"
	text.emit(text_id)
	
	await text_finished
	
	await get_tree().create_timer(1.0).timeout
	
	play_animation.emit(npc_identif, "stop")
	
	running = false
	rout = [Vector2(16.0, 0.0)]
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	await get_tree().create_timer(0.5).timeout
	
	text_id = "drugs4"
	text.emit(text_id)
	
	await text_finished
	
	await get_tree().create_timer(1.0).timeout
	
	running = false
	rout = [Vector2(-20.0, 0.0)]
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	text_id = "drugs5"
	text.emit(text_id)
	
	await text_finished
	
	decide.emit()
	await decided
	
	if decision:
		text_id = "drugsyes"
	else:
		text_id = "drugsno"
	text.emit(text_id)
	
	blackout.emit()
	
	Gamestate.ending = Gamestate.end.DRUGS
	
	await get_tree().create_timer(5.0).timeout
	
	await get_tree().process_frame
	
	get_tree().change_scene_to_file("res://Escenas/EndScreen/ending.tscn")
