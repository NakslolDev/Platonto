extends AnimatedSprite2D

@export var root: Node

enum dir { FRONT, BACK, LEFT, RIGHT }
var direction: dir = dir.FRONT

var skins := {
	"a": preload("res://Sprites/MainChar/Player.tres"),
	"b": preload("res://Sprites/MainChar/ClothedPlayer.tres"),
}

func _ready():
	_change_outfit("a")
	Actions.change_outfit.connect(_change_outfit)

func _process(_delta: float) -> void:
	if root.animation_running:
		speed_scale = 1.0
		return
	calc_dir()

func calc_dir():
	var movement: Vector2 = root.movement
	var stopped: bool = root.lock_movement and not root.automoving
	
	# Bloqueado
	if stopped:
		play_idle()
		return
	
	# Quieto
	if movement == Vector2.ZERO:
		play_idle()
		return
	
	var is_diagonal: bool = abs(movement.x) > 0 and abs(movement.y) > 0
	
	# Movimiento diagonal
	if is_diagonal:
		if not diagonal_is_compatible(movement):
			# Priorizar vertical
			if movement.y > 0:
				direction = dir.FRONT
			else:
				direction = dir.BACK
		
		play_walk()
		return
	
	# Movimiento recto
	if abs(movement.x) > abs(movement.y):
		direction = dir.RIGHT if movement.x > 0 else dir.LEFT
	else:
		direction = dir.FRONT if movement.y > 0 else dir.BACK
	
	play_walk()

func diagonal_is_compatible(movement: Vector2) -> bool:
	match direction:
		dir.FRONT:
			return movement.y > 0
		dir.BACK:
			return movement.y < 0
		dir.LEFT:
			return movement.x < 0
		dir.RIGHT:
			return movement.x > 0
	return false

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
	speed_scale = 1.5 if Input.is_action_pressed("run") and not root.automoving else 1.0
	
	match direction:
		dir.FRONT:
			play("walk_front")
		dir.BACK:
			play("walk_back")
		dir.LEFT:
			play("walk_left")
		dir.RIGHT:
			play("walk_right")


func _change_outfit(id: String):
	sprite_frames = skins[id]
	play("idle_front")
