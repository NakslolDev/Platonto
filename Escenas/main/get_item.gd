extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Actions.get_item.connect(_play)

func _play():
	play()
