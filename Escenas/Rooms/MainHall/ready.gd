extends Node


func func_ready() -> void:
	
	if Gamestate.current_mision == Gamestate.mision.WAITING_ON_CELL:
		Gamestate.current_mision = Gamestate.mision.FREE
		Gamestate.card = true
		Actions.change_outfit.emit("b")
	
	if Gamestate.current_mision == Gamestate.mision.FOLLOW_SCIENTIST:
		Actions.enter_black_room_first_ff()
	
	if Gamestate.current_mision == Gamestate.mision.BLACKROOM_1:
		if not Gamestate.finished_blackroom: return
		Gamestate.finished_blackroom = false
		Actions.close_door.emit("door_black_room")
		Gamestate.current_mision = Gamestate.mision.GO_GET_COFFEE_1
		Actions.exit_black_room_first_ff()
	
	if Gamestate.current_mision == Gamestate.mision.GO_GET_COFFEE_1:
		
		const coffee: Array[Gamestate.coffee_food] = [Gamestate.coffee_food.MILK, Gamestate.coffee_food.SUGAR, Gamestate.coffee_food.COFFEE]
		
		for food in coffee:
			if not Gamestate.in_cup.has(food):
				return
		
		Gamestate.current_mision = Gamestate.mision.RETURN_COFFEE_1
	
	if Gamestate.current_mision == Gamestate.mision.BLACKROOM_2:
		if not Gamestate.finished_blackroom: return
		Gamestate.finished_blackroom = false
		Actions.close_door.emit("door_black_room")
		Gamestate.current_mision = Gamestate.mision.GO_GET_COFFEE_2
		Actions.exit_black_room_second_ff()
	
	if Gamestate.current_mision == Gamestate.mision.GO_GET_COFFEE_2:
		
		const coffee: Array[Gamestate.coffee_food] = [Gamestate.coffee_food.MILK, Gamestate.coffee_food.SUGAR, Gamestate.coffee_food.COFFEE]
		
		for food in coffee:
			if not Gamestate.in_cup.has(food):
				return
		
		Gamestate.current_mision = Gamestate.mision.RETURN_COFFEE_2
