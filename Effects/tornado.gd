@tool
extends RichTextEffect
class_name TornadoEffect

@export var speed: float = 5.0
@export var separation: float = 0.4
@export var amplitude_x: float = 5.0
@export var amplitude_y: float = 3.0
@export var bbcode: String = "abs_tornado"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var t := Time.get_ticks_msec() * 0.001
	var phase := float(char_fx.range.x) * separation
	char_fx.offset.x += sin(t * speed + phase) * amplitude_x
	char_fx.offset.y += cos(t * speed + phase) * amplitude_y
	return true
