extends Node

func _ready() -> void:
	if get_tree().current_scene.last_room != "WaifuRoom": return
	
	Actions.play_animation.emit(Actions.char.Player, "idle_front")

func func_ready():
	if get_tree().current_scene.last_room != "WaifuRoom": return
	
	while Input.get_vector("A", "D", "W", "S") == Vector2.ZERO:
		await get_tree().process_frame
	
	Actions.play_animation.emit(Actions.char.Player, "stop")
