class_name MineCliff
extends Room

signal shown_ore


@onready var diesel: Sprite2D = get_node("Diesel")
@export var cage: Pickable

@export var wooden_pole: Pickable
@export var ore: Pickable


func _ready():
	shown_ore.connect(func(): ore.mouse_filter = Control.MOUSE_FILTER_PASS)
	super()


func try_freeing_diesel(reksio_position, item: Game.Items) -> bool:
	print(item)
	print(diesel.frame + 1)
	print(item - 10)

	if (diesel.position - reksio_position).length() > 30:
		print("Too far from Diesel")
		return false
	
	if diesel.frame + 1 == item - 10:
		diesel.frame += 1

		if item == Game.Items.HAMSTER_WHEEL:
			cage.mouse_filter = Control.MOUSE_FILTER_PASS
		return true
	
	print("Used wrong item to free Diesel")
	return false
