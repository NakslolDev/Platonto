extends Control

@export var label: RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Actions.text.connect(self._show_text)
	visible = false
	Gamestate.printing = false


func _show_text(id: String):
	
	if Gamestate.printing:
		return
	
	Gamestate.printing = true
	
	var i := 1
	while Gamestate.printing:
		var dialog = Dialogs.get_dialog(id + "_" + str(i).pad_zeros(2))
		
		if label.find_bracket(dialog, "hide"):
			visible = false
		else:
			visible = true
		
		#print("--")
		#print("Gamestate.printing id: ", id + "_" + str(i).pad_zeros(2))
		#print("text:", dialog)
		#print("--")
		
		if dialog == "Something went wrong... (id non existent)":
			Gamestate.printing = false
			visible = false
			Actions.emit_signal("text_finished")
			return
		
		label.print_text(dialog)
		await label.dialog_done
		
		i += 1
