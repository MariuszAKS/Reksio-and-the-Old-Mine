extends Node2D


@onready var room_container: Node2D = get_node("Room container")
@onready var mine_entrance_room: MineEntrance = preload("res://scenes/mine_entrance.tscn").instantiate()

@onready var reksio: Reksio = get_node("Reksio")
@onready var kretes: Kretes = get_node("Kretes")


func _ready() -> void:
	mine_entrance_room.walk_to.connect(reksio.start_walking)
	room_container.add_child(mine_entrance_room)
