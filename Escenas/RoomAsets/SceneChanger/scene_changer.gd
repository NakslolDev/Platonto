extends Area2D

@export var to_scene: String

@onready var root_node = get_tree().get_current_scene()

func _on_area_entered(area: Area2D) -> void:
	if area.name == "PlayerDetect":
		call_deferred("_change_room_deferred", to_scene)

func _change_room_deferred(room_name: String) -> void:
	root_node.change_room(room_name)
