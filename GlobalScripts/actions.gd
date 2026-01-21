extends Node

signal text(String)
signal player_lock(lock: bool)
signal text_finished
signal player_push_back


enum char {Player, Waifu, Scientist, General, Militar01, Militar02, Militar03, Prisoner01}

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

func first_animation_ff():
	
	lock_cam = true
	
	first_anim_waifu()
	first_anim_scientist()
	first_anim_general()
	first_anim_militar1()
	first_anim_militar2()

func first_anim_waifu():
	var npc_identif := char.Waifu
	
	animated_characters.append(npc_identif)
	
	var spawnpoint := "WaifuPrison"
	load_character.emit(npc_identif, spawnpoint)
	
	var running := false
	var rout: Array[Vector2] = [Vector2(370, 0.0), Vector2(0.0, -10.0)] 
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	var wait_time := 1.0
	await get_tree().create_timer(wait_time).timeout
	
	var text_id := "Prison1"
	text.emit(text_id)
	
	await text_finished
	
	running = false
	rout = [Vector2(0.0, 10.0), Vector2(180, 0.0), Vector2(0.0, -10.0)] 
	
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
	
	var running := false
	var rout: Array[Vector2] = [Vector2(370, 0.0), Vector2(0.0, -10.0)] 
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	await text_finished
	
	running = false
	rout = [Vector2(0.0, 10.0), Vector2(165, 0.0), Vector2(0.0, -10.0)] 
	
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
	rout = [Vector2(-80.0, 0.0), Vector2(0.0, -20.0)] 
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	wait_time = 0.5
	await get_tree().create_timer(wait_time).timeout
	
	var animation := "spin"
	play_animation.emit(npc_identif, animation)
	
	wait_time = 1.5
	await get_tree().create_timer(wait_time).timeout
	
	animation = "stop"
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
	
	var running := false
	var rout: Array[Vector2] = [Vector2(370, 0.0), Vector2(0.0, -10.0)] 
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	await text_finished
	
	var wait_time := 0.3
	await get_tree().create_timer(wait_time).timeout
	
	running = false
	rout = [Vector2(0.0, 10.0), Vector2(175, 0.0), Vector2(0.0, -15.0)] 
	
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
	
	var running := false
	var rout: Array[Vector2] = [Vector2(370, 0.0), Vector2(0.0, -10.0)] 
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	await text_finished
	
	var wait_time := 0.2
	await get_tree().create_timer(wait_time).timeout
	
	running = false
	rout = [Vector2(0.0, 10.0), Vector2(175, 0.0), Vector2(0.0, -10.0)] 
	
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
	
	var running := false
	var rout: Array[Vector2] = [Vector2(370, 0.0), Vector2(0.0, -10.0)] 
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	await text_finished
	
	var wait_time := 0.1
	await get_tree().create_timer(wait_time).timeout
	
	running = false
	rout = [Vector2(0.0, 10.0), Vector2(175, 0.0), Vector2(0.0, -10.0)] 
	
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
	
	play_animation.emit(char.Player, "spin")
	Gamestate.cup = true
	
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
	
	animated_characters.erase(npc_identif)

signal coffee_cup(on: bool)

const MILK := Gamestate.coffee_food.MILK
const SUGAR := Gamestate.coffee_food.SUGAR
const COFFEE := Gamestate.coffee_food.COFFEE

func coffee_machine_ff():
	
	if Gamestate.in_cup.has(COFFEE): return
	
	player_lock.emit(true)
	
	if Gamestate.in_cup == [MILK, SUGAR]:
		coffee_cup.emit(true, true)
		await get_tree().create_timer(5.0).timeout
		Gamestate.in_cup.append(COFFEE)
		coffee_cup.emit(false)
		player_lock.emit(false)
	else:
		coffee_cup.emit(true)
		animation_on_coffee_machine()

