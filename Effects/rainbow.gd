@tool
extends RichTextEffect
class_name RainbowEffect

@export var speed: float = 0.2
@export var separation: float = 0.3
@export var saturation: float = 1.0
@export var value: float = 1.0
@export var bbcode: String = "abs_rainbow"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var t := Time.get_ticks_msec() * 0.001
	var phase := float(char_fx.range.x) * separation
	var hue := fmod(t * speed + phase, 1.0)
	char_fx.color = Color.from_hsv(hue, saturation, value, char_fx.color.a)
	return true
