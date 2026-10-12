extends CanvasLayer

@onready var main = get_parent() # Родитель меню - сцена Main, у неё есть save_game и load_game
@onready var status_label: Label = $Center/Buttons/StatusLabel
@onready var resume_button: Button = $Center/Buttons/ResumeButton
@onready var music_slider: HSlider = $Center/Buttons/MusicSlider
@onready var sfx_slider: HSlider = $Center/Buttons/SfxSlider

func _ready() -> void:
	visible = false # Сначала меню скрыто
	resume_button.pressed.connect(close_menu)
	$Center/Buttons/SaveButton.pressed.connect(_on_save_pressed)
	$Center/Buttons/LoadButton.pressed.connect(_on_load_pressed)
	$Center/Buttons/QuitButton.pressed.connect(_on_quit_pressed)
	music_slider.value = Settings.music
	sfx_slider.value = Settings.sfx
	music_slider.value_changed.connect(Settings.set_music)
	sfx_slider.value_changed.connect(Settings.set_sfx)
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"): # ui_cancel - встроенное действие, это клавиша Esc
		if visible:
			close_menu()
		else:
			open_menu()
			
func open_menu() -> void:
	Sfx.play("open")
	visible = true
	status_label.text = ""
	get_tree().paused = true # Ставим всю игру на паузу: время, голод, движение
	resume_button.grab_focus() # Выделяем первую кнопку, чтобы можно было ходить по меню клавишами

func close_menu() -> void:
	Sfx.play("close")
	visible = false
	get_tree().paused = false
	Settings.save() # Настройки запоминаются между запусками игры
	
func _on_save_pressed() -> void:
	Sfx.play("confirm")
	main.save_game()
	status_label.text = "Игра сохранена"
	
func _on_load_pressed() -> void:
	Sfx.play("click")
	main.load_game()
	close_menu()

func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
