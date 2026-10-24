extends Sprite2D

@export var tile_region := Rect2(0, 0, 16, 16) # Какой тайл показывать

func _ready() -> void:
	region_rect = tile_region
