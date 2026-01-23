extends Node

func _ready() -> void:
	Actions.play_animation.emit(Actions.char.Player, "idle_right")

func func_ready():
	
	while Input.get_vector("A", "D", "W", "S") == Vector2.ZERO:
		await get_tree().process_frame
	
	Actions.play_animation.emit(Actions.char.Player, "stop")
