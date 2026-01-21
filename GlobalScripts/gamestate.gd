extends Node

enum mision {ALL, NONE, WAITING_ON_CELL, FOLLOW_SCIENTIST, BLACKROOM_1, GO_GET_COFFEE_1, RETURN_COFFEE_1, BLACKROOM_2, GO_GET_COFEE_2, RETURN_COFFEE_2, LAB, GO_TO_ROOM}
# all es para el interact_colider
var current_mision := mision.WAITING_ON_CELL

var printing: bool


# Varuables

var waifudebugin := false

var wait_before_trans := false

var card := false

var open_doors: Array[String]

var open_cells: Array[int]

var cup := false

enum coffee_food {MILK, SUGAR, COFFEE}
var in_cup: Array[coffee_food] = []
