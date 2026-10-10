extends Node

const MINUTES_PER_REAL_SECOND := 6.0 # реальная секунда = 6 игровых минут

var total_minutes := 8.0 * 60.0 # Старт игры в 08:00 первого дня
var continue_requested := false

func _process(delta: float) -> void:
	total_minutes += MINUTES_PER_REAL_SECOND * delta

# В сутках 1440 минут, время хранится одним числом. День, ча, минуты вычисляются из него.	
func get_day() -> int:
	return int(total_minutes / 1440.0) + 1

func get_hour() -> int:
	return int(total_minutes / 60.0) % 24
	
func get_minute() -> int:
	return int(total_minutes) % 60
	
func get_time_text() -> String:
	return "День %d, %02d:%02d" % [get_day(), get_hour(), get_minute()] # %02d - целое число, минимум две цифры, с нулём впереди

func is_night() -> bool: # Возвращает true или false, чтобы другие скрипты могли спросить "сейчас ночь?"
	var hour := get_hour()
	return hour >= 22 or hour < 6
