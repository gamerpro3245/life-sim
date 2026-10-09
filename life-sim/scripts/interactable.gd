extends Area2D

@export var need := "hunger" # Показывает переменную в Inspector
@export var amount := 40.0
@export var color := Color.WHITE

var player_inside: Node2D = null

func _ready() -> void:
	$Body.color = color
	body_entered.connect(_on_body_entered) # Сигнал кто-то зашёл в зону, connect привязываем наши функции
	body_exited.connect(_on_body_exited) # Сигнал кто-то вышел из зоны
	$Hint.visible = false # Подсказка скрыта

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_inside = body
		$Hint.visible = true # Показывается, когда персонаж стоит в зоне
		
func _on_body_exited(body:Node2D) -> void:
	if body == player_inside:
		player_inside = null
		$Hint.visible = false # Прячется, когда персонаж вышел из зоны
		
func _unhandled_input(event: InputEvent) -> void:
	if player_inside and event.is_action_pressed("interact"):
		var final_amount := amount
		if need == "energy" and GameClock.is_night():
			final_amount *= 1.5 # Ночью сон полезнее
		player_inside.restore(need, final_amount)
