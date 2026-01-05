extends Node

signal text(String)
signal player_lock(lock: bool)
signal text_finished
signal player_push_back

func show_text(id: String):
	emit_signal("text", id)

func freeze_player_ff():
	emit_signal("player_lock", true)

func unfreeze_player_ff():
	emit_signal("player_lock", false)

func text_freeze_player_ff():
	emit_signal("player_lock", true)
	print("hola")
	await text_finished
	print("chao")
	emit_signal("player_lock", false)

func player_push_back_ff():
	emit_signal("player_push_back")
