extends CanvasLayer

@onready var player = $"../Player" # найди эти узлы, когда сцена загрузится. соседний узел Player. .. - подняться на уровень вверх к Room
@onready var hunger_bar: ProgressBar = $Needs/HungerBar
@onready var energy_bar: ProgressBar = $Needs/EnergyBar
@onready var fun_bar: ProgressBar = $Needs/FunBar
@onready var hygiene_bar: ProgressBar = $Needs/HygieneBar
@onready var clock_label: Label = $Needs/ClockLabel
@onready var mood_label: Label = $Needs/MoodLabel
@onready var money_label: Label = $Needs/MoneyLabel
@onready var goals_label: Label = $GoalsLabel
@onready var toast_label: Label = $ToastLabel
var toast_tween: Tween = null # Текущая анимация сообщения

func _ready() -> void:
	toast_label.modulate.a = 0.0 # Сначала сообщение невидимо
	Goals.goal_completed.connect(_on_goal_completed)
	Goals.day_ended.connect(_on_day_ended)
	
func _on_goal_completed(text: String, reward: int) -> void:
	_show_toast("Цель выполнена: %s +%d" % [text, reward], 1.5)
	
func _on_day_ended(day_number: int, done_count: int, total: int, earned: int) -> void:
	_show_toast("День %d завершён: цели %d/%d, заработано %d" % [day_number, done_count, total, earned], 4.0)

func _show_toast(text: String, hold: float) -> void:
	toast_label.text = text
	toast_label.modulate.a = 1.0
	if toast_tween:
		toast_tween.kill() # Если прошлое сообщение ещё гаснет, останавливаем его
	toast_tween = create_tween()
	toast_tween.tween_interval(hold) # Держим сообщение на экране
	toast_tween.tween_property(toast_label, "modulate:a", 0.0, 0.5) # Плавно гасим за полсекунды

func _process(_delta: float) -> void:
	hunger_bar.value = player.needs["hunger"]
	energy_bar.value = player.needs["energy"]
	fun_bar.value = player.needs["fun"]
	hygiene_bar.value = player.needs["hygiene"]
	clock_label.text = GameClock.get_time_text()
	mood_label.text = "Настроение: %s" % player.get_mood_text() # %s вставляет текст на своё место
	money_label.text = "Деньги: %d" % player.money
	goals_label.text = Goals.get_text()
