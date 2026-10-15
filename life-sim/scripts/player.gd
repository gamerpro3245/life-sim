extends CharacterBody2D

const SPEED := 200.0
const DECAY := { # На сколько падает каждая потребность в секунду
	"hunger": 2.0,
	"energy": 1.0,
	"fun": 1.5,
	"hygiene": 1.2
}

var needs := { # Текущие значения потребностей, от 0 до 100
	"hunger": 100.0,
	"energy": 100.0,
	"fun": 100.0,
	"hygiene": 100.0
}

var walk_time := 0.0
var busy := false # Занят ли персонаж каким-то действием
var money := 100 # Деньги персонажа
var step_timer := 0.0

func _process(delta: float) -> void: # Вызывается каждый кадр, delta - время с прошлого кадра
	for need in needs: # Перебираем все потребности по очереди
		var decay: float = DECAY[need]
		if need == "energy" and GameClock.is_night():
			decay *= 2.0 # Ночью хочется спать вдвое быстрее
		needs[need] = maxf(needs[need] - decay * delta, 0.0) # maxf не даёт значению уйти ниже нуля. Достаёт значение по названию

func _physics_process(delta: float) -> void:
	if busy:
		velocity = Vector2.ZERO
		$Sprite.position.y = 0.0
		return
	var current_speed := SPEED * get_mood_speed_factor()
	if needs["hunger"] <= 0.0 or needs["energy"] <= 0.0:
		current_speed *= 0.4 # Голод или усталость замедляют ещё сильнее
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
		step_timer -= delta
		if step_timer <= 0.0:
			step_timer = PI / 12.0 # Один подскок - один шаг
			Sfx.play("step", 0.15, -10.0) # Чуть тише и с разбросом высоты
	else:
		$Sprite.position.y = 0.0 # Стоит спокойно
		step_timer = 0.0 # Первый шаг прозвучит сразу, как пойдём
		
func restore(need: String, amount: float) -> void:
	if needs.has(need) : # Если такая потребность существует
		needs[need] = clampf(needs[need] + amount, 0.0, 100.0) # Не выходит за пределы от 0 до 100

func get_mood() -> float:
	var total := 0.0
	for value in needs.values():
		total += value
	return total / needs.size() # Настроение - среднее по всем потребностям, от 0 до 100

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
		
func get_mood_speed_factor() -> float:
	var mood := get_mood()
	if mood >= 75.0:
		return 1.1
	elif mood >= 50.0:
		return 1.0
	elif mood >= 25.0:
		return 0.85
	else:
		return 0.7
		
func get_money_factor() -> float:
	if get_mood() >= 75.0:
		return 1.25 # В хорошем настроении работается продуктивнее
	return 1.0

func _ready() -> void:
	Goals.goal_completed.connect(_on_goal_completed)
	
func _on_goal_completed(_text: String, reward: int) -> void:
	money += reward # Награда за цель дня
	Sfx.play("confirm")
