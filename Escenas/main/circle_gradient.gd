extends Sprite2D

var on := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Actions.activate_headache.connect(_activate)
	Actions.deactivate_headache.connect(_deactivate)
	modulate.a = 0.0
	visible = true

func _activate():
	on = true

func _deactivate():
	on = false

func _process(delta: float) -> void:
	if on:
		if modulate.a < 1.0:
			modulate.a += delta * 0.1
		if scale > 0.1 * Vector2.ONE:
			scale += -0.1 * Vector2.ONE * delta 
	else:
		if modulate.a > 0.0:
			modulate.a -= delta * 0.1
		if scale < 0.5 * Vector2.ONE:
			scale += 0.1 * Vector2.ONE * delta
