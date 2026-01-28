extends CharacterBody2D

@export var identifier: Actions.char
@export var animation: AnimatedSprite2D

signal vector_reached

var moving := false
var stopped_for_idiot_player := false
var running := false
var starting_pos: Vector2
var desplazamiento: Vector2

var animation_running := false

const SPEED := 50.0
const RUNMULT := 1.5

var movement: Vector2

func _ready() -> void:
	Actions.move_char.connect(self._move)
	Actions.play_animation.connect(self._animation)
	Actions.get_char_position.connect(self._position)

func _physics_process(_delta: float) -> void:
	
	if not moving:
		velocity = Vector2.ZERO
		return
	
	if detect_player_ahead(movement):
		stopped_for_idiot_player = true
		velocity = Vector2.ZERO
		return
	else:
		stopped_for_idiot_player = false
	
	var current_speed := SPEED
	if running:
		current_speed *= RUNMULT
	
	velocity = movement * current_speed
	move_and_slide()
	
	if (abs(position.x - starting_pos.x) >= abs(desplazamiento.x) and abs(movement.x) > 0.5) or (abs(position.y - starting_pos.y) >= abs(desplazamiento.y) and abs(movement.y) > 0.5):
		moving = false # me aseguro de que solo se emita 1 vez
		emit_signal("vector_reached")

func _move(character: Actions.char, run: bool, rout: Array[Vector2]):
	
	#print("hola: ", character, run, rout)
	
	if character != identifier:	
		return
	
	running = run
	
	for vector in rout:
		
		starting_pos = position
		desplazamiento = vector
		movement = get_movement(vector)
		
		moving = true
		
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


func _position(character: Actions.char):
	if character != identifier: return
	Actions.return_position.emit(position)


func detect_player_ahead(motion: Vector2) -> bool:
	
	if Actions.animated_characters.has(Actions.char.Player): return false # si el jugador esta animado, aka no se mueve libremente
	
	var space := get_world_2d().direct_space_state
	var pos := global_position
	var length: float
	
	for iteration in [1, 0, -1]:
		
		var origin := pos
		
		if motion.x:
			origin.y += 2 * iteration
			length = 13.0
		else:
			origin.x += 7 * iteration
			length = 8.0
		
		var end := origin + motion * length
		
		var query := PhysicsRayQueryParameters2D.create(origin, end)
		query.exclude = [self]
		query.collision_mask = 1 << 0  # ejemplo
		
		var result := space.intersect_ray(query)
		
		if result:
			if str(result["collider"]).begins_with("Player"):
				return true
	
	return false
