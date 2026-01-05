extends Node

const ROUT := "res://Data/"
const NAME := "Dialogs.csv" # al tener 2, está un poco más organizado

func get_dialog(row_id: String) -> String:
	var path := ROUT + NAME
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_warning("No se pudo abrir el archivo CSV: " + path)
		return "Something went wrong... (CSV not found)"
	
	# Saltar cabecera
	if file.eof_reached():
		file.close()
		return "Something went wrong... (empty CSV)"
	file.get_csv_line(";")
	
	const COL_INDEX := 1
	
	while not file.eof_reached():
		var columns := file.get_csv_line(";")
		if columns.size() <= COL_INDEX:
			continue
		
		if columns[0].strip_edges() == row_id:
			var cell := columns[COL_INDEX].strip_edges()
			file.close()
			return cell if cell != "" else "Something went wrong... (empty cell)"
	
	file.close()
	return "Something went wrong... (id non existent)"
