class_name Game
extends Node2D

enum Person {
	REKSIO, KRETES
}

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
	try_add_item(Items.HAMSTER_WHEEL)


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
	if (pickable.position - reksio.position).length() < 80 and try_add_item(pickable.item):

		match pickable.item:
			Items.WOODEN_POLE: current_room.shown_ore.emit()
			Items.METAL_CAGE: current_room.diesel.frame += 1
		
		match pickable.item:
			Items.TEST: talk(Person.REKSIO, "Test mikrofonu, raz, dwa, trzy. To znaczy, Hau! Nie powinieneś tego widzieć.")

			Items.WOODEN_WHEELS: talk(Person.KRETES, "Koła. I to drewniane. Teraz już takich nie robią.")
			Items.WOODEN_POLE: talk(Person.KRETES, "Tyczka. O, ruszyła kamień, a co to w tym dołku leży?")
			Items.DIESEL_WHEELED: talk(Person.KRETES, "Chodź Diesel z nami na kolejną przygodę!")
			Items.BELTS: talk(Person.KRETES, "Takimi transportowaliśmy rudy. Są nawet w niezłym stanie.")
			Items.WOODEN_ARMS: talk(Person.KRETES, "Dobre kawałki drewna. Powinny dużo wytrzymać.")
			Items.WOODEN_HANDS: talk(Person.KRETES, "Deski z dziurami. W sam raz aby coś w nie włożyć.")
			Items.PICKAXE_HEADS: talk(Person.KRETES, "Ech, nie przetrwały próby czasu. Jednak nic nie przebije dobrych pazurków.")
			Items.METAL_CAGE: talk(Person.KRETES, "Dobra klatka nie jest zła. Bierzemy.")
			Items.BROKEN_MINECART: talk(Person.KRETES, "Pojemność twoich kieszeni Reksiu nie przestaje mnie zadziwiać.")

			Items.ORE: talk(Person.KRETES, "Patrz Reksiu. My tak głęboko kopaliśmy, a tu ruda tuż pod kamieniem leży.")
		
		pickable.queue_free()

func try_add_item(item: Items) -> bool:
	if len(inventory) < 12:
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
	
	var item: Items = inventory[item_id]
	
	if item == Items.TEST:
		print("Tried using TEST")
	
	elif item < 11: # items that make the machine
		if current_room == rooms[0]: # only work in mine_entrance_room
			var correct_item = current_room.try_making_machine(reksio.position, item)
			
			if correct_item:
				remove_from_inventory(item_id)
				current_room.machine.get_node("Audio").play()

				match item:
					Items.HAMMER_CHISEL: talk(Person.KRETES, "No, i podziurawiony! Teraz można zaczynać budowę! Najpierw coś okrągłego.")
					Items.WOODEN_WHEELS: talk(Person.KRETES, "Perfekcyjnie, będą przenosić siłę z tyłu naprzód. W tą ostatnią wejdzie coś długiego.")
					Items.WOODEN_POLE: talk(Person.KRETES, "Ok, pasuje. Przydałby się jakiś napęd. Rozejrzyjmy się.")
					Items.DIESEL_WHEELED: talk(Person.KRETES, "Diesel, zawsze pomocny, zawsze zwarty i gotowy! Trzeba go podłączyć do kół.")
					Items.BELTS: talk(Person.KRETES, "Pasy! Świetny pomysł Reksiu! Teraz coś mocnego na łapy naszego Kopacza.")
					Items.WOODEN_ARMS: talk(Person.KRETES, "Te kawałki drewna pasują. Teraz tym rękom przydałyby się łapki.")
					Items.WOODEN_HANDS: talk(Person.KRETES, "Gotowe, nawer mają miejsce na pazurki! Swoich nie oddam, poszukajmy zamiennika.")
					Items.PICKAXE_HEADS: talk(Person.KRETES, "To nie krecie pazury, ale się nadadzą. Dieselowi przydałaby się ochrona.")
					Items.METAL_CAGE: talk(Person.KRETES, "Może ci się to nie podobać, ale to dla twojego bezpieczeństwa Diesel. Teraz trzeba to zamknąć.")
					Items.BROKEN_MINECART:
						talk(Person.KRETES, "No, Kopacz jak się patrzy. To teraz do środeczka i jedziemy!")
						ui.finished_talking.connect(show_ending)
			
			else:
				talk(Person.KRETES, "Nie pasuje.")
	
	elif item < 14: # diesel puzzle
		if current_room == rooms[1]: # only work in mine_cliff_room
			var correct_item = current_room.try_freeing_diesel(reksio.position, item)
			
			if correct_item:
				if item == Items.HAMSTER_WHEEL:
					if try_add_item(Items.DIESEL_WHEELED):
						remove_from_inventory(item_id)
				else:
					remove_from_inventory(item_id)
			
			else:
				match current_room.diesel.frame:
					0: talk(Person.KRETES, "Trzeba coś przywiązać do tej liny.")
					1: talk(Person.KRETES, "Przydałoby się coś ciężkiego do tego koszyka.")
					2: talk(Person.KRETES, "Diesel lubi swoje koło. Chyba masz je w kieszeni Reksiu.")


func talk(person: Person, line: String):
	ui.start_talking.emit(person, line)
	get_tree().paused = true


func show_ending():
	get_tree().change_scene_to_file("res://scenes/ending.tscn")
