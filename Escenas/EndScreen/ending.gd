extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	Actions.change_font.emit(true)
	
	await get_tree().create_timer(4.0).timeout
	
	if Gamestate.ending == Gamestate.end.EXIT:
		Actions.text.emit("exit_ending")
	
	if Gamestate.ending == Gamestate.end.PRISON:
		await get_tree().create_timer(3.0).timeout
		Actions.text.emit("prison_ending")
	
	if Gamestate.ending == Gamestate.end.DRUGS:
		Actions.text.emit("drugs_ending")
	
	await Actions.text_finished
