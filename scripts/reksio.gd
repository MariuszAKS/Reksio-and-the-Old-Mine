class_name Reksio
extends StaticBody2D


@onready var animation: Sprite2D = get_node("Sprite2D") # change later

const WALK_SPEED = 100.0

var on_physics_process = null
var target_position = null


func _physics_process(delta: float) -> void:
	if on_physics_process:
		on_physics_process.call(delta)


func start_walking(target):
	target_position = target
	on_physics_process = walk

func stop_walking():
	target_position = null
	on_physics_process = null

func walk(delta):
	var vector_to_target: Vector2 = target_position - position
	var vector_to_move: Vector2 = vector_to_target.normalized() * WALK_SPEED * delta

	update_facing(vector_to_target.x > 0)

	if vector_to_move.length() > vector_to_target.length():
		position = target_position
		stop_walking()

	else:
		position += vector_to_move
	
	update_scale()


func update_facing(walk_right: bool):
	animation.flip_h = not walk_right

func update_scale():
	var new_scale = position.y / 150.0 - 0.3
	scale = Vector2(new_scale, new_scale)
