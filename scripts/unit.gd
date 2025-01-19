extends CharacterBody2D

@export var selected = false
@onready var box = get_node("Box")
@onready var anim = get_node("AnimationPlayer")

signal movement(target)

func _ready():
	set_selected(selected)
	anim.play("Idle")

func set_selected(value):
	selected = value
	box.visible = value

func _input(event):
	if event.is_action_pressed("RightClick") and selected:
		movement.emit(get_global_mouse_position())
	if event.is_action_released("LeftClick") and selected:
		set_selected(false)

func _input_event(viewport, event, shape_idx):
	if event.is_action_released("LeftClick") and not selected:
		set_selected(true)
