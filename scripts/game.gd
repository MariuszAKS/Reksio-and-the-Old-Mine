class_name Game
extends Node2D

enum Items {
	TEST,
	HAMMER_CHISEL, WOODEN_WHEELS, WOODEN_POLE, DIESEL_WHEELED, BELTS, WOODEN_ARMS, WOODEN_HANDS, PICKAXE_HEADS, METAL_CAGE, BROKEN_MINECART,
	BASKET, ORE, HAMSTER_WHEEL,
}


@onready var room_container: Node2D = get_node("Room container")
@onready var rooms: Array[Room] = [
	load("res://scenes/mine_entrance.tscn").instantiate(),
	load("res://scenes/mine_cliff.tscn").instantiate()
]
var current_room = null

@onready var ui: UI = get_node("UI")

@onready var reksio: Reksio = get_node("Reksio")
@onready var kretes: Kretes = get_node("Kretes")

var inventory: Array[Items] = []


func _ready() -> void:
	load_rooms()
	connect_scene_changes()

	room_container.add_child(rooms[0])
	current_room = rooms[0]

	ui.item_clicked.connect(try_use_item)
	try_add_item(Items.HAMMER_CHISEL)
	try_add_item(Items.BASKET)
	try_add_item(Items.ORE)


func load_rooms() -> void:
	for room in rooms:
		room_container.add_child(room)
		room_container.remove_child(room)

		room.walk_to.connect(reksio.start_walking)

		for pickable in room.pickables:
			pickable.pick_item.connect(try_pick_up)

func connect_scene_changes():
	rooms[0].change_scene.connect(func(): call_deferred("set_room_as_current", rooms[1]))
	rooms[1].change_scene.connect(func(): call_deferred("set_room_as_current", rooms[0]))

func set_room_as_current(room):
	room_container.remove_child(current_room)
	room_container.add_child(room)
	current_room = room
	
	reksio.stop_walking()

	reksio.position = room.enter_position.position
	kretes.position = room.enter_position.position

	reksio.update_scale()
	kretes.update_scale()


func try_pick_up(pickable: Pickable):
	print((pickable.position - reksio.position).length())
	if (pickable.position - reksio.position).length() < 64 and try_add_item(pickable.item):
		pickable.queue_free()

func try_add_item(item: Items) -> bool:
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
		if current_room == rooms[0]: # only work in mine_entrance_room
			var correct_item = current_room.try_making_machine(reksio.position, inventory[item_id])
			
			if correct_item:
				remove_from_inventory(item_id)
	
	elif inventory[item_id] < 14: # diesel puzzle
		if current_room == rooms[1]: # only work in mine_cliff_room
			var correct_item = current_room.try_freeing_diesel(reksio.position, inventory[item_id])
			
			if correct_item:
				if inventory[item_id] == Items.HAMSTER_WHEEL:
					if try_add_item(Items.DIESEL_WHEELED):
						remove_from_inventory(item_id)
				else:
					remove_from_inventory(item_id)
				
	
	# check other items conditions
