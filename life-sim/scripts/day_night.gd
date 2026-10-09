extends CanvasModulate

func _process(delta: float) -> void:
	var hour := fmod(GameClock.total_minutes / 60.0, 24.0) # Дробное время суток от 0 до 24
	var light := (cos((hour - 13.0) / 24.0 * TAU) + 1.0) / 2.0 # Светлее всего в 13:00, темнее всего в 01:00. Плавная волна от -1 до 1.
	# Переводим волну в диапозон от 0 до 1. TAU - полный оборот
	color = Color(
		lerpf(0.4, 1.0, light), # Плавно смешиваем ночной цвет с дневным
		lerpf(0.4, 1.0, light),
		lerpf(0.6, 1.0, light)
	) # Ночью холодный синеватый оттенок, днём обычный цвет
