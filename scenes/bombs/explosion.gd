extends Node2D


func _on_explosion_duration_timeout() -> void:
	queue_free()
