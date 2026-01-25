extends Node

enum mision {ALL, NONE, WAITING_ON_CELL, FOLLOW_SCIENTIST, BLACKROOM_1, GO_GET_COFFEE_1, RETURN_COFFEE_1, BLACKROOM_2, GO_GET_COFFEE_2, RETURN_COFFEE_2, LAB, FREE, DRUGGED_ENDING}
# all es para el interact_colider
var current_mision := mision.WAITING_ON_CELL

var printing: bool

enum end {EXIT, PRISON, DRUGS, RABBIT, BADASS}
var ending: end

# Variables

var waifudebugin := false

var wait_before_trans := false

var card := false

var open_doors: Array[String]

var open_cells: Array[int]

var cup := false

var finished_blackroom := false

enum coffee_food {MILK, SUGAR, COFFEE}
var in_cup: Array[coffee_food] = []

var waifu_in_center_of_lab := false

var start_in_middle := false

var entered_black_room_second_time := false
