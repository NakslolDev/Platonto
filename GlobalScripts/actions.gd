extends Node

signal text(String)
signal player_lock(lock: bool)
signal text_finished
signal player_push_back

enum char {Waifu, Scientific, Prisoner01, General, Militar01}

signal load_character(char, position: String)
signal unload_character(char)

signal move_char(char, runing: bool, rout: Array[Vector2])
signal movement_done(char)
signal play_animation(char, String)

var animated_characters: Array[char]

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
	await self.movement_done
	
	var animation := "spin"
	emit_signal("play_animation", npc_identif, animation)
	
	var wait_time := 3.0
	await get_tree().create_timer(wait_time).timeout
	
	rout = [Vector2(-100,0)]
	
	emit_signal("play_animation", npc_identif, "stop")
	emit_signal("move_char", npc_identif, running, rout)
	await self.movement_done
	
	animation = "idle_front"
	emit_signal("play_animation", npc_identif, animation)
	
	animated_characters.erase(npc_identif)

func spawn_waifu_ff():
	
	var npc_identif := char.Waifu
	var spawnpoint := "WaifuPoint01"
	emit_signal("load_character", npc_identif, spawnpoint)

func despawn_waifu_ff():
	
	var npc_identif := char.Waifu
	emit_signal("unload_character", npc_identif)
