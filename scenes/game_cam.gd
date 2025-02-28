extends Camera2D

@export var tile_map: TileMapLayer  # Verknüpfe die TileMap im Inspector

func _ready():
	adjust_camera()
	get_viewport().size_changed.connect(_on_viewport_resized)  # Event für Fenstergröße-Änderung

func _on_viewport_resized():
	adjust_camera()

func adjust_camera():
	if not tile_map:
		return

	# Spielfeldgröße in Pixeln berechnen
	var used_rect = tile_map.get_used_rect()
	var tile_size = tile_map.tile_set.tile_size
	var field_size = used_rect.size * tile_size

	# Fenstergröße holen
	var screen_size = get_viewport_rect().size

	# Berechne den optimalen Zoom basierend auf Spielfeld- und Fenstergröße
	var zoom_x = screen_size.x / field_size.x
	var zoom_y = screen_size.y / field_size.y

	# Verwende den kleineren Zoom-Faktor, um das ganze Spielfeld sichtbar zu machen
	zoom = Vector2(zoom_x, zoom_y) * 0.95  # 0.95 für etwas Rand

	# Setze die Kamera in die Mitte des Spielfelds
	position = used_rect.position * tile_size + field_size / 2
