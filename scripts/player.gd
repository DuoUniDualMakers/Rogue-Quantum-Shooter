extends CharacterBody2D

@onready var muzzle: Marker2D = $Gun/Muzzle
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var gun_sound: AudioStreamPlayer2D = $Gun/GunSound
@onready var bullet_particles: GPUParticles2D = $Gun/BulletParticles


const BULLET_PARTICLE = preload("uid://bcd2khv5ox1be")

const SPEED = 300.0

var last_direction: Vector2 = Vector2.DOWN
var is_shooting: bool = false




@export var bullet_scene: PackedScene
@export var entangle_bullet_scene: PackedScene
@export var fire_rate: float = 0.15
@export var bullet_spread: float = 5.0

@onready var hud: Hud = get_tree().current_scene.get_node("HUD")

var x_gate_charges: int = 5

var fire_timer: float = 0.0

signal quantum_state_changed(state: QuantumState.State)
signal died

var _rng := RandomNumberGenerator.new()
var _quantum: QuantumState


func _ready() -> void:
	_rng.randomize()
	_quantum = QuantumState.new(_rng)

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
	
	var direction := (
		get_global_mouse_position() - muzzle.global_position
	).normalized()

	# Random bullet spread
	var spread := deg_to_rad(randf_range(-bullet_spread, bullet_spread))
	direction = direction.rotated(spread)

	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)

	bullet.setup(muzzle.global_position, direction)

	gun_sound.play()


func quantum_state() -> QuantumState.State:
	return _quantum.state()


func take_hit(luck: float = 0.0) -> QuantumState.State:
	var previous := _quantum.state()
	var state := _quantum.resolve_hit(luck, _rng.randf())
	quantum_state_changed.emit(state)
	if state == QuantumState.State.DEAD and previous != QuantumState.State.DEAD:
		died.emit()
	return state

# x gate application
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and not event.echo and event.keycode == KEY_X:
			apply_x_gate()
		if event.pressed and not event.echo and event.keycode == KEY_E:
			shoot_entangle()

func apply_x_gate() -> void:
	if x_gate_charges <= 0:
		print("No X Gate charges left!")
		return

	x_gate_charges -= 1
	hud.update_x_gate_charges(x_gate_charges)
	
	var previous := _quantum.state()
	_quantum.apply_gate(QuantumState.Gate.X)
	var current := _quantum.state()

	quantum_state_changed.emit(current)

	if current == QuantumState.State.DEAD and previous != QuantumState.State.DEAD:
		died.emit()
		
func shoot_entangle() -> void:
	if entangle_bullet_scene == null:
		return

	var direction := (
		get_global_mouse_position() - muzzle.global_position
	).normalized()

	var bullet = entangle_bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)

	bullet.setup(muzzle.global_position, direction)

	gun_sound.play()
	
func entangle_collapse_to_dead() -> void:
	var previous := _quantum.state()

	_quantum.die()

	var current := _quantum.state()
	quantum_state_changed.emit(current)

	if previous != QuantumState.State.DEAD:
		died.emit()


func entangle_collapse_to_alive() -> void:
	_quantum.collapse_to_alive()

	var current := _quantum.state()
	quantum_state_changed.emit(current)
	
	
	
	
