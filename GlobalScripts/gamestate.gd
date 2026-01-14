extends Node

enum mision {ALL, NONE, WAITING_ON_CELL, }
# all es para el interact_colider
var current_mision := mision.WAITING_ON_CELL

var printing: bool
