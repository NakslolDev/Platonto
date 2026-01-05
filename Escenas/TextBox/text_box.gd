extends Control

@export var label: RichTextLabel
var printing := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Actions.text.connect(self._show_text)
	visible = false
	printing = false


func _show_text(id: String):
	
	if printing:
		return
	
	printing = true
	visible = true
	var i := 1
	
	while printing:
		var dialog = Dialogs.get_dialog(id + "_" + str(i).pad_zeros(2))
		
		print("--")
		print("printing id: ", id + "_" + str(i).pad_zeros(2))
		print("text:", dialog)
		print("--")
		
		if dialog == "Something went wrong... (id non existent)":
			printing = false
			visible = false
			Actions.emit_signal("text_finished")
			return
		
		label.print_text(dialog)
		await label.dialog_done
		
		i += 1
