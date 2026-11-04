extends Area2D

@export var speed: float = 250.0
@export var lifetime: float = 1.3
@export var trail_length: float = 35.0

var direction: Vector2 = Vector2.RIGHT
var traveled_time: float = 0.0

@onready var trail: Line2D = $Trail

@onready var hud: Hud = get_tree().current_scene.get_node("HUD")

func _ready() -> void:
	body_entered.connect(_on_body_entered)

	trail.top_level = true
	trail.width = 5.0
	trail.default_color = Color(0.6, 0.2, 1.0, 0.95)

func setup(start_position: Vector2, shot_direction: Vector2) -> void:
	global_position = start_position
	direction = shot_direction.normalized()
	rotation = direction.angle()

func _physics_process(delta: float) -> void:
	traveled_time += delta

	if traveled_time >= lifetime:
		queue_free()
		return

	global_position += direction * speed * delta

	trail.clear_points()
	trail.add_point(global_position)
	trail.add_point(global_position - direction * trail_length)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		return

	if body.is_in_group("enemies"):
		_entangle(body)
		queue_free()

func _entangle(enemy: Node2D) -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return

	var rng := RandomNumberGenerator.new()
	rng.randomize()

	if rng.randf() < 0.5:
		# Player collapses to DEAD. Enemy survives.
		player.entangle_collapse_to_dead()
		hud.show_entanglement_result("ENTANGLEMENT: PLAYER COLLAPSED TO DEAD!")
	else:
		# Enemy dies. Player collapses to ALIVE.
		if enemy.has_method("take_damage"):
			enemy.take_damage(999999.0)

		player.entangle_collapse_to_alive()
		hud.show_entanglement_result("ENTANGLEMENT: ENEMY COLLAPSED TO DEAD! PLAYER COLLAPSED TO ALIVE!")
