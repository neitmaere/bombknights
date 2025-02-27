extends Node2D

@onready var tilemap = $Level/Ground  # Stelle sicher, dass der Pfad zur TileMap korrekt ist
@onready var player = $Character    # Stelle sicher, dass der Pfad zum Player korrekt ist

func _process(_delta):
	var player_pos = player.global_position  # Hole die globale Position des Spielers
	var tile_coords = tilemap.local_to_map(tilemap.to_local(player_pos))  # Konvertiere in Tile-Koordinaten
	
	if Input.is_action_just_pressed("bomb"):
		print("Player steht auf Tile: ", tile_coords)
