extends Node2D

@onready var tile_map = $TileMap

var ground_layer = 0

func _input(_event):
	if Input.is_action_just_pressed("RightClick"):
		var tile_mouse_pos = tile_map.local_to_map(tile_map.get_local_mouse_position())
		var tile_data = tile_map.get_cell_tile_data(0, tile_mouse_pos)
		var tile_pos = tile_map.map_to_local(tile_mouse_pos)
		Global._select_building(tile_data.get_custom_data("building"), tile_data.texture_origin)
