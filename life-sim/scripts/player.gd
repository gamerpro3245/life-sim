extends CharacterBody2D

const SPEED := 200.0
const HUNGER_DECAY := 2.0 # на сколько падает голод в секунду
const ENERGY_DECAY := 1.0 # на сколько падает энергия в секунду

var hunger := 100.0
var energy := 100.0

func _process(delta: float) -> void: # Вызывается каждый кадр, delta - время с прошлого кадра
	hunger = maxf(hunger - HUNGER_DECAY * delta, 0.0) # Умножение на delta, чтобы падало одинаково быстро на любом компьютере. 
	energy = maxf(energy - ENERGY_DECAY * delta, 0.0) # maxf не даёт значению уйти ниже нуля

func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") # Смотрит управление и возвращает направление
	velocity = direction * SPEED # Скорость
	move_and_slide() # Реально двигает персонажа и не пускает его сквозь стены

func restore(need: String, amount: float) -> void:
	if need == "hunger":
		hunger = minf(hunger + amount, 100.0) # Не даёт превысить максимум
	elif need == "energy":
		energy = minf(energy + amount, 100.0) 
