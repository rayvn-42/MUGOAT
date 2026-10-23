extends CharacterBody2D

const SPEED = 289.0
const JUMP_VELOCITY = -350.0
const ACCELERATION = 1200.0
const FRICTION = 1500.0
const MAX_JUMPS = 7

@onready var sprite_2d = $AnimatedSprite2D

var jumps_left = MAX_JUMPS

func _physics_process(delta: float) -> void:
	if is_on_floor():
		jumps_left = MAX_JUMPS
	else:
		velocity += get_gravity() * delta

	var direction := Input.get_axis("left", "right")

	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta)
		sprite_2d.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

	if Input.is_action_just_pressed("secret_quad_jump") and jumps_left > 0:
		velocity.y = JUMP_VELOCITY
		jumps_left -= 1
	elif Input.is_action_just_pressed("jump") and jumps_left == MAX_JUMPS:
		velocity.y = JUMP_VELOCITY
		jumps_left -= 1

	if not is_on_floor():
		if sprite_2d.animation != "Jump":
			sprite_2d.play("Jump")
	elif direction != 0:
		if sprite_2d.animation != "Run":
			sprite_2d.play("Run")
	else:
		if sprite_2d.animation != "Idle":
			sprite_2d.play("Idle")

	move_and_slide()
