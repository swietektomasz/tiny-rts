extends Node

var created_units = 0
var max_units = 100
var selected_building = ["none", Vector2(0,0)] :
	get: return selected_building
	set(val): selected_building = val
var wood_amount = 0
var gold_amount = 0
var current_mission = "Debug"

func _select_building(building, position):
	selected_building = [building, position]
