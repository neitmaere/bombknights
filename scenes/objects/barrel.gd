extends StaticBody2D

var is_barrel = true

func destroy_barrel():
	# Animation oder Effekt hinzufügen
	print("Barrel wurde zerstört!")
	queue_free()  # Barrel entfernen
