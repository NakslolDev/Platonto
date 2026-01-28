extends AudioStreamPlayer2D

@export var character: CharacterBody2D

@export var walking_time := 0.4
@export var running_time := 0.3

@export var timer: Timer
var timer_playing := false

const RUNNING_LIMIT := 5000.0 # es un punto medio entre la velocidad andando y la velocidad corriendo, al cuadrado para hacer length squared, que es mas eficiente

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	var movement: Vector2 = character.velocity
	
	if movement == Vector2.ZERO: return
	
	if character.get("lock_movement"): return
	
	if timer_playing: return
	
	if movement.length_squared() >= RUNNING_LIMIT:
		timer.start(running_time)
	else:
		timer.start(walking_time)
	
	timer_playing = true
	
	play()


func _on_timer_timeout() -> void:
	timer_playing = false
