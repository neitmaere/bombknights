extends CharacterBody2D

@export var speed: float = 200.0
@export var rotation_speed: float = 0.1  # Je kleiner der Wert, desto weicher die Drehung

@onready var anim_player = $AnimationPlayer  # AnimationPlayer referenzieren

func _physics_process(delta):
	var direction = Vector2.ZERO

	if Input.is_action_pressed("up"):
		direction.y -= 1
	if Input.is_action_pressed("down"):
		direction.y += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("right"):
		direction.x += 1

	if direction != Vector2.ZERO:
		direction = direction.normalized()
		velocity = direction * speed
		
		var target_rotation = direction.angle()  # Zielrotation berechnen
		var tween = create_tween()
		tween.tween_property(self, "rotation", target_rotation, rotation_speed).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		
		if not anim_player.is_playing():
			anim_player.play("run")  # Animation starten
	else:
		velocity = Vector2.ZERO
		anim_player.stop()  # Animation stoppen

	move_and_slide()
