extends AudioStreamPlayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS # Музыка не замолкает на паузе
	stream = preload("res://assets/music/Heavenly Loop.ogg")
	bus = "Music"
	play()
