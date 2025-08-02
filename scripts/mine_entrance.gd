class_name MineEntrance
extends Node2D

signal walk_to(position: Vector2)


@onready var walk_area_markers: Node2D = get_node("Walk area markers")
@onready var walk_area: Area2D = get_node("Walk area")


func _ready() -> void:
	walk_area.input_event.connect(on_walk_area_input)



func on_walk_area_input(_viewport, event: InputEvent, _shape_idx):
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed == false:
		walk_to.emit(event.position)
