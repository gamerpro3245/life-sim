extends Node

signal goal_completed(text: String, reward: int) # Сообщает, что цель выполнена
signal day_ended(day_number: int, done_count: int, total: int, earned: int) # День закончился, вот итоги

const PERFECT_BONUS := 25 # Награда, если выполнены все цели дня

const DAILY_GOALS := [ # id совпадает с action_id у предметов
	{"id": "eat", "text": "Поесть", "reward": 10},
	{"id": "work", "text": "Поработать", "reward": 20},
	{"id": "wash", "text": "Умыться", "reward": 10},
	{"id": "play", "text": "Поиграть/почитать", "reward": 10},
	{"id": "sleep", "text": "Поспать", "reward": 15},
]

var done: Array = [] # id целей, выполненных сегодня
var day := 1
var earned_today := 0 # Сколько монет принесли цель за сегодня

func _process(_delta: float) -> void:
	var today := GameClock.get_day()
	if today != day: # Наступил новый день: подводим итоги и обновляем цели
		var count := done.size()
		var earned := earned_today
		if count == DAILY_GOALS.size():
			goal_completed.emit("Идеальный день", PERFECT_BONUS)
			earned += PERFECT_BONUS
		day_ended.emit(day, count, DAILY_GOALS.size(), earned)
		day = today
		done.clear()
		earned_today = 0

func reset() -> void:
	done.clear()
	earned_today = 0
	day = GameClock.get_day()
	
func report(action_id: String) -> void:
	if action_id == "" or done.has(action_id):
		return # Нет такой цели или она уже выполнена
	for goal in DAILY_GOALS:
		if goal["id"] == action_id:
			done.append(action_id)
			earned_today += goal["reward"]
			goal_completed.emit(goal["text"], goal["reward"])
			return
			
func get_text() -> String:
	var lines := ["Цели дня"]
	for goal in DAILY_GOALS:
		var mark := "[x]" if done.has(goal["id"]) else "[ ]"
		lines.append("%s %s +%d" % [mark, goal["text"], goal["reward"]])
	return "\n".join(lines)
