extends RichTextLabel

signal dialog_done

var done: bool
var active := false

enum sound {NEUTRAL, HIGH, HIGH2, MEDIUM, LOW, DISTORTED}
var sound_playing := sound.NEUTRAL

enum vol {NORMAL, QUIET, QUIETER}
var volume := vol.NORMAL

@export var Audios: Array[AudioStreamPlayer]
@export var extortion: AudioStreamPlayer

var auto: bool

func _ready():
	Actions.change_font.connect(_change_font)

func _change_font(normal: bool):
	if normal:
		var font: Font = load("res://Fuentes/NotEncripted.ttf")
		add_theme_font_override("normal_font", font)
	else:
		remove_theme_font_override("normal_font")


func print_text(dialog: String):
	
	text = dialog
	
	var text_lenght := calc_text_lenght()
	
	done = false
	
	visible_characters = 0
	
	sound_playing = sound.NEUTRAL
	
	if find_bracket(text, "high"):
		sound_playing = sound.HIGH
	if find_bracket(text, "high2"):
		sound_playing = sound.HIGH2
	if find_bracket(text, "medium"):
		sound_playing = sound.MEDIUM
	if find_bracket(text, "low"):
		sound_playing = sound.LOW
	if find_bracket(text, "distorted"):
		sound_playing = sound.DISTORTED
	
	volume = vol.NORMAL
	
	if find_bracket(text, "quiet"):
		volume = vol.QUIET
	if find_bracket(text, "quieter"):
		volume = vol.QUIETER
	
	auto = find_bracket(text, "auto")
	
	while visible_characters < text_lenght:
		
		
		var text_shown: String = text.substr(0, visible_characters)
		var last_char: String = text_shown[-1] if text_shown.length() > 0 else ""
		
		var time := calculate_time(last_char)
		
		await get_tree().create_timer(time).timeout
		
		active = true
		
		visible_characters += 1
		
		text_shown = text.substr(0, visible_characters)
		var current_char: String = text_shown[-1] if text_shown.length() > 0 else ""
		
		play_sound(current_char)
	
	done = true
	if find_bracket(text, "skip"):
		emit_signal("dialog_done")
		active = false
	elif find_bracket(text, "skip1"):
		await get_tree().create_timer(1.0).timeout
		emit_signal("dialog_done")
		active = false

func calculate_time(character: String) -> float:
	if character == ",":
		return 0.2
	if character == "." or character == "!" or character == "?":
		return 0.5
	return 0.05

func calc_text_lenght() -> int:
	var regex := RegEx.new()
	regex.compile("\\[[^\\]]*\\]") # “Un [ seguido de cualquier cantidad de caracteres que no sean ], seguido de un ]”
	
	var clean_text := regex.sub(text, "", true) # quita las coincidencias
	return clean_text.length()

func _input(event: InputEvent) -> void:
	if not active:
		return
	if event.is_action_pressed("interact"):
		if auto: return
		if done:
			if find_bracket(text, "skip1"): return
			emit_signal("dialog_done")
			active = false
		else:
			visible_characters = text.length()

func find_bracket(txt:String, label: String):
	var from := 0
	while true: # tiene que encontrar si hay sueltos. Elimina los que están cerrados
		if txt.find("[" + label + "]", from) == -1:
			return false
		if txt.find("[/" + label + "]", from) == -1:
			return true
		from = txt.find("[/" + label + "]", from) + ("[/" + label + "]").length()

func play_sound(current_char: String):
	if current_char == " " or current_char == ".":
		return
	
	if volume == vol.NORMAL:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Dialog"), -5)
	if volume == vol.QUIET:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Dialog"), -10)
	if volume == vol.QUIETER:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Dialog"), -20)
	
	if sound_playing == sound.NEUTRAL:
		Audios[sound_playing].pitch_scale = randf_range(0.7, 1)
	elif sound_playing == sound.HIGH:
		Audios[sound_playing].pitch_scale = randf_range(2, 2.5)
	elif sound_playing == sound.DISTORTED:
		Audios[sound_playing].pitch_scale = randf_range(2, 2.5)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Dialog"), randf_range(-10, -30))
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("DistortedDialog"), randf_range(20, 0))
		extortion.play()
	elif sound_playing == sound.HIGH2:
		Audios[sound_playing].pitch_scale = randf_range(1.8, 2.2)
	elif sound_playing == sound.MEDIUM:
		Audios[sound_playing].pitch_scale = randf_range(0.9, 1.2)
	elif sound_playing == sound.LOW:
		Audios[sound_playing].pitch_scale = randf_range(0.7, 1)
	Audios[sound_playing].play()
