extends Camera2D

@export var player: CharacterBody2D

@export var radius := 2.0
@export var speed := 5.0

@export var chat_gpt := false

func locate():
	position = player.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	if player.position.x < position.x - radius:
		position.x -= delta * speed * absf(player.position.x - (position.x - radius))
	if player.position.x > position.x + radius:
		position.x += delta * speed * absf(player.position.x - (position.x + radius))
	
	if player.position.y < position.y - radius:
		position.y -= delta * speed * absf(player.position.y - (position.y - radius))
	if player.position.y > position.y + radius:
		position.y += delta * speed * absf(player.position.y - (position.y + radius))
