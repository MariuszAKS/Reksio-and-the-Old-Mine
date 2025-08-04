class_name UI
extends Control

signal item_clicked(id)
signal start_talking(person: Game.Person, line: String)
signal finished_talking


@onready var item_grid: GridContainer = get_node("Items/Margin/Grid")
@onready var item_textures: Array[Texture] = [
	load("res://art/visual/icon_kretes.png"),
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

@onready var talking: Control = get_node("Talking")
@onready var talking_timer: Timer = talking.get_node("Timer")
@onready var talking_audio: AudioStreamPlayer2D = talking.get_node("Audio")
@onready var talking_icon: TextureRect = talking.get_node("Margin/Row/Icon")
@onready var talking_text: RichTextLabel = talking.get_node("Margin/Row/Text")
@onready var reksio_icon: Texture = load("res://art/visual/icon_reksio.png")
@onready var kretes_icon: Texture = load("res://art/visual/icon_kretes.png")
var talking_line: String = ""
var talking_id: int = 0
var is_talking: bool = false

var regex: RegEx


func _ready() -> void:
	var item_slots: Array = item_grid.get_children()

	for i in range(8):
		item_slots[i].gui_input.connect(func(event): on_item_pressed(event, i))
	
	talking.gui_input.connect(on_talking_pressed)
	start_talking.connect(on_start_talking)
	talking_timer.timeout.connect(write_character)

	regex = RegEx.new()
	regex.compile("[a-zA-Z0-9]")


func update_inventory(inventory: Array[Game.Items]):
	# reveives list of enums, which are essentially ints (create array with all item textures)

	var item_slots = item_grid.get_children()
	var grid_id = 0

	while grid_id < len(inventory):
		item_slots[grid_id].texture = item_textures[inventory[grid_id]]
		grid_id += 1
	
	while grid_id < 12:
		item_slots[grid_id].texture = null
		grid_id += 1

func on_item_pressed(event, item_id):
	if event is InputEventMouseButton and event.pressed == true and event.button_index == 1:
		item_clicked.emit(item_id)


func on_start_talking(person: Game.Person, line: String):
	print(person, line)
	match person:
		Game.Person.REKSIO: talking_icon.texture = reksio_icon
		Game.Person.KRETES: talking_icon.texture = kretes_icon
		_: talking_icon.texture = null
	
	is_talking = true
	talking_text.text = ""
	talking_line = line
	talking_id = 0

	talking.show()
	talking.mouse_filter = Control.MOUSE_FILTER_STOP

	talking_timer.start()

func write_character():
	var character: String = talking_line[talking_id]
	talking_text.text += character
	talking_id += 1

	if regex.search(character):
		talking_audio.play()

	if talking_id == len(talking_line):
		stop_talking()
	else:
		talking_timer.start()

func stop_talking():
	is_talking = false
	talking_timer.stop()
	talking_text.text = talking_line

func on_talking_pressed(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		if is_talking:
			stop_talking()
		
		else:
			talking.hide()
			talking.mouse_filter = Control.MOUSE_FILTER_IGNORE
			
			get_tree().paused = false
			finished_talking.emit()
