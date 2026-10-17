extends Node

const SETTINGS_PATH := "user://settings.cfg" # Файл настроек, лежит рядом с сохранением

var music := 0.6
var sfx := 0.8
var tutorial_seen := false # Видел ли игрок обучение

func _ready() -> void:
	var config := ConfigFile.new()
	config.load(SETTINGS_PATH) # Если файла ещё нет, остаются значения по умолчанию
	music = config.get_value("audio", "music", 0.6)
	sfx = config.get_value("audio", "sfx", 0.8)
	tutorial_seen = config.get_value("game", "tutorial_seen", false)
	_apply("Music", music)
	_apply("SFX", sfx)
	
func set_music(value: float) -> void:
	music = value
	_apply("Music", value)
	
func set_sfx(value: float) -> void:
	sfx = value
	_apply("SFX", value)
	
func save() -> void:
	var config := ConfigFile.new()
	config.set_value("audio", "music", music)
	config.set_value("audio", "sfx", sfx)
	config.set_value("game", "tutorial_seen", tutorial_seen)
	config.save(SETTINGS_PATH)
	
func _apply(bus_name: String, value: float) -> void:
	var bus := AudioServer.get_bus_index(bus_name) # Номер шины по имени
	AudioServer.set_bus_volume_db(bus, linear_to_db(value)) # Ползунок 0..1 переводим в децибелы
	AudioServer.set_bus_mute(bus, value <= 0.0) # На нуле полностью выключаем
