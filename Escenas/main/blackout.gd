extends Sprite2D

var on := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Actions.blackout.connect(_activate)
	Actions.blackin.connect(_deactivate)
	Actions.gun.connect(_instant)
	modulate.a = 0.0
	visible = true

func _activate():
	on = true

func _deactivate():
	on = false

func _process(delta: float) -> void:
	if on:
		if modulate.a < 1.0:
			modulate.a += delta * 0.3
	else:
		if modulate.a > 0.0:
			modulate.a -= delta * 0.3

func _instant():
	modulate.a = 1.0
	on = true
