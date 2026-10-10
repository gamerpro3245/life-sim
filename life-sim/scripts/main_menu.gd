extends Control

const SAVE_PATH := "user://save.json"

@onready var new_game_button = $Center/Buttons/NewGameButton
@onready var continue_button = $Center/Buttons/ContinueButton
@onready var quit_button = $Center/Buttons/QuitButton

func _ready() -> void:
	new_game_button.pressed.connect(_on_new_game)
	continue_button.pressed.connect(_on_continue)
	quit_button.pressed.connect(_on_quit)
	continue_button.disabled = not FileAccess.file_exists(SAVE_PATH)
	
func _on_new_game() -> void:
	Sfx.play("confirm")
	GameClock.continue_requested = false
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	
func _on_continue() -> void:
	Sfx.play("confirm")
	GameClock.continue_requested = true
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	
func _on_quit() -> void:
	get_tree().quit()
