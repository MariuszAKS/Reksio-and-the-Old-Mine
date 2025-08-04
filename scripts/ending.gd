extends Control


@export var next_button: Button
@onready var background: TextureRect = get_node("Background")
var second_image: Texture = load("res://art/visual/ending2.png")


func _ready() -> void:
	next_button.pressed.connect(show_next_image)


func show_next_image():
	background.texture = second_image
	next_button.pressed.disconnect(show_next_image)
	next_button.pressed.connect(back_to_intro)


func back_to_intro():
	get_tree().change_scene_to_file("res://scenes/introduction.tscn")
