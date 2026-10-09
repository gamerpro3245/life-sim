extends CanvasLayer

@onready var player = $"../Player" # найди эти узлы, когда сцена загрузится. соседний узел Player. .. - подняться на уровень вверх к Room
@onready var hunger_bar: ProgressBar = $Needs/HungerBar
@onready var energy_bar: ProgressBar = $Needs/EnergyBar
@onready var clock_label: Label = $Needs/ClockLabel

func _process(_delta: float) -> void:
	hunger_bar.value = player.hunger
	energy_bar.value = player.energy
	clock_label.text = GameClock.get_time_text()
