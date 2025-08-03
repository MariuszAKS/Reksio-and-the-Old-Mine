class_name Room
extends Node2D


signal walk_to(position: Vector2)
signal change_scene

@onready var walk_area: Area2D = get_node("Walk area")
@onready var enter_position: Marker2D = get_node("Enter position")
@onready var change_scene_area: Area2D = get_node("Change scene area")


func _ready() -> void:
	walk_area.input_event.connect(on_walk_area_input)
	change_scene_area.body_shape_entered.connect(on_body_shape_entered_change_scene_area)


func on_walk_area_input(_viewport, event: InputEvent, _shape_idx):
	if event is InputEventMouseButton and event.button_index == 1 and not event.pressed:
		walk_to.emit(event.position)

func on_body_shape_entered_change_scene_area(_body_rid, _body, _body_shape_index, _local_shape_index):
	change_scene.emit()
