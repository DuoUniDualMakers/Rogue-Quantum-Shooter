extends CharacterBody2D

@onready var muzzle: Marker2D = $Gun/Muzzle
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var gun_sound: AudioStreamPlayer2D = $Gun/GunSound
@onready var bullet_particles: GPUParticles2D = $Gun/BulletParticles


const BULLET_PARTICLE = preload("uid://bcd2khv5ox1be")

const SPEED = 300.0

var last_direction: Vector2 = Vector2.DOWN
var is_shooting: bool = false





@export var fire_rate: float = 0.12

var fire_timer: float = 0.0

func _physics_process(delta: float) -> void:
	
	fire_timer = maxf(0.0, fire_timer - delta)
	
	if Input.is_action_pressed("shoot") and fire_timer <= 0:
		shoot()
		fire_timer = fire_rate
	
	
	process_movement()
	process_animation()
	move_and_slide()

# ---------------------
# Movement & Animation
# ---------------------

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
		
	

# ---------------------
# Combat
# ---------------------


func shoot() -> void:
	print("Shoot called")
	
	var bullet = BULLET_PARTICLE.instantiate()

	var direction := (
	get_global_mouse_position() - muzzle.global_position
	).normalized()

	get_tree().current_scene.add_child(bullet)

	bullet.global_position = muzzle.global_position
	bullet.global_rotation = direction.angle()

	bullet.emitting = true
	bullet.finished.connect(bullet.queue_free)

	gun_sound.play()

	
	
	
	
