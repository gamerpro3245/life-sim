extends Node2D

@export_file("*.tscn") var start_room: String = "res://scenes/living_room.tscn"

var current_room: Node = null

@onready var world: Node2D = $World
@onready var player: Node2D = $Player

func _ready() -> void:
	change_room(start_room, player.position)
	
func change_room(room_path: String, spawn_position: Vector2) -> void:
	if current_room:
		current_room.queue_free() # Удаляем старую комнату
	current_room = load(room_path).instantiate() # Создаём новую из файла
	world.add_child(current_room)
	player.position = spawn_position # Ставим персонажа на место появления
