extends Area2D
signal hit

export var speed = 400
# Prefix de les accions d'input. Jugador 1: "move_" (WASD), jugador 2: "p2_move_" (fletxes).
export var input_prefix = "move_"
# To del so dels passos (així cada jugador sona diferent).
export var step_pitch = 1.0
var screen_size
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()
	$StepSound.pitch_scale = step_pitch
func _process(delta):
	var velocity = Vector2.ZERO # Vector de moviment del jugador.
	if Input.is_action_pressed(input_prefix + "right"):
		velocity.x += 1
	if Input.is_action_pressed(input_prefix + "left"):
		velocity.x -= 1
	if Input.is_action_pressed(input_prefix + "down"):
		velocity.y += 1
	if Input.is_action_pressed(input_prefix + "up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
		# So de passos mentre el jugador es mou.
		if visible and not $StepSound.playing:
			$StepSound.play()
	else:
		$AnimatedSprite.stop()
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _on_Player_body_entered(body):
	hide() # El jugador desapareix després de ser impactat.
	emit_signal("hit")
# S'ha d'ajornar, ja que no podem canviar les propietats físiques en una crida de retorn de física.
	$CollisionShape2D.set_deferred("disabled", true)
