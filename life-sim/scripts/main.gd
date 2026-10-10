extends Node2D

@export_file("*.tscn") var start_room: String = "res://scenes/living_room.tscn"

const SAVE_PATH := "user://save.json" # user:// - специальная папка для сохранений, у каждого игрока своя

var current_room_path := ""
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
	current_room_path = room_path # Запоминаем, в какой мы комнате

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("save_game"):
		save_game()
	elif event.is_action_pressed("load_game"):
		load_game()
		
func save_game() -> void:
	var data := {
		"needs": player.needs,
		"minutes": GameClock.total_minutes,
		"room": current_room_path,
		"player_x": player.position.x,
		"player_y": player.position.y,
	} # Словарь: пары "название - значение"
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		return # Не получилось открыть файл
	file.store_string(JSON.stringify(data)) # Превращаем словарь в текст и пишем в файл
	print("Игра сохранена")
	
func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return # Сохранения ещё нет
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text()) # Читаем текст и превращаем обратно в словарь
	if data == null:
		return # Файл повреждён
	var saved_needs: Dictionary = data.get("needs", {}) # Если в файле нет потребностей, берём пустой словарь
	for need in saved_needs:
		player.needs[need] = saved_needs[need]
	GameClock.total_minutes = data["minutes"]
	change_room(data["room"], Vector2(data["player_x"], data["player_y"]))
	print("Игра загружена")
