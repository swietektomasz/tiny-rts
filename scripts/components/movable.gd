extends Node2D

@onready var map_RID: RID = get_world_2d().get_navigation_map()
@onready var unit: CharacterBody2D = get_parent()

@onready var target = position
var speed = 60

var path_points_packed: PackedVector2Array
var pathing: bool = false
var pathing_point: int = 0

func _ready():
	unit.movement.connect(_move_order)

func _input(event):
	if event.is_action_pressed("RightClick"):
		_move_order(get_global_mouse_position())

func _move_order(target_position: Vector2):
	var safe_goal: Vector2 = NavigationServer2D.map_get_closest_point(map_RID, target_position) + Vector2(randf_range(-100, 100), randf_range(-100, 100))
	path_points_packed = NavigationServer2D.map_get_path(map_RID, global_position, safe_goal, true)
	pathing = true
	pathing_point = 0

func _physics_process(delta: float) -> void:
	if pathing:
		var path_next_point: Vector2 = path_points_packed[pathing_point] - global_position
		if path_next_point.length_squared() > 1.0:
			var velocity = (path_next_point.normalized() * delta) * speed
			unit.velocity = velocity
			unit.global_position += velocity
		else:
			if pathing_point < (path_points_packed.size() - 1):
				pathing_point += 1
				_physics_process(delta)
			else:
				pathing = false
