extends CharacterBody2D


const SPEED = 400.0
const JUMP_VELOCITY = -800.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	handle_legs_animations()
# Get a reference to your leg sprite node
@onready var legs_sprite = $Sprite2D/AnimatedSprite2D

func handle_legs_animations():
	# 1. Flip the sprite depending on movement direction
	var direction = Input.get_axis("left", "right")
	if direction > 0:
		legs_sprite.flip_h = false
	elif direction < 0:
		legs_sprite.flip_h = true

	# 2. Determine which animation state to play based on physical movement
	if direction != 0:
		# Player is moving horizontally on the ground
		legs_sprite.play("run")
	elif not is_on_floor():
		# Player is in mid-air (jumping or falling)
		legs_sprite.play("jump")
	else:
		# Player is stationary on the ground
		legs_sprite.play("stand")

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_R:
			get_tree().reload_current_scene()
