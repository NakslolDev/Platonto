@tool
extends RichTextEffect
class_name FadeEffect

@export var speed: float = 3.0
@export var separation: float = 0.2
@export var min_alpha: float = 0.1
@export var max_alpha: float = 1.0
@export var bbcode: String = "abs_fade"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var t := Time.get_ticks_msec() * 0.001
	var phase := float(char_fx.range.x) * separation
	var alpha := (min_alpha + max_alpha) * 0.5 + (max_alpha - min_alpha) * 0.5 * sin(t * speed + phase)
	char_fx.color.a *= clamp(alpha, 0.0, 1.0)
	return true
