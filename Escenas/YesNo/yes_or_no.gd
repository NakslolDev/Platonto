extends Control

var selection := 0

@export var si: RichTextLabel
@export var no: RichTextLabel

func _ready() -> void:
	visible = false
	Actions.decide.connect(_show)


func _show():
	visible = true

func _input(event: InputEvent) -> void:
	if not visible: return
	
	if event.is_action_pressed("A"):
		selection = 1
		si.add_theme_font_size_override("normal_font_size", 18)
		no.add_theme_font_size_override("normal_font_size", 9)
	
	elif event.is_action_pressed("D"):
		selection = -1
		si.add_theme_font_size_override("normal_font_size", 9)
		no.add_theme_font_size_override("normal_font_size", 18)
	
	elif event.is_action_pressed("interact"):
		if selection == -1: Actions.decision = false
		elif selection == 1: Actions.decision = true
		else: return
		Actions.decided.emit()
		visible = false
