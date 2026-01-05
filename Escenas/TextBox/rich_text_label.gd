extends RichTextLabel

signal dialog_done

var done: bool
var active := false

func print_text(dialog: String):
	
	done = false
	
	visible_characters = 0
	
	text = dialog
	
	while visible_characters < text.length():
		
		var text_shown = text.substr(0, visible_characters)
		var last_char = text_shown[-1] if text_shown.length() > 0 else ""
		
		var time := calculate_time(last_char)
		
		await get_tree().create_timer(time).timeout
		
		active = true
		
		visible_characters += 1
	
	done = true

func calculate_time(character: String) -> float:
	if character == ",":
		return 0.2
	if character == "." or character == "!" or character == "?":
		return 0.5
	return 0.08

func _input(event: InputEvent) -> void:
	if not active:
		return
	if event.is_action_pressed("interact"):
		if done:
			emit_signal("dialog_done")
			active = false
		else:
			visible_characters = text.length()
