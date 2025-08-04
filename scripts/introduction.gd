extends Control


@export var start_button: Button


func _ready() -> void:
	start_button.pressed.connect(start_new_game)


func start_new_game():
	get_tree().change_scene_to_file("res://scenes/game.tscn")
