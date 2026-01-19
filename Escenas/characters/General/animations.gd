extends AnimatedSprite2D

@export var root: Node

enum dir { FRONT, BACK, LEFT, RIGHT }
var direction: dir = dir.FRONT

func _process(_delta: float) -> void:
	if root.animation_running:
		return
	if root.moving:
		calc_dir()
	else:
		play_idle()

func calc_dir():
	var movement: Vector2 = root.movement
	
	# Quieto
	if movement == Vector2.ZERO:
		play_idle()
		return
	
	# Movimiento recto
	if abs(movement.x) > abs(movement.y):
		direction = dir.RIGHT if movement.x > 0 else dir.LEFT
	else:
		direction = dir.FRONT if movement.y > 0 else dir.BACK
	
	play_walk()

func play_idle():
	speed_scale = 1.0
	match direction:
		dir.FRONT:
			play("idle_front")
		dir.BACK:
			play("idle_back")
		dir.LEFT:
			play("idle_left")
		dir.RIGHT:
			play("idle_right")

func play_walk():
	speed_scale = 1.5 if Input.is_action_pressed("run") else 1.0
	
	match direction:
		dir.FRONT:
			play("walk_front")
		dir.BACK:
			play("walk_back")
		dir.LEFT:
			play("walk_left")
		dir.RIGHT:
			play("walk_right")
