class_name MineEntrance
extends Room


@onready var machine: Sprite2D = get_node("Machine")


func try_making_machine(reksio_position, item) -> bool:
	if (machine.position - reksio_position).length() > 30:
		print("Too far from machine")
		return false
	
	if machine.frame + 1 == item:
		machine.frame += 1
		return true
	
	print("Used wrong item to make machine")
	return false
