class_name Character
extends AnimatableBody2D


@onready var animations: AnimatedSprite2D = get_node("Animations")

const WALK_SPEED = 100.0


func update_facing(walk_right: bool):
	animations.flip_h = not walk_right

func update_scale():
	var new_scale = position.y / 150.0 - 0.3
	scale = Vector2(new_scale, new_scale)
