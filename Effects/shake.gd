@tool
extends RichTextEffect
class_name ShakeEffect

@export var persistant_offset := false
@export var range_x: float = 3.0
@export var range_y: float = 3.0
@export var intensity: float = 0.2
@export var bbcode: String = "abs_shake"

var rng := RandomNumberGenerator.new()
var offsets := {} # diccionario: char_index -> Vector2

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var idx := char_fx.range.x
	
	# inicializamos el offset si no existe
	if not offsets.has(idx):
		offsets[idx] = Vector2.ZERO
	
	rng.seed = int(idx * 1000 + int(Time.get_ticks_msec()))
	# probabilidad de saltar
	if rng.randf() < intensity:
		offsets[idx] = Vector2(rng.randf_range(-range_x, range_x),
							   rng.randf_range(-range_y, range_y))
	elif not persistant_offset:
		offsets[idx] = Vector2.ZERO
	
	# aplicamos el offset “persistente”
	char_fx.offset += offsets[idx]
	return true
