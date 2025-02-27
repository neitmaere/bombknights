extends CharacterBody2D

@export var speed: float = 200.0
@export var rotation_speed: float = 0.1  # Je kleiner der Wert, desto weicher die Drehung
@export var slide_speed: float = 600.0  # Geschwindigkeit beim Sliden
@export var slide_distance: float = 512.0  # 2 Tiles weit (128px * 2)
@export var slide_duration: float = 0.4  # Wie lange das Slide dauert

@onready var anim_player = $AnimationPlayer  # AnimationPlayer referenzieren

var is_sliding = false
var slide_direction = Vector2.ZERO
var last_valid_direction = Vector2.RIGHT  # Speichert die letzte echte Richtung


func _physics_process(delta):

	if is_sliding:
		move_and_slide()
		return  # Keine normale Bewegung während des Slides	
		
	var direction = Vector2.ZERO

	if Input.is_action_pressed("up"):
		direction.y -= 1
	if Input.is_action_pressed("down"):
		direction.y += 1
	if Input.is_action_pressed("left"):
		print(direction)
		print(rotation)
		direction.x -= 1
	if Input.is_action_pressed("right"):
		direction.x += 1

	if direction != Vector2.ZERO:
		direction = direction.normalized()
		velocity = direction * speed
		
		if direction != Vector2.ZERO:
			last_valid_direction = direction
		
		var target_rotation = lerp_angle(rotation, last_valid_direction.angle(), 1.0)  # Zielrotation berechnen
		var tween = create_tween()
		tween.tween_property(self, "rotation", target_rotation, rotation_speed).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

		
		if not anim_player.is_playing():
			anim_player.play("run")  # Animation starten
	else:
		velocity = Vector2.ZERO
		anim_player.stop()  # Animation stoppen
	
	if Input.is_action_just_pressed("slide") and direction != Vector2.ZERO:
		start_slide(direction)

	move_and_slide()
	
func start_slide(direction: Vector2):
	is_sliding = true
	print(direction)
	slide_direction = direction
	velocity = slide_direction * slide_speed
	
	rotation = slide_direction.angle()

	var tween = create_tween()
	tween.tween_property(self, "velocity", Vector2.ZERO, slide_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	await get_tree().create_timer(slide_duration).timeout  # Warte, bis das Slide vorbei ist
	is_sliding = false
