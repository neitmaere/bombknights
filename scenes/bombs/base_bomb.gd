extends StaticBody2D

signal player_left_bomb  # Signal wird gesendet, wenn der Spieler weggeht

@onready var collision_shape = $CollisionShape2D

func _ready():
	# Deaktiviere die Kollision zu Beginn
	collision_shape.set_deferred("disabled", true)
	
	



func _on_player_left_bomb() -> void:
	# Aktiviert die Kollision, wenn der Spieler das Signal sendet
	collision_shape.set_deferred("disabled", false)
	print("Player left bomb")
