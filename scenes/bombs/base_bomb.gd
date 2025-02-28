extends StaticBody2D

signal player_left_bomb  # Signal wird gesendet, wenn der Spieler weggeht

@onready var collision_shape : CollisionShape2D = $CollisionShape2D

@export var explosion_scene: PackedScene  # Explosion-Szene
@export var explosion_range: int = 3  # Wie viele Tiles weit die Explosion geht

var tile_size = 122  # Tile-Größe im Raster

func _ready():
	# Deaktiviere die Kollision zu Beginn
	collision_shape.disabled = true

func _on_player_left_bomb() -> void:
	# Aktiviert die Kollision, wenn der Spieler das Signal sendet
	collision_shape.disabled = false
	print("Player left bomb")
	
func _on_detonation_timer_timeout() -> void:
	explode()
	
func explode():
	# Bombe unsichtbar machen
	visible = false

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
			elif is_barrel_on_tile(explosion_pos):
				spawn_explosion(explosion_pos)
				break
				
			spawn_explosion(explosion_pos)

	## Bombe löschen, nachdem die Explosion gestartet wurde
	#await get_tree().create_timer(0.5).timeout  
	queue_free()

func spawn_explosion(pos):
	if explosion_scene:
		var explosion_instance = explosion_scene.instantiate()
		explosion_instance.global_position = pos
		get_parent().call_deferred("add_child", explosion_instance)

func is_tile_blocked(pos) -> bool:
	var tilemap = get_parent().get_node("Level/Walls")
	var tile_coords = tilemap.local_to_map(pos)
	var tile_data = tilemap.get_cell_source_id(tile_coords)

	# Prüft, ob es eine Wand oder ein unzerstörbares Objekt ist
	if tile_data != -1:
		return true  # Explosion wird gestoppt

	return false
	
func is_barrel_on_tile(pos) -> bool:
	var tilemap = get_parent().get_node("Level/Walls")
	var tile_coords = tilemap.local_to_map(pos)
	# Prüft, ob ein Barrel an der Position existiert
	for child in get_tree().get_nodes_in_group("Barrel"):
		if child is StaticBody2D and "is_barrel" in child and child.is_barrel:
			var barrel_tile = tilemap.local_to_map(child.global_position)
			if barrel_tile == tile_coords:
				child.destroy_barrel()  # Barrel zerstören
				return true  # Explosion stoppt beim Barrel

	return false
