extends Control

const SAVE_PATH := "user://save.json"

@onready var new_game_button = $Center/Buttons/NewGameButton
@onready var continue_button = $Center/Buttons/ContinueButton
@onready var quit_button = $Center/Buttons/QuitButton
@onready var settings_button = $Center/Buttons/SettingsButton
@onready var main_buttons = $Center
@onready var settings_panel = $SettingsPanel
@onready var music_slider: HSlider = $SettingsPanel/Box/MusicSlider
@onready var sfx_slider: HSlider = $SettingsPanel/Box/SfxSlider
@onready var back_button: Button = $SettingsPanel/Box/BackButton

var confirm_dialog: ConfirmationDialog

func _ready() -> void:
	new_game_button.pressed.connect(_on_new_game)
	continue_button.pressed.connect(_on_continue)
	quit_button.pressed.connect(_on_quit)
	continue_button.disabled = not FileAccess.file_exists(SAVE_PATH)
	settings_button.pressed.connect(_on_settings)
	music_slider.value = Settings.music
	sfx_slider.value = Settings.sfx
	music_slider.value_changed.connect(Settings.set_music)
	sfx_slider.value_changed.connect(Settings.set_sfx)
	back_button.pressed.connect(_on_back)
	confirm_dialog = ConfirmationDialog.new()
	confirm_dialog.title = "Новая игра"
	confirm_dialog.dialog_text = "Начать заново? Старое сохранение будет удалено."
	confirm_dialog.ok_button_text = "Да"
	confirm_dialog.cancel_button_text = "Отмена"
	confirm_dialog.confirmed.connect(_start_new_game)
	add_child(confirm_dialog)
	
func _on_new_game() -> void:
	Sfx.play("click")
	if FileAccess.file_exists(SAVE_PATH):
		confirm_dialog.popup_centered() # Если сохранение: сначала спрашиваем
	else:
		_start_new_game()

func _start_new_game() -> void:
	Sfx.play("confirm")
	GameClock.continue_requested = false
	GameClock.total_minutes = 8.0 * 60.0
	Goals.reset()
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	
func _on_continue() -> void:
	Sfx.play("confirm")
	GameClock.continue_requested = true
	Goals.reset()
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	
func _on_quit() -> void:
	get_tree().quit()

func _on_settings() -> void:
	Sfx.play("click")
	main_buttons.visible = false
	settings_panel.visible = true
	back_button.grab_focus()
	
func _on_back() -> void:
	Sfx.play("click")
	Settings.save()
	settings_panel.visible = false
	main_buttons.visible = true
