extends Sprite2D

const FADE_DURATION := 0.5

func _ready():
	modulate.a = 0.0
	visible = true

func fade_in():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, FADE_DURATION)
	return tween.finished  # permite usar await

func fade_out():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, FADE_DURATION)
	return tween.finished  # permite usar await
