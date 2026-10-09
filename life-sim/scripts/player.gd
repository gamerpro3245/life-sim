extends CharacterBody2D

const SPEED := 200.0
const HUNGER_DECAY := 2.0 # на сколько падает голод в секунду
const ENERGY_DECAY := 1.0 # на сколько падает энергия в секунду

var hunger := 100.0
var energy := 100.0

func _process(delta: float) -> void: # Вызывается каждый кадр, delta - время с прошлого кадра
	hunger = maxf(hunger - HUNGER_DECAY * delta, 0.0) # Умножение на delta, чтобы падало одинаково быстро на любом компьютере. 
	var energy_decay := ENERGY_DECAY
	if GameClock.is_night():
		energy_decay *= 2.0 # Ночью хочется спать вдвое быстрее
	energy = maxf(energy - energy_decay * delta, 0.0) # maxf не даёт значению уйти ниже нуля

func _physics_process(_delta: float) -> void:
	var current_speed := SPEED
	if hunger <= 0.0 or energy <= 0.0:
		current_speed = SPEED * 0.4 # Если голоден или без сил, персонаж еле идёт
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") # Смотрит управление и возвращает направление
	velocity = direction * current_speed # Скорость
	move_and_slide() # Реально двигает персонажа и не пускает его сквозь стены

func restore(need: String, amount: float) -> void:
	if need == "hunger":
		hunger = minf(hunger + amount, 100.0) # Не даёт превысить максимум
	elif need == "energy":
		energy = minf(energy + amount, 100.0) 

func get_mood() -> float:
	return (hunger + energy) / 2.0 # Нстроение - среднее между голодом и энергией, от 0 до 100

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
