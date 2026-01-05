extends Node

@export var rooms: Array[PackedScene]
var current_room_instance: Node

var current_room: String
var last_room: String

var rooms_index := {
	"Debug": 0,
	"TestHall": 1,
}


@export var player: CharacterBody2D
@export var transition: Node
@export var camera: Camera2D

func _ready():
	change_room("Debug")

func change_room(room: String):
	
	last_room = current_room
	current_room = room
	
	logic_change(false)
	
	await transition.fade_in()
	load_room(rooms_index[room])
	locate_player()
	get_player_to_ysort()
	await transition.fade_out()
	
	logic_change(true)

func load_room(index: int) -> void:
	
	print(current_room, " <- ", last_room)
	
	if current_room_instance:
		current_room_instance.queue_free()
		
	current_room_instance = rooms[index].instantiate()
	add_child(current_room_instance)

func get_player_to_ysort():
	player.get_parent().remove_child(player)
	var new_parent = current_room_instance.get_node("YSort")
	new_parent.add_child(player)

func locate_player():
	
	var spawns := current_room_instance.get_node("SpawnPoints")
	if spawns.has_node(last_room):
		player.global_position = spawns.get_node(last_room).global_position
	else:
		player.global_position = spawns.get_node("default").global_position
	camera.locate()

func logic_change(trans_ended: bool):
	player.lock_movement = !trans_ended
