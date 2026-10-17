extends CanvasLayer

@onready var start_button: Button = $Center/Box/StartButton

func _ready() -> void:
	if Settings.tutorial_seen:
		visible = false # Игрок уже видел обучение
		return
	get_tree().paused = true # Игра ждёт, пока игрок прочитает
	start_button.pressed.connect(_on_start)
	start_button.grab_focus()
	
func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled() # Esc не открывает паузу поверх обучения
		
func _on_start() -> void:
	Sfx.play("click")
	Settings.tutorial_seen = true
	Settings.save()
	visible = false
	get_tree().paused = false
