@tool
extends RichTextEffect
class_name WaveEffect

@export var speed: float = 6.0
@export var separation: float = 0.5
@export var amplitude: float = 4.0
@export var bbcode: String = "abs_wave"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var t := Time.get_ticks_msec() * 0.001
	char_fx.offset.y += sin(t * speed + char_fx.range.x * separation) * amplitude
	return true
