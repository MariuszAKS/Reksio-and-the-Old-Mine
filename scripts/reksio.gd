class_name Reksio
extends StaticBody2D


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

	if vector_to_move.length() > vector_to_target.length():
		position = target_position
		stop_walking()

	else:
		position += vector_to_move
