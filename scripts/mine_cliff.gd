class_name MineCliff
extends Room


@onready var diesel: Sprite2D = get_node("Diesel")


func try_freeing_diesel(reksio_position, item) -> bool:
	if (diesel.position - reksio_position).length() > 30:
		print("Too far from Diesel")
		return false
    
	if diesel.frame + 1 == item - 10:
		if item != Game.Items.HAMSTER_WHEEL:
			diesel.frame += 1
		return true
	
	print("Used wrong item to free Diesel")
	return false
