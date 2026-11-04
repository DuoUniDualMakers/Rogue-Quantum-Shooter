extends Node2D

@export var enemy_scene: PackedScene


@export var spawn_interval: float = 2.5
@export var min_spawn_distance: float = 500.0
@export var max_spawn_distance: float = 700.0
@export var max_enemies: int = 20

var rng := RandomNumberGenerator.new()


func _ready() -> void:
	rng.randomize()

	var timer := Timer.new()
	timer.wait_time = spawn_interval
	timer.timeout.connect(spawn_enemy)

	add_child(timer)
	timer.start()
	

func spawn_enemy() -> void:

	# Find the player
	var player = get_tree().get_first_node_in_group("player")

	if player == null:
		return

	if enemy_scene == null:
		return

	# Check enemy limit
	if get_tree().get_nodes_in_group("enemies").size() >= max_enemies:
		return

	# Pick a random direction
	var angle := rng.randf_range(0.0, TAU)

	# Pick a random distance
	var distance := rng.randf_range(
		min_spawn_distance,
		max_spawn_distance
	)

	# Calculate spawn position
	var spawn_position = player.global_position + Vector2.RIGHT.rotated(angle) * distance

	# Create enemy instance
	var enemy = enemy_scene.instantiate()

	get_tree().current_scene.add_child(enemy)

	enemy.global_position = spawn_position

	# Tell enemy who to chase
	enemy.set_target(player)
