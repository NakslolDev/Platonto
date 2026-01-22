extends Area2D

@onready var parent: Node2D = get_parent()
@export var only_color := false
@export var change_color := false
var changed := false
var player_in := false

func _ready():
	self.body_entered.connect(_entered)
	self.body_exited.connect(_exited)
	if parent.name.ends_with("2"):
		parent.check_color.connect(_check_color)

func _entered(body: Node2D):
	if only_color: return
	if not body.name.begins_with("Player"): return
	
	player_in = true
	
	if change_color:
		if not visible: return
		parent.on.erase(int(self.name))
		if not changed:
			modulate.g = 0
			changed = true
		return
	
	parent.on.append(int(self.name))

func _exited(body: Node2D):
	if only_color: return
	if not body.name.begins_with("Player"): return
	
	player_in = false
	
	if change_color:
		if not visible: return
		parent.on.append(int(self.name))
		return
	
	parent.on.erase(int(self.name))

func _check_color():
	if change_color and player_in:
		if not visible: return
		parent.on.erase(int(self.name))
		if not changed:
			modulate.g = 0
			changed = true
		return
