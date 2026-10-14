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

func _process(_delta: float) -> void:
	hunger_bar.value = player.needs["hunger"]
	energy_bar.value = player.needs["energy"]
	fun_bar.value = player.needs["fun"]
	hygiene_bar.value = player.needs["hygiene"]
	clock_label.text = GameClock.get_time_text()
	mood_label.text = "Настроение: %s" % player.get_mood_text() # %s вставляет текст на своё место
	money_label.text = "Деньги: %d" % player.money
	goals_label.text = Goals.get_text()
