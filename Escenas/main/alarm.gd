extends Sprite2D

var cicle_up := true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Actions.alarm.connect(_on)
	Actions.gun.connect(_off)
	visible = false


func _on():
	visible = true

func _off():
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not visible: return
	
	if cicle_up:
		modulate.a += delta * 0.1
		if modulate.a > 0.3:
			cicle_up = false
	else:
		modulate.a -= delta * 0.1
		if modulate.a < 0.2:
			cicle_up = true
