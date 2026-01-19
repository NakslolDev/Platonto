extends Node

signal text(String)
signal player_lock(lock: bool)
signal text_finished
signal player_push_back


enum char {Player, Waifu, Scientist, General, Militar01, Militar02, Militar03, Prisoner01}

signal load_character(char, position: String)
signal unload_character(char)
signal change_room(char, to_room: String, position: String)

signal move_char(char, runing: bool, rout: Array[Vector2])
signal movement_done(char)
signal play_animation(char, String)

var animated_characters: Array[char]

var lock_cam := false
var displace_cam := Vector2.ZERO
var static_cam := Vector2.ZERO

func show_text(id: String):
	emit_signal("text", id)

func freeze_player_ff():
	emit_signal("player_lock", true)

func unfreeze_player_ff():
	emit_signal("player_lock", false)

func text_freeze_player_ff():
	emit_signal("player_lock", true)
	await self.text_finished
	emit_signal("player_lock", false)

func player_push_back_ff():
	emit_signal("player_push_back")


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
		return
	if not npc_conected(npc_identif):
		return
	
	animated_characters.append(npc_identif)
	
	emit_signal("play_animation", npc_identif, "stop")
	
	var running := false
	var rout: Array[Vector2] = [Vector2(100,0), Vector2(0, 3), Vector2(0,-6), Vector2(0,3)]
	
	emit_signal("move_char", npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	var animation := "spin"
	emit_signal("play_animation", npc_identif, animation)
	
	var wait_time := 3.0
	await get_tree().create_timer(wait_time).timeout
	
	rout = [Vector2(-100,0)]
	
	emit_signal("play_animation", npc_identif, "stop")
	emit_signal("move_char", npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	animation = "spin"
	emit_signal("play_animation", npc_identif, animation)
	
	animated_characters.erase(npc_identif)

func player_test_ff():
	
	var npc_identif := char.Player
	
	if animated_characters.has(npc_identif):
		return
	if not npc_conected(npc_identif):
		return
	
	animated_characters.append(npc_identif)
	
	emit_signal("play_animation", npc_identif, "stop")
	
	var running := false
	var rout: Array[Vector2] = [Vector2(100,0)]
	
	emit_signal("move_char", npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	var animation := "spin"
	emit_signal("play_animation", npc_identif, animation)
	emit_signal("player_lock", true)
	
	var wait_time := 3.0
	await get_tree().create_timer(wait_time).timeout
	
	emit_signal("player_lock", false)
	
	rout = [Vector2(-100,0)]
	
	emit_signal("play_animation", npc_identif, "stop")
	emit_signal("move_char", npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	animated_characters.erase(npc_identif)

func waifu_go_to_testhall_debug_ff():
	var npc_identif := char.Waifu
	
	if animated_characters.has(npc_identif):
		return
	if not npc_conected(npc_identif):
		return
	
	emit_signal("play_animation", npc_identif, "stop")
	animated_characters.append(npc_identif)
	
	var running := true
	var rout: Array[Vector2] = [Vector2(-13.0, 0.0), Vector2(0.0, 160.0)] 
	
	emit_signal("move_char", npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	var wait_time := 0.5
	await get_tree().create_timer(wait_time).timeout
	
	var new_room := "TestHall"
	var position := "Default"
	emit_signal("change_room", npc_identif, new_room, position, "none")
	
	animated_characters.erase(npc_identif)

func spawn_waifu_debug_ff():
	
	Gamestate.waifudebugin = true
	
	var npc_identif := char.Waifu
	var spawnpoint := "WaifuPoint01"
	emit_signal("load_character", npc_identif, spawnpoint)

func despawn_waifu_debug_ff():
	
	Gamestate.waifudebugin = false
	
	var npc_identif := char.Waifu
	emit_signal("unload_character", npc_identif)

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
	emit_signal("load_character", npc_identif, spawnpoint)
	
	var running := false
	var rout: Array[Vector2] = [Vector2(370, 0.0), Vector2(0.0, -10.0)] 
	
	emit_signal("move_char", npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	var wait_time := 1.0
	await get_tree().create_timer(wait_time).timeout
	
	var text_id := "Prison1"
	emit_signal("text", text_id)
	
	await text_finished
	
	running = false
	rout = [Vector2(0.0, 10.0), Vector2(180, 0.0), Vector2(0.0, -10.0)] 
	
	emit_signal("move_char", npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	wait_time = 1.0
	await get_tree().create_timer(wait_time).timeout
	
	text_id = "Prison2"
	emit_signal("text", text_id)
	
	await text_finished
	
	wait_time = 0.5
	await get_tree().create_timer(wait_time).timeout
	
	running = false
	rout = [Vector2(0.0, 10.0), Vector2(30, 0.0)] 
	
	emit_signal("move_char", npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	text_id = "PrisonDead"
	emit_signal("text", text_id)
	
	await text_finished
	
	running = true
	rout = [Vector2(150, 0.0), Vector2(0, 5.0)] 
	
	emit_signal("move_char", npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	await text_finished
	
	wait_time = 0.5
	await get_tree().create_timer(wait_time).timeout
	
	running = false
	rout = [Vector2(-150, 0.0)] 
	
	emit_signal("move_char", npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	wait_time = 0.5
	await get_tree().create_timer(wait_time).timeout
	
	text_id = "PrisonDead3"
	emit_signal("text", text_id)
	
	await text_finished
	
	wait_time = 1.2
	await get_tree().create_timer(wait_time).timeout
	
	running = false
	rout = [Vector2(-86.0, 0.0), Vector2(0.1, 0.0)] 
	
	emit_signal("move_char", npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	animated_characters.erase(npc_identif)

func first_anim_scientist():
	
	var npc_identif := char.Scientist
	
	animated_characters.append(npc_identif)
	
	var spawnpoint := "ScientistPrison"
	emit_signal("load_character", npc_identif, spawnpoint)
	
	var running := false
	var rout: Array[Vector2] = [Vector2(370, 0.0), Vector2(0.0, -10.0)] 
	
	emit_signal("move_char", npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	await text_finished
	
	running = false
	rout = [Vector2(0.0, 10.0), Vector2(165, 0.0), Vector2(0.0, -10.0)] 
	
	emit_signal("move_char", npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	await text_finished
	
	var wait_time = 0.5
	await get_tree().create_timer(wait_time).timeout
	
	running = false
	rout = [Vector2(0.0, 10.0), Vector2(40, 0.0)] 
	
	emit_signal("move_char", npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	await text_finished
	
	await text_finished
	
	await text_finished
	
	running = false
	rout = [Vector2(-80.0, 0.0), Vector2(0.0, -20.0)] 
	
	emit_signal("move_char", npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	wait_time = 0.5
	await get_tree().create_timer(wait_time).timeout
	
	var animation := "spin"
	emit_signal("play_animation", npc_identif, animation)
	
	wait_time = 1.5
	await get_tree().create_timer(wait_time).timeout
	
	animation = "stop"
	emit_signal("play_animation", npc_identif, animation)
	
	wait_time = 0.5
	await get_tree().create_timer(wait_time).timeout
	
	emit_signal("open_gate", 2)
	Gamestate.current_mision = Gamestate.mision.FOLLOW_SCIENTIST
	lock_cam = false
	
	animated_characters.erase(npc_identif)

func first_anim_general():
	
	var npc_identif := char.General
	
	animated_characters.append(npc_identif)
	
	var spawnpoint := "GeneralPrison"
	emit_signal("load_character", npc_identif, spawnpoint)
	
	var running := false
	var rout: Array[Vector2] = [Vector2(370, 0.0), Vector2(0.0, -10.0)] 
	
	emit_signal("move_char", npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	await text_finished
	
	var wait_time := 0.3
	await get_tree().create_timer(wait_time).timeout
	
	running = false
	rout = [Vector2(0.0, 10.0), Vector2(175, 0.0), Vector2(0.0, -15.0)] 
	
	emit_signal("move_char", npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	await text_finished
	
	wait_time = 1.3
	await get_tree().create_timer(wait_time).timeout
	
	running = false
	rout = [Vector2(0.0, 15.0), Vector2(30, 0.0)] 
	
	emit_signal("move_char", npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	wait_time = 2.0
	await get_tree().create_timer(wait_time).timeout
	
	var text_id := "PrisonDead2"
	emit_signal("text", text_id)
	
	await text_finished
	
	await text_finished
	
	wait_time = 0.3
	await get_tree().create_timer(wait_time).timeout
	
	running = false
	rout = [Vector2(0.0, 10.0), Vector2(30.0, 0.0), Vector2(0.0, -10.0), Vector2(-0.1, 0.0)] 
	
	emit_signal("move_char", npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	animated_characters.erase(npc_identif)

func first_anim_militar1():
	
	var npc_identif := char.Militar01
	
	animated_characters.append(npc_identif)
	
	var spawnpoint := "Mili1Prison"
	emit_signal("load_character", npc_identif, spawnpoint)
	
	var running := false
	var rout: Array[Vector2] = [Vector2(370, 0.0), Vector2(0.0, -10.0)] 
	
	emit_signal("move_char", npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	await text_finished
	
	var wait_time := 0.2
	await get_tree().create_timer(wait_time).timeout
	
	running = false
	rout = [Vector2(0.0, 10.0), Vector2(175, 0.0), Vector2(0.0, -10.0)] 
	
	emit_signal("move_char", npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	await text_finished
	
	wait_time = 0.4
	await get_tree().create_timer(wait_time).timeout
	
	running = false
	rout = [Vector2(0.0, 10.0), Vector2(40, 0.0)] 
	
	emit_signal("move_char", npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	await text_finished
	
	await text_finished
	
	running = true
	rout = [Vector2(150, 0.0)] 
	
	emit_signal("move_char", npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	emit_signal("unload_character", npc_identif)
	
	animated_characters.erase(npc_identif)

func first_anim_militar2():
	
	var npc_identif := char.Militar02
	
	animated_characters.append(npc_identif)
	
	var spawnpoint := "Mili2Prison"
	emit_signal("load_character", npc_identif, spawnpoint)
	
	var running := false
	var rout: Array[Vector2] = [Vector2(370, 0.0), Vector2(0.0, -10.0)] 
	
	emit_signal("move_char", npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	await text_finished
	
	var wait_time := 0.1
	await get_tree().create_timer(wait_time).timeout
	
	running = false
	rout = [Vector2(0.0, 10.0), Vector2(175, 0.0), Vector2(0.0, -10.0)] 
	
	emit_signal("move_char", npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	await text_finished
	
	wait_time = 0.6
	await get_tree().create_timer(wait_time).timeout
	
	running = false
	rout = [Vector2(0.0, 10.0), Vector2(40, 0.0)] 
	
	emit_signal("move_char", npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	await text_finished
	
	await text_finished
	
	running = true
	rout = [Vector2(150, 0.0)] 
	
	emit_signal("move_char", npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	emit_signal("unload_character", npc_identif)
	
	animated_characters.erase(npc_identif)


func follow_waifu_ff():
	
	var npc_identif := char.Waifu
	
	if animated_characters.has(npc_identif):
		return
	if not npc_conected(npc_identif):
		return
	
	Gamestate.wait_before_trans = true
	
	animated_characters.append(npc_identif)
	
	await text_finished
	
	var running := false
	var rout: Array[Vector2] = [Vector2(-496, 0.0)] 
	
	emit_signal("move_char", npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	animated_characters.erase(npc_identif)

func follow_waifu_2_ff():
	
	var npc_identif := char.Waifu
	
	while animated_characters.has(npc_identif):
		await get_tree().process_frame # esto es guarro, pero no tengo tiempo para pulirlo
	if not npc_conected(npc_identif):
		return
	
	animated_characters.append(npc_identif)
	
	var running := false
	var rout: Array[Vector2] = [Vector2(0.0, -90.0)] 
	
	emit_signal("move_char", npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	var wait_time := 0.5
	await get_tree().create_timer(wait_time).timeout
	
	var door_id := "prison_door"
	emit_signal("open_door", door_id)
	
	await get_tree().create_timer(wait_time).timeout
	
	running = false
	rout = [Vector2(0.0, -8.0)] 
	
	emit_signal("move_char", npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	var new_room := "MainHall"
	var position := "Waifu1"
	emit_signal("change_room", npc_identif, new_room, position, "none")
	
	Gamestate.wait_before_trans = false
	
	animated_characters.erase(npc_identif)

func enter_black_room_first_ff():
	
	var npc_identif := char.Waifu
	
	if animated_characters.has(npc_identif):
		return
	if not npc_conected(npc_identif):
		return
	
	animated_characters.append(npc_identif)
	
	emit_signal("player_lock", true)
	displace_cam = Vector2(0.0, -32.0)
	
	var running := false
	var rout: Array[Vector2] = [Vector2(-120, 0.0), Vector2(0.0, -40.0)] 
	
	emit_signal("move_char", npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	await get_tree().create_timer(1.0).timeout
	
	var text_id := "BlackRoomHere"
	emit_signal("text", text_id)
	
	await text_finished
	
	var door := "door_black_room"
	emit_signal("open_door", door)
	
	await get_tree().create_timer(1.0).timeout
	
	running = false
	rout = [Vector2(0.0, 32.0), Vector2(120, 0.0), Vector2(0.0, 16.0)] 
	
	emit_signal("move_char", npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	text_id = "BlackRoomThere"
	emit_signal("text", text_id)
	
	await text_finished
	
	running = false
	rout = [Vector2(0.0, -144.0)] 
	
	emit_signal("move_char", npc_identif, running, rout)
	await _movement_done(npc_identif)
	
	emit_signal("player_lock", false)
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
func explain_yellow_mellow():
	
	var text_id := "empezartest2"
	emit_signal("text", text_id)
	
	await text_finished
	await get_tree().create_timer(1.0).timeout
	continue_test.emit()
