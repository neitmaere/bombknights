extends StaticBody2D

signal exploded  # Signal für die Explosion
signal player_left_bomb  # Signal wird gesendet, wenn der Spieler weggeht

@onready var collision_shape = $CollisionShape2D

@export var explosion_scene: PackedScene  # Explosion-Szene
@export var explosion_range: int = 3  # Wie viele Tiles weit die Explosion geht

var tile_size = 122  # Tile-Größe im Raster

func _ready():
	# Deaktiviere die Kollision zu Beginn
	collision_shape.set_deferred("disabled", true)
	

func _on_player_left_bomb() -> void:
	# Aktiviert die Kollision, wenn der Spieler das Signal sendet
	collision_shape.set_deferred("disabled", false)
	print("Player left bomb")
	



func _on_detonation_timer_timeout() -> void:
	explode()
	queue_free()
	
func explode():
	# Explosion auslösen und Signal senden
	exploded.emit()  

	# Bombe unsichtbar machen
	visible = false  
	collision_shape.set_deferred("disabled", true)

	# Explosionseffekte in vier Richtungen erzeugen
	spawn_explosion(global_position)  # Zentrale Explosion

	# Vier Richtungen: Oben, Unten, Links, Rechts
	var directions = [
		Vector2(0, -1),  # Oben
		Vector2(0, 1),   # Unten
		Vector2(-1, 0),  # Links
		Vector2(1, 0)    # Rechts
	]

	for dir in directions:
		for i in range(1, explosion_range + 1):
			var explosion_pos = global_position + (dir * tile_size * i)
			if is_tile_blocked(explosion_pos):  # Stoppt, falls Block vorhanden
				break
			spawn_explosion(explosion_pos)

	# Bombe löschen, nachdem die Explosion gestartet wurde
	await get_tree().create_timer(0.5).timeout  
	queue_free()

func spawn_explosion(pos):
	if explosion_scene:
		var explosion_instance = explosion_scene.instantiate()
		explosion_instance.global_position = pos
		get_parent().add_child(explosion_instance)

func is_tile_blocked(pos) -> bool:
	# Prüft, ob an der Position eine Kollision mit einer Wand oder einem Block ist
	var tilemap : TileMapLayer = get_parent().get_node("Level/Walls")  # Referenz zur TileMap
	var tile_coords = tilemap.local_to_map(pos)
	var tile_data = tilemap.get_cell_source_id(tile_coords)  # Holt Tile-Daten

	# Falls das Tile eine Wand ist (muss angepasst werden, falls du Tile-Layer benutzt)
	if tile_data != -1:  # Falls es ein gesetztes Tile gibt
		return true

	return false
