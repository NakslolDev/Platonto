extends Sprite2D

var player: CharacterBody2D
@export var ground: TileMapLayer

func _ready() -> void:
	player = get_tree().current_scene.player
	ground.visible = true

func _physics_process(_delta: float) -> void:
	position = player.position
