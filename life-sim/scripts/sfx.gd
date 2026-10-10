extends Node

const SOUNDS := { # Название звука -> файл
	"click": preload("res://assets/kenney_interface_sounds/Audio/click_001.ogg"),
	"confirm": preload("res://assets/kenney_interface_sounds/Audio/confirmation_001.ogg"),
	"open": preload("res://assets/kenney_interface_sounds/Audio/open_001.ogg"),
	"close": preload("res://assets/kenney_interface_sounds/Audio/close_001.ogg"),
	"eat": preload("res://assets/kenney_rpg_audio/Audio/metalPot1.ogg"),
	"sleep": preload("res://assets/kenney_rpg_audio/Audio/cloth1.ogg"),
	"piano": preload("res://assets/kenney_interface_sounds/Audio/pluck_001.ogg"),
	"door": preload("res://assets/kenney_rpg_audio/Audio/doorOpen_1.ogg"),
	"step": preload("res://assets/kenney_rpg_audio/Audio/footstep00.ogg"),
}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS # Звуки должны играть и во время паузы (клики в меню)
	
func play(sound_name: String, pitch_variation := 0.0, volume_db := 0.0) -> void:
	if not SOUNDS.has(sound_name):
		return # Нет такого звука, просто молчим
	var player := AudioStreamPlayer.new() # Создаём проигрыватель на лету
	player.stream = SOUNDS[sound_name]
	player.pitch_scale = 1.0 + randf_range(-pitch_variation, pitch_variation) # Небольшой разброс высоты
	player.volume_db = volume_db # Громкость в децибелах: 0 - как есть, минус - тише
	player.bus = "SFX"
	player.finished.connect(player.queue_free) # Когда доиграл, удаляем
	add_child(player)
	player.play()
