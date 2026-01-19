extends Area2D

@onready var parent: Node2D = get_parent()
@export var only_color := false

func _ready():
	self.body_entered.connect(_entered)
	self.body_exited.connect(_exited)

func _entered(body: Node2D):
	if only_color: return
	if not body.name.begins_with("Player"): return
	parent.on = int(self.name)

func _exited(body: Node2D):
	if only_color: return
	if not body.name.begins_with("Player"): return
	parent.on = 0
