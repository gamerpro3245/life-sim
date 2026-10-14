extends Node

signal goal_completed(text: String, reward: int) # Сообщает, что цель выполнена

const DAILY_GOALS := [ # id совпадает с action_id у предметов
	{"id": "eat", "text": "Поесть", "reward": 10},
	{"id": "work", "text": "Поработать", "reward": 20},
	{"id": "wash", "text": "Умыться", "reward": 10},
	{"id": "play", "text": "Поиграть/почитать", "reward": 10},
	{"id": "sleep", "text": "Поспать", "reward": 15},
]

var done: Array = [] # id целей, выполненных сегодня
var day := 1

func _process(_delta: float) -> void:
	var today := GameClock.get_day()
	if today != day: # Наступил новый день: список целей обновляется
		day = today
		done.clear()

func reset() -> void:
	done.clear()
	day = GameClock.get_day()
	
func report(action_id: String) -> void:
	if action_id == "" or done.has(action_id):
		return # Нет такой цели или она уже выполнена
	for goal in DAILY_GOALS:
		if goal["id"] == action_id:
			done.append(action_id)
			goal_completed.emit(goal["text"], goal["reward"])
			return
			
func get_text() -> String:
	var lines := ["Цели дня"]
	for goal in DAILY_GOALS:
		var mark := "[x]" if done.has(goal["id"]) else "[ ]"
		lines.append("%s %s +%d" % [mark, goal["text"], goal["reward"]])
	return "\n".join(lines)
