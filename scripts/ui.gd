class_name UI
extends Control

signal item_clicked(id)


@onready var item_grid: GridContainer = get_node("Items/Margin/Grid")
@onready var item_textures: Array[Texture] = [ # temporarily all pickaxe heads
	load("res://art/visual/kretes.png"),
	load("res://art/visual/item_hammer_chisel.png"),
	load("res://art/visual/item_wheels.png"),
	load("res://art/visual/item_wooden_pole.png"),
	load("res://art/visual/item_diesel_wheeled.png"),
	load("res://art/visual/item_belts.png"),
	load("res://art/visual/item_arms.png"),
	load("res://art/visual/item_hands.png"),
	load("res://art/visual/item_pickaxe_heads.png"),
	load("res://art/visual/item_cage.png"),
	load("res://art/visual/item_minecart.png"),
	load("res://art/visual/item_basket.png"),
	load("res://art/visual/item_ore.png"),
	load("res://art/visual/item_hamster_wheel.png")
]


func _ready() -> void:
	var item_slots: Array = item_grid.get_children()

	for i in range(8):
		item_slots[i].gui_input.connect(func(event): on_item_pressed(event, i))


func update_inventory(inventory: Array[Game.Items]):
	# reveives list of enums, which are essentially ints (create array with all item textures)
	inventory.sort()

	var item_slots = item_grid.get_children()
	var grid_id = 0

	while grid_id < len(inventory):
		item_slots[grid_id].texture = item_textures[inventory[grid_id]]
		grid_id += 1
	
	while grid_id < 8:
		item_slots[grid_id].texture = null
		grid_id += 1


func on_item_pressed(event, item_id):
	if event is InputEventMouseButton and event.pressed == true and event.button_index == 1:
		item_clicked.emit(item_id)
