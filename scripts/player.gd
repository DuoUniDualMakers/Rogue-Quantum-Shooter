extends CharacterBody2D


const SPEED = 300.0

var last_direction: Vector2 = Vector2.DOWN

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# ---------------------
# Movement & Animation
# ---------------------

func _physics_process(_delta: float) -> void:
	process_movement()
	process_animation()
	move_and_slide()


func process_movement() -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("left", "right", "up", "down")
	
	if direction != Vector2.ZERO:
		velocity = direction * SPEED
		last_direction = direction
	else:
		velocity = Vector2.ZERO
	
	

func process_animation() -> void:
	if velocity != Vector2.ZERO:
		play_animation("running", last_direction)
	else:
		play_animation("idle", last_direction)


func play_animation(prefix: String, dir: Vector2) -> void:
	if dir.x > 0:
		if dir.y < 0:
			animated_sprite_2d.play(prefix + "_north_east")
		elif dir.y > 0:
			animated_sprite_2d.play(prefix + "_south_east")
		else:
			animated_sprite_2d.play(prefix + "_east")
	elif dir.x < 0:
		if dir.y < 0:
			animated_sprite_2d.play(prefix + "_north_west")
		elif dir.y > 0:
			animated_sprite_2d.play(prefix + "_south_west")
		else:
			animated_sprite_2d.play(prefix + "_west")
	else:
		if dir.y < 0:
			animated_sprite_2d.play(prefix + "_north")
		else:
			animated_sprite_2d.play(prefix + "_south")
		
	
