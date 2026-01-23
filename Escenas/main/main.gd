extends Node

@export var first_room := "Prison"

@export var rooms: Array[PackedScene]
var current_room_instance: Node

var current_room: String
var last_room: String
var changing_room := false

var rooms_index := {
	"Debug": 0,
	"TestHall": 1,
	"Prison": 2,
	"MainHall": 3,
	"BlackRoom": 4,
	"Lab": 5,
	"Cafe": 6,
	"Rooms": 7,
	"WaifuRoom": 8,
	"Exit": 9,
}

@export var character: Array[PackedScene]
var current_characters: Array
var off_scene_characters: Dictionary

func resize_current_characters():
	for i in Actions.char.size():
		current_characters.append(null)

@export var player: CharacterBody2D
@export var transition: Node
@export var camera: Camera2D

func _ready():
	Actions.load_character.connect(_load_char)
	Actions.unload_character.connect(_unload_char)
	Actions.change_room.connect(_change_room_char)
	resize_current_characters()
	change_room(first_room)

func change_room(room: String):
	
	if changing_room:
		push_warning("already changing rooms")
		return
	
	last_room = current_room
	current_room = room
	
	logic_change(false)
	
	await transition.fade_in()
	
	unload_characters()
	load_room(rooms_index[room])
	locate_player()
	get_player_to_ysort()
	load_offscene_characters()
	
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
	changing_room = !trans_ended
	if trans_ended:
		var node_ready = current_room_instance.get_node_or_null("NodeReady")
		if node_ready != null:
			node_ready.func_ready()


func _load_char(_char: Actions.char, position, animation: StringName = "none"):
	
	if current_characters[_char] != null:
		push_warning("character ", _char, " already instanciated")
		return
	
	var inst_char = character[_char].instantiate()
	add_child(inst_char)
	current_characters[_char] = inst_char
	
	inst_char.get_parent().remove_child(inst_char)
	var new_parent = current_room_instance.get_node("YSort")
	new_parent.add_child(inst_char)
	
	if position is String:
		var spawns := current_room_instance.get_node("SpawnPoints")
		if spawns.has_node(position):
			inst_char.global_position = spawns.get_node(position).global_position
		else:
			inst_char.global_position = spawns.get_node("default").global_position
	elif position is Vector2:
		inst_char.global_position = position
	
	if animation != "none":
		inst_char.animation_running = true
		inst_char.animation.play(animation)

func _unload_char(_char: Actions.char):
	if current_characters[_char] == null:
		push_warning("Character ", _char, " not in scene")
		return
	
	Actions.unload_char(_char)
	
	current_characters[_char].queue_free()


func unload_characters():
	for chara in Actions.char.values():
		if current_characters[chara] == null: continue
		
		off_scene_characters[chara] = {
			"scene": last_room,
			"position": current_characters[chara].position,
			"animation": current_characters[chara].animation.animation
		}
		
		_unload_char(chara)

func _change_room_char(_char: Actions.char, room: String, position: String, animation: String):
	if current_characters[_char] == null: return
		
	off_scene_characters[_char] = {
		"scene": room,
		"position": position,
		"animation": animation
	}
	
	_unload_char(_char)

func load_offscene_characters():
	var keys := off_scene_characters.keys()
	for chara in keys:
		if off_scene_characters[chara]["scene"] != current_room: continue
		
		var character_position = off_scene_characters[chara]["position"]
		var character_animation = off_scene_characters[chara]["animation"]
		_load_char(chara, character_position, character_animation)
		
		off_scene_characters.erase(chara)
	print(off_scene_characters)
