@tool
extends Resource
class_name HitboxEvent

@export var method: StringName
@export var args: Array = []

func _get_property_list():
	var props := []
	var methods := Actions.get_method_list()
	
	var method_names: Array[String] = []
	for m in methods:
		if m.name.ends_with("_ff"):   # Filtra solo funciones definidas en tu script
			method_names.append(m.name)
	
	props.append({
		"name": "method",
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": ",".join(method_names)
	})
	
	return props

func execute():
	if Actions.has_method(method):
		Actions.callv(method, args)
	else:
		push_warning("Evento no encontrado: %s" % method)
