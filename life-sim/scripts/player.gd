extends CharacterBody2D

const SPEED := 200.0

func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") # Смотрит управление и возвращает направление
	velocity = direction * SPEED # Скорость
	move_and_slide() # Реально двигает персонажа и не пускает его сквозь стены
