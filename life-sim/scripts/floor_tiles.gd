extends TileMapLayer

@export var floor_tile := Vector2i(24,0) # Каждая плитка с листа: столбец и строка

func _ready() -> void:
	for x in 12:
		for y in 7:
			set_cell(Vector2i(x, y), 0, floor_tile) # 0 - номер нашего листа в TileSet, floor_tile - какая плитка
