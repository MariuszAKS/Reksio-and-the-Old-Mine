class_name Reksio
extends Character


var on_physics_process = null
var target_position = null


func _physics_process(delta: float) -> void:
	if on_physics_process:
		on_physics_process.call(delta)


func start_walking(target):
	target_position = target
	on_physics_process = walk

	animations.play("walk")

func stop_walking():
	target_position = null
	on_physics_process = null

	animations.stop()

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
