extends Area2D

@export var need := "hunger" # Показывает переменную в Inspector
@export var amount := 40.0
@export var tile_region := Rect2(0, 0, 16, 16) # Какой кусок листа показывать: x, y , ширина, высота
@export var sound := "" # Какой звук играть при использовании
@export var duration := 2.0 # Сколько секунд занимает действие
@export var money_change := 0 # Сколько даёт (плюс) или забирает (минус) использование
@export var action_id := "" # Какую цель дня закрывает это действие

var player_inside: Node2D = null
var use_timer: Timer = null # Таймер текущего действия, нужен для обратного отсчёта

func _ready() -> void:
	$Sprite.region_rect = tile_region # Предмет сам выбирает свою плитку, а сцена остаётся одна
	body_entered.connect(_on_body_entered) # Сигнал кто-то зашёл в зону, connect привязываем наши функции
	body_exited.connect(_on_body_exited) # Сигнал кто-то вышел из зоны
	$Hint.visible = false # Подсказка скрыта
	monitoring = false # Предмет "спит", пока физика не поймёт, где персонаж
	var timer := Timer.new()
	timer.one_shot = true
	timer.wait_time = 0.3
	timer.timeout.connect(func(): monitoring = true)
	add_child(timer)
	timer.start()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_inside = body
		$Hint.visible = true # Показывается, когда персонаж стоит в зоне
		
func _on_body_exited(body:Node2D) -> void:
	if body == player_inside:
		player_inside = null
		$Hint.visible = false # Прячется, когда персонаж вышел из зоны
		$Hint.text = "Нажми E" # Сбрасываем сообщение "Не хватает денег"
		
func _unhandled_input(event: InputEvent) -> void:
	if player_inside and not player_inside.busy and event.is_action_pressed("interact"):
		_start_using()

func _process(_delta: float) -> void:
	if use_timer:
		$Hint.text = "Занято... %d" % ceili(use_timer.time_left)
		
func _start_using() -> void:
	if player_inside.money + money_change < 0:
		$Hint.text = "Не хватает денег"
		return
	if need == "energy" and amount < 0.0 and player_inside.needs["energy"] <= 0.0:
		$Hint.text = "Слишком устал"
		return
	var user := player_inside
	user.busy = true
	$Hint.text = "Занято..."
	Sfx.play(sound)
	var timer := Timer.new()
	timer.one_shot = true
	timer.wait_time = duration
	add_child(timer)
	use_timer = timer
	timer.timeout.connect(func(): _finish_using(user, timer))
	timer.start()
	
func _finish_using(user: Node2D, timer: Timer) -> void:
	timer.queue_free()
	use_timer = null
	user.busy = false
	$Hint.text = "Нажми E"
	var final_amount := amount
	if need == "energy" and amount > 0.0 and GameClock.is_night():
		final_amount *= 1.5 # Ночью сон полезнее
	user.restore(need, final_amount)
	var earned := money_change
	if earned > 0:
		earned = int(earned * user.get_money_factor()) # Настроение влияет только на доход, не на траты
	user.money += earned
	Goals.report(action_id)
