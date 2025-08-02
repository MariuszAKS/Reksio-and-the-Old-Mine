class_name Kretes
extends StaticBody2D


const WALK_SPEED = 100.0

@export var target_to_follow: Node2D = null
var max_distance_from_target = 32


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if target_to_follow == null:
		return
	
	var vector_to_target: Vector2 = target_to_follow.position - position
	var direction = vector_to_target.normalized()
	var vector_to_move: Vector2 = direction * WALK_SPEED * delta

	if vector_to_target.length() > max_distance_from_target:
		if vector_to_move.length() + max_distance_from_target > vector_to_target.length():
			position += direction * (vector_to_target.length() - max_distance_from_target)
		else:
			position += vector_to_move
