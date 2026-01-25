extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Actions.alarm.connect(_play)
	Actions.gun.connect(_stop)

func _play():
	play()

func _stop():
	stop()
