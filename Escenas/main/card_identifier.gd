extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Actions.card_accepted.connect(_play)

func _play():
	play()
