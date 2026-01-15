extends CharacterBody2D

@export var identifier: Actions.char
@export var animation: AnimatedSprite2D

signal vector_reached

var lock_movement := false

var automoving := false
var autorunning := false
var starting_pos: Vector2
var desplazamiento: Vector2

var animation_running := false

const SPEED = 50.0
const RUNMULT = 1.5

var movement: Vector2

func _ready() -> void:
	Actions.player_lock.connect(self._player_lock)
	Actions.player_push_back.connect(self._player_push_back)
	Actions.move_char.connect(self._move)
	Actions.play_animation.connect(self._animation)

func _physics_process(_delta: float) -> void:
	
	if lock_movement:
		return
	
	if not automoving:
		movement = Input.get_vector("A", "D", "W", "S")
		
		if abs(movement.x) > 0.0 and abs(movement.y) > 0.0:
			movement *= 1.2
	
	var current_speed := SPEED
	if (Input.is_action_pressed("run") and not automoving) or autorunning:
		current_speed *= RUNMULT
	
	velocity = movement * current_speed
	move_and_slide()
	
	if automoving and (abs(position.x - starting_pos.x) >= abs(desplazamiento.x) and abs(movement.x) > 0.5) or (abs(position.y - starting_pos.y) >= abs(desplazamiento.y) and abs(movement.y) > 0.5):
		automoving = false # me aseguro de que solo se emita 1 vez
		emit_signal("vector_reached")

func _move(character: Actions.char, run: bool, rout: Array[Vector2]):
	
	if character != identifier:	
		return
	
	autorunning = run
	
	for vector in rout:
		
		starting_pos = position
		desplazamiento = vector
		movement = get_movement(vector)
		
		automoving = true
		
		await self.vector_reached
	
	movement = Vector2.ZERO # capa extra de seguridad
	
	Actions.emit_signal("movement_done", identifier)

func get_movement(vector: Vector2) -> Vector2:
	
	if vector.x * vector.y != 0: # Hace que no se pueda desplazar en diagonal
		vector.y = 0 # en caso de, elimina el componente y
	
	return vector.normalized()

func _animation(character: Actions.char, animname: String):
	
	if character != identifier:	
		return
	
	if animname == "stop":
		animation_running = false
	else:
		animation_running = true
		animation.play(animname)


func _player_lock(lock: bool):
	lock_movement = lock

func _player_push_back():
	
	var current_speed := SPEED
	if Input.is_action_pressed("run"):
		current_speed *= RUNMULT
	
	velocity = movement * current_speed * -1
	move_and_slide()
