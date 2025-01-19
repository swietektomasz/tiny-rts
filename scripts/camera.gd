extends Camera2D

var mousePos = Vector2()
var mousePosGlobal = Vector2()
var start = Vector2()
var startV = Vector2()
var end = Vector2()
var endV = Vector2()
var isDragging = false
var zoom_in = false
var zoom_out = false 

const ZOOM_MAX = Vector2(.5,.5)
const ZOOM_MIN = Vector2(1,1)
const ZOOM_SPEED = 1

signal area_selected
signal start_move_selection

@onready var box = get_node("../UI/Panel")
@onready var viewport_size = get_viewport().size

func _ready():
	connect("area_selected", Callable(get_parent(), "_on_area_selected"))
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

func _process(_delta):
	if get_local_mouse_position().x < 50:
		position.x -= 10
	elif get_local_mouse_position().x > (viewport_size.x / zoom.x) - 10:
		position.x += 10
	if get_local_mouse_position().y < 50:
		position.y -= 10
	elif get_local_mouse_position().y > (viewport_size.y / zoom.y) - 10:
		position.y += 10
	
	if Input.is_action_just_pressed("LeftClick"):
		start = mousePosGlobal
		startV = mousePos
		isDragging = true
	
	if isDragging:
		end = mousePosGlobal
		endV = mousePos
		draw_area()
	
	if Input.is_action_just_released("LeftClick"):
		if startV.distance_to(mousePos) > 20:
			end = mousePosGlobal
			endV = mousePos
			isDragging = false
			draw_area(false)
			emit_signal("area_selected", self)
		else:
			end = start
			isDragging = false
			draw_area(false)
			
	if Input.is_action_just_released("ScrollUp") and  zoom < ZOOM_MIN:
		zoom = lerp(zoom, zoom + Vector2(0.1,0.1), ZOOM_SPEED)
		(get_tree().create_timer(0.10))
		zoom_in = false
	
	if Input.is_action_just_released("ScrollDown") and zoom > ZOOM_MAX:
		zoom = lerp(zoom, zoom - Vector2(0.1,0.1), ZOOM_SPEED)
		(get_tree().create_timer(0.10))
		zoom_in = false
	
	if Input.is_action_just_released("Escape"):
		get_tree().quit()

func _input(event):
	if event is InputEventMouse:
		mousePos = event.position
		mousePosGlobal = get_global_mouse_position()

func draw_area(s=true):
	box.size = Vector2(abs(startV.x - endV.x), abs(startV.y - endV.y))
	var pos = Vector2()
	pos.x = min(startV.x, endV.x)
	pos.y = min(startV.y, endV.y)
	box.position = pos
	box.size *= int(s)
