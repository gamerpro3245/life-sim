extends Area2D

@export_file("*.tscn") var target_room : String # Куда ведёт дверь
@export var spawn_position := Vector2(100,250) # Где появится персонаж в новой комнате

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		# call_deferred - выполнить чуть позже, в безопасный момент. Менять сцену во время столкновения нельзя
		get_tree().current_scene.change_room.call_deferred(target_room, spawn_position)
