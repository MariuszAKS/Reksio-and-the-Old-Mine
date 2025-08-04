class_name Pickable
extends TextureRect

signal pick_item(pickable)


@export var item: Game.Items


func _ready() -> void:
	gui_input.connect(on_gui_input)


func on_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == 1 and not event.pressed:
		pick_item.emit(self)
