extends Node2D

@onready var tilemap = $Level/Ground  # Stelle sicher, dass der Pfad zur TileMap korrekt ist
@onready var player = $Character    # Stelle sicher, dass der Pfad zum Player korrekt ist

@export var bomb_scene: PackedScene  # Referenz zur Bomben-Szene

var last_bomb : StaticBody2D = null  # Speichert die zuletzt platzierte Bombe

func _process(_delta):
	var player_pos = player.global_position  # Hole die globale Position des Spielers
	var player_tile_coords = tilemap.local_to_map(tilemap.to_local(player_pos))  # Konvertiere in Tile-Koordinaten
	
	if Input.is_action_just_pressed("bomb"):
		print("Player steht auf Tile: ", player_tile_coords)
		place_bomb()
			
	if last_bomb and is_instance_valid(last_bomb):
		if player_pos.distance_to(last_bomb.global_position) > 100:
			# Sende Signal an die Bombe, um die Kollision zu aktivieren
			last_bomb.player_left_bomb.emit()
			last_bomb = null  # Zurücksetzen, damit das Signal nicht mehrfach gesendet wird

func place_bomb():
	if bomb_scene:
		# Spielerposition zur Tile-Koordinate umwandeln
		var player_pos = player.global_position
		var tile_coords = tilemap.local_to_map(player_pos)
		var bomb_pos = tilemap.map_to_local(tile_coords)
		
		if is_bomb_at_position(bomb_pos):
			return
			
		var bomb_instance = bomb_scene.instantiate()

		# Setze Bombe auf das Tile-Zentrum
		bomb_instance.global_position = bomb_pos
		add_child(bomb_instance)
		move_child(bomb_instance, player.get_index())
		
		last_bomb = bomb_instance

func is_bomb_at_position(pos) -> bool:  
	for bomb in get_tree().get_nodes_in_group("Bomb"):
		print("bomb ffff")
		if bomb.global_position.distance_to(pos) < 100:
			return true
	return false