func milk_ff():
	if Gamestate.in_cup.has(MILK): return
	if Gamestate.in_cup == []:
		Gamestate.in_cup.append(MILK)

func sugar_ff():
	if Gamestate.in_cup.has(SUGAR): return
	if Gamestate.in_cup == [MILK]:
		Gamestate.in_cup.append(SUGAR)
	else:
		player_lock.emit(true)
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
	player_lock.emit(false)
	play_animation.emit(char.Player, "walk_left")
	move_char.emit(char.Player, running, rout)
	
	await _movement_done(char.Player)
	play_animation.emit(char.Player, "idle_left")
	player_lock.emit(true)
	
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
	coffee_cup.emit(false)
	
	text_id = "explicacafe4"
	text.emit(text_id)
	
	await text_finished
	
	running = false
	rout = [Vector2(6.0, 0.0), Vector2(-6.0, 0.0)]
	
	play_animation.emit(npc_identif, "walk_right")
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	play_animation.emit(npc_identif, "idle_right")
	await get_tree().create_timer(0.5).timeout 
	
	player_lock.emit(false)
	play_animation.emit(char.Player, "stop")
	
	running = false
	rout = [Vector2(-108.0,0.0), Vector2(0.0,6.0)]
	
	play_animation.emit(npc_identif, "stop")
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	play_animation.emit(npc_identif, "spin")
	
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
	player_lock.emit(false)
	play_animation.emit(char.Player, "walk_back")
	move_char.emit(char.Player, running, rout)
	
	await _movement_done(char.Player)
	play_animation.emit(char.Player, "idle_back")
	player_lock.emit(true)
	
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
	coffee_cup.emit(false)
	
	text_id = "explicacafe4"
	text.emit(text_id)
	
	await text_finished
	
	running = false
	rout = [Vector2(-81.0, 0.0)]
	
	play_animation.emit(npc_identif, "stop")
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	running = false
	rout = [Vector2(0.0, 6.0), Vector2(0.0, -6.0)]
	
	play_animation.emit(npc_identif, "walk_front")
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	play_animation.emit(npc_identif, "idle_front")
	await get_tree().create_timer(0.5).timeout 
	
	player_lock.emit(false)
	play_animation.emit(char.Player, "stop")
	
	running = false
	rout = [Vector2(-27.0,0.0), Vector2(0.0,6.0)]
	
	play_animation.emit(npc_identif, "stop")
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	play_animation.emit(npc_identif, "spin")
	
	animated_characters.erase(npc_identif)


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
	
	var running := true
	var rout: Array[Vector2] = [Vector2(16.0,0.0)]
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	var text_id := "PrisonDead" # es solo un efecto de sonido que estoy reutilizando
	text.emit(text_id)
	
	running = false
	rout = [Vector2(16.0,0.0)]
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	player_lock.emit(true)
	
	await get_tree().create_timer(1.0).timeout
	
	var player_pos := await find_char_position(npc_identif)
	
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

func open_blackroom_door_2():
	
	var npc_identif := char.Waifu
	
	if animated_characters.has(npc_identif):
		push_warning("there is an animation playing: ", npc_identif)
		return
	if not npc_conected(npc_identif):
		push_warning("npc not conected: ", npc_identif)
		return
	
	animated_characters.append(npc_identif)
	
	open_door.emit("door_black_room")
	
	await get_tree().create_timer(0.5).timeout
	
	var text_id := "segundotest"
	text.emit(text_id)
	
	await text_finished
	
	Gamestate.current_mision = Gamestate.mision.BLACKROOM_2
	player_lock.emit(false)
	play_animation.emit(char.Player, "stop")
	
	var running := false
	var rout: Array[Vector2] = [Vector2(0.0, 24.0), Vector2(120.0, 0.0), Vector2(0.0, -112.0)]
	
	move_char.emit(npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	play_animation.emit(npc_identif, "spin")
	
	animated_characters.erase(npc_identif)
