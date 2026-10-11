extends Area2D

@export_file("*.tscn") var target_room : String # Куда ведёт дверь
@export var spawn_position := Vector2(100,250) # Где появится персонаж в новой комнате

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	monitoring = false # Дверь "спит", пока физика не поймёт, где персонаж
	var timer := Timer.new()
	timer.one_shot = true
	timer.wait_time = 0.3
	timer.timeout.connect(func(): monitoring = true)
	add_child(timer)
	timer.start()
	
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		# call_deferred - выполнить чуть позже, в безопасный момент. Менять сцену во время столкновения нельзя
		Sfx.play("door")
		get_tree().current_scene.change_room.call_deferred(target_room, spawn_position)
