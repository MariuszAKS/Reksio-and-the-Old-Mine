class_name MineEntrance
extends Node2D

signal walk_to(position: Vector2)


@onready var walk_area: Area2D = get_node("Walk area")

@onready var machine: Sprite2D = get_node("Machine")


func _ready() -> void:
	walk_area.input_event.connect(on_walk_area_input)
	print("mine entrance ready")


func try_making_machine(reksio_position, item) -> bool:
	if (machine.position - reksio_position).length() > 30:
		print("Too far from machine")
		return false
	
	if machine.frame + 1 == item:
		machine.frame += 1
		return true
	
	print("Used wrong item to make machine")
	return false


func on_walk_area_input(_viewport, event: InputEvent, _shape_idx):
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed == false:
		walk_to.emit(event.position)
