extends CharacterBody2D

const SPEED := 200.0
const DECAY := { # На сколько падает каждая потребность в секунду
	"hunger": 2.0,
	"energy": 1.0,
	"fun": 1.5,
}

var needs := { # Текущие значения потребностей, от 0 до 100
	"hunger": 100.0,
	"energy": 100.0,
	"fun": 100.0,
}

var walk_time := 0.0

func _process(delta: float) -> void: # Вызывается каждый кадр, delta - время с прошлого кадра
	for need in needs: # Перебираем все потребности по очереди
		var decay: float = DECAY[need]
		if need == "energy" and GameClock.is_night():
			decay *= 2.0 # Ночью хочется спать вдвое быстрее
		needs[need] = maxf(needs[need] - decay * delta, 0.0) # maxf не даёт значению уйти ниже нуля. Достаёт значение по названию

func _physics_process(delta: float) -> void:
	var current_speed := SPEED
	if needs["hunger"] <= 0.0 or needs["energy"] <= 0.0:
		current_speed = SPEED * 0.4 # Если голоден или без сил, персонаж еле идёт
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") # Смотрит управление и возвращает направление
	velocity = direction * current_speed # Скорость
	move_and_slide() # Реально двигает персонажа и не пускает его сквозь стены
	
	if direction.x < 0.0:
		$Sprite.flip_h = true # Смотрит влево
	elif direction.x > 0.0:
		$Sprite.flip_h = false # Смотрит вправо
		
	if direction != Vector2.ZERO:
		walk_time += delta * 12.0
		$Sprite.position.y = -absf(sin(walk_time)) * 4.0 # Подпрыгивает при ходьбе, sin даёт волну, absf делает из неё серию подпрыгиваний, а умножение на 4 задаёт высоту прыжка в пикселях.
	else:
		$Sprite.position.y = 0.0 # Стоит спокойно
		
func restore(need: String, amount: float) -> void:
	if needs.has(need) : # Если такая потребность существует
		needs[need] = minf(needs[need] + amount, 100.0) # Не даёт превысить максимум

func get_mood() -> float:
	var total := 0.0
	for value in needs.values():
		total += value
	return total / needs.size() # Настроение - среднее между голодом и энергией, от 0 до 100

func get_mood_text() -> String:
	var mood := get_mood()
	# if / elif / else проверяет условия сверху вниз и берёт первое подходящее. Порядок важен: сначала самое высокое значение.
	if mood >= 75.0:
		return "Отличное"
	elif mood >= 50.0:
		return "Хорошее"
	elif mood >= 25.0:
		return "Плохое"
	else:
		return "Ужасное" # Возвращает результат и выходит из функции. Здесь ловит всё, что ниже 25
