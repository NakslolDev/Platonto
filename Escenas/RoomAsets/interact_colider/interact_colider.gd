extends Area2D

@export var actions: Array[HitboxEvent]
@export var text_id: String
@export var auto := false

@export var game_state: Array[GameVariables]
@export var mision := Gamestate.mision.ALL

var player_in := false
var active: bool

func _ready() -> void:
	check_active()

func _on_area_entered(area: Area2D) -> void:
	if area.name == "PlayerDetect":
		player_in = true
		if auto:
			activate()

func _on_area_exited(area: Area2D) -> void:
	if area.name == "PlayerDetect":
		player_in = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and not auto and player_in:
		activate()

func activate():
	
	if not active:
		return
	
	for event in actions:
		event.execute()
	
	if text_id != "":
		Actions.show_text(text_id)

func check_active():
	
	active = true
	
	if mision != Gamestate.mision.ALL and mision != Gamestate.current_mision:
		active = false
		return
	
	for item in game_state:
		
		var variable = Gamestate.get(item.name)
		
		if variable != null and variable != item.need:
			active = false
			return
