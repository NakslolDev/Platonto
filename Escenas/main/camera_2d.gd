extends Camera2D

@export var player: CharacterBody2D

@export var radius := 2.0
@export var speed := 5.0

@export var chat_gpt := false

var internal_cam_locked := false

func _ready():
	for child in get_children():
		child.visible = true

func locate():
	position = player.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	if Actions.lock_cam:
		return
	
	position -= Actions.displace_cam
	
	var target: Vector2
	
	if Actions.static_cam != Vector2.ZERO:
		target = Actions.static_cam
	else:
		target = player.position
	
	if target.x < position.x - radius:
		position.x -= delta * speed * absf(target.x - (position.x - radius))
	if target.x > position.x + radius:
		position.x += delta * speed * absf(target.x - (position.x + radius))
	
	if target.y < position.y - radius:
		position.y -= delta * speed * absf(target.y - (position.y - radius))
	if target.y > position.y + radius:
		position.y += delta * speed * absf(target.y - (position.y + radius))
	
	position += Actions.displace_cam
