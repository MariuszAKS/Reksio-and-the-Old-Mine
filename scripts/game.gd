class_name Game
extends Node2D

enum Items {
	TEST,
	HAMMER_CHISEL, WOODEN_WHEELS, WOODEN_POLE, DIESEL_WHEELED, BELTS, WOODEN_ARMS, WOODEN_HANDS, PICKAXE_HEADS, METAL_CAGE, BROKEN_MINECART
}


@onready var room_container: Node2D = get_node("Room container")
@onready var mine_entrance_room: MineEntrance = load("res://scenes/mine_entrance.tscn").instantiate()
@onready var mine_cliff_room: MineCliff = load("res://scenes/mine_cliff.tscn").instantiate()
var current_room = null

@onready var ui: UI = get_node("UI")

@onready var reksio: Reksio = get_node("Reksio")
@onready var kretes: Kretes = get_node("Kretes")

var inventory: Array[Items] = []


func _ready() -> void:
	room_container.add_child(mine_entrance_room)
	current_room = mine_entrance_room

	mine_entrance_room.walk_to.connect(reksio.start_walking)
	mine_cliff_room.walk_to.connect(reksio.start_walking)

	mine_entrance_room.change_scene.connect(func(): call_deferred("set_room_as_current", mine_cliff_room))
	mine_cliff_room.change_scene.connect(func(): call_deferred("set_room_as_current", mine_entrance_room))

	ui.item_clicked.connect(try_use_item)
	# try_add_to_inventory(Items.HAMMER_CHISEL)
	# try_add_to_inventory(Items.WOODEN_WHEELS)
	# try_add_to_inventory(Items.WOODEN_POLE)


func set_room_as_current(room):
	room_container.remove_child(current_room)
	room_container.add_child(room)
	current_room = room
	
	reksio.stop_walking()

	reksio.position = room.enter_position.position
	kretes.position = room.enter_position.position

	reksio.update_scale()
	kretes.update_scale()


func try_add_to_inventory(item) -> bool:
	if len(inventory) < 8:
		inventory.append(item)
		ui.update_inventory(inventory)
		return true
	
	return false

func remove_from_inventory(item_id):
	inventory.remove_at(item_id)
	ui.update_inventory(inventory)


func try_use_item(item_id):
	if item_id >= len(inventory):
		print("Not that many items in inventory")
		return
	
	if inventory[item_id] == Items.TEST:
		print("Tried using TEST")
	
	elif inventory[item_id] < 11: # items that make the machine
		if current_room == mine_entrance_room: # only work in mine_entrance_room
			var item_was_used = current_room.try_making_machine(reksio.position, inventory[item_id])
			
			if item_was_used:
				remove_from_inventory(item_id)
	
	# check other items conditions
