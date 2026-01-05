extends Area2D

@export var to_scene: String
@export var interactable := false

var player_in := false

@onready var root_node = get_tree().get_current_scene()

func _on_area_entered(area: Area2D) -> void:
	if area.name == "PlayerDetect":
		if interactable:
			player_in = true
		else:
			call_deferred("_change_room_deferred", to_scene)

func _on_area_exited(area: Area2D) -> void:
	if area.name == "PlayerDetect":
		player_in = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and interactable and player_in:
		call_deferred("_change_room_deferred", to_scene)


func _change_room_deferred(room_name: String) -> void:
	root_node.change_room(room_name)
