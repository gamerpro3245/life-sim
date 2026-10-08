extends Area2D

@export var need := "hunger" # Показывает переменную в Inspector
@export var amount := 40.0
@export var color := Color.WHITE

var player_inside: Node2D = null

func _ready() -> void:
	$Body.color = color
	body_entered.connect(_on_body_entered) # Сигнал кто-то зашёл в зону, connect привязываем наши функции
	body_exited.connect(_on_body_exited) # Сигнал кто-то вышел из зоны

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_inside = body
		
func _on_body_exited(body:Node2D) -> void:
	if body == player_inside:
		player_inside = null
		
func _unhandled_input(event: InputEvent) -> void:
	if player_inside and event.is_action_pressed("interact"):
		player_inside.restore(need, amount)
