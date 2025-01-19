extends Node2D

@onready var create_unit_button = get_node("Debug/Button")
@onready var debug_text := get_node("Debug/Text") as RichTextLabel
@onready var new_unit = preload("res://scenes/unit.tscn")

signal unit_created

func _ready():
	create_unit_button.pressed.connect(_create_unit)
	_append_stat("Created units", Global.created_units)
	_append_stat("Max units", Global.max_units)
	_append_stat("Selected building", Global.selected_building)
	_append_stat("Wood", Global.wood_amount)
	_append_stat("Gold", Global.gold_amount)
	_append_stat("Mission", Global.current_mission)

func _append_stat(stat_name, stat):
	debug_text.append_text("[p]%s: %s[/p]" % [stat_name, stat])

func _create_unit():
	var unit = new_unit.instantiate()
	unit.position.x = get_global_mouse_position().x
	unit.position.y = get_global_mouse_position().y
	add_child(unit)
	unit.add_to_group("units")
	unit_created.emit()
	Global.created_units = get_tree().get_nodes_in_group("units").size()


