extends CanvasLayer

const SETTINGS_PATH := "user://settings.cfg" # Файл настроек, лежит рядом с сохранением

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
	_load_settings()
	music_slider.value_changed.connect(func(v): _set_bus_volume("Music", v))
	sfx_slider.value_changed.connect(func(v): _set_bus_volume("SFX", v))
	
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
	_save_settings() # Настройки запоминаются между запусками игры
	
func _on_save_pressed() -> void:
	Sfx.play("confirm")
	main.save_game()
	status_label.text = "Игра сохранена"
	
func _on_load_pressed() -> void:
	Sfx.play("click")
	main.load_game()
	close_menu()

func _set_bus_volume(bus_name: String, value: float) -> void:
	var bus := AudioServer.get_bus_index(bus_name) # Номер шины по имени
	AudioServer.set_bus_volume_db(bus, linear_to_db(value)) # Ползунок 0..1 переводим в децибелы
	AudioServer.set_bus_mute(bus, value <= 0.0) # На нуле полностью выключаем
	
func _load_settings() -> void:
	var config := ConfigFile.new()
	config.load(SETTINGS_PATH) # Если файла ещё нет, значения по умолчанию
	music_slider.value = config.get_value("audio", "music", 0.6)
	sfx_slider.value = config.get_value("audio", "sfx", 0.8)
	_set_bus_volume("Music", music_slider.value)
	_set_bus_volume("SFX", sfx_slider.value)
	
func _save_settings() -> void:
	var config := ConfigFile.new()
	config.set_value("audio", "music", music_slider.value)
	config.set_value("audio", "sfx", sfx_slider.value)
	config.save(SETTINGS_PATH)
	
func _on_quit_pressed() -> void:
	_save_settings()
	get_tree().quit()
