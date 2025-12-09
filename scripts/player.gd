extends CharacterBody2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 80.0
const ACCELERATION = 800.0
const FRICTION = 200.0
const JUMP_VELOCITY = -400.0
const RUN_MULTIPLIER = 1.7

const FALL_MULTIPLIER = 0.3     
const LOW_JUMP_MULTIPLIER = 2.0  

func _physics_process(delta: float) -> void:
	# PULO (início)
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# GRAVIDADE + AJUSTE DO PULO
	if not is_on_floor():
		# gravidade base
		velocity += get_gravity() * delta

		# se estiver caindo
		if velocity.y > 0.0:
			velocity += get_gravity() * (FALL_MULTIPLIER - 1.0) * delta
		# se estiver subindo mas o botão já foi solto, corta o pulo
		elif velocity.y < 0.0 and not Input.is_action_pressed("jump"):
			velocity += get_gravity() * (LOW_JUMP_MULTIPLIER - 1.0) * delta

	# MOVIMENTO HORIZONTAL + CORRIDA
	var direction := Input.get_axis("left", "right")
	var is_running := Input.is_action_pressed("run")

	var target_speed := SPEED
	if is_running:
		target_speed *= RUN_MULTIPLIER

	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * target_speed, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, FRICTION * delta)

	# ANIMAÇÕES
	if is_on_floor():
		if direction != 0:
			anim.flip_h = direction < 0
			anim.play("walk") 
		else:
			anim.play("idle")
	else:
		anim.play("jump")

	move_and_slide()
