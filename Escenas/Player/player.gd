extends CharacterBody2D

var lock_movement := false

const SPEED = 50.0
const RUNMULT = 2.0

var movement: Vector2

func _physics_process(_delta: float) -> void:
	
	if lock_movement:
		return
	
	movement = Input.get_vector("A", "D", "W", "S")
	
	if abs(movement.x) > 0.0 and abs(movement.y) > 0.0:
		movement *= 1.2
	
	var current_speed := SPEED
	if Input.is_action_pressed("run"):
		current_speed *= RUNMULT
	
	velocity = movement * current_speed
	move_and_slide()
