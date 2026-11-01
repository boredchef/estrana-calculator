extends CharacterBody2D
class_name LittleMan

const SPEED = 200.0
const JUMP_VELOCITY = -320.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
const GRAV_MULTI = 1.1
const DOWN_CONST = 2.25
var down_multi = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		if Input.is_action_just_pressed("Down"):
			down_multi = true
		if down_multi:
			if velocity.y < 0:
				velocity += get_gravity() * delta * DOWN_CONST
			else:
				velocity += get_gravity() * delta * GRAV_MULTI * DOWN_CONST
		else:
			if velocity.y < 0:
				velocity += get_gravity() * delta
			else:
				velocity += get_gravity() * delta * GRAV_MULTI
	#Animation player
	if is_on_floor():
		down_multi = false
		if velocity.x == 0:
			animated_sprite_2d.play("Idle")
		else:
			animated_sprite_2d.play("Walk")
	if not is_on_floor():
		animated_sprite_2d.play("Jump")
	
	#Flip Player
	if velocity.x < 0:
		animated_sprite_2d.flip_h = true
	elif velocity.x > 0:
		animated_sprite_2d.flip_h = false


	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
