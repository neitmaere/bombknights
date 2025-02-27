extends Node2D


func _on_explosion_duration_timeout() -> void:
	queue_free()


func _on_explosion_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Player hit" + body.to_string())
	elif body.is_in_group("Bomb"):
		print("is bomb: " + body.to_string() )
		body.exploded.emit()
		body.queue_free()
