extends GutTest

const EnemyScene := preload("res://scenes/enemies/enemy_basic.tscn")
const PlayerScene := preload("res://scenes/player.tscn")

var _enemy: EnemyBasic
var _player


func before_each() -> void:
	_player = add_child_autofree(PlayerScene.instantiate())
	_enemy = add_child_autofree(EnemyScene.instantiate())
	_enemy.set_target(_player)


func test_starts_idle() -> void:
	assert_eq(_enemy.state(), EnemyBasic.State.IDLE)


func test_chases_target_in_range() -> void:
	_player.global_position = Vector2(120, 0)
	_enemy.global_position = Vector2.ZERO

	await wait_physics_frames(2)

	assert_eq(_enemy.state(), EnemyBasic.State.CHASE)
	assert_lt(_enemy.global_position.distance_to(Vector2.ZERO), 120.0)


func test_attacks_target_in_range() -> void:
	_player.global_position = Vector2(20, 0)
	_enemy.global_position = Vector2.ZERO

	await wait_physics_frames(2)

	assert_eq(_enemy.state(), EnemyBasic.State.ATTACK)
	assert_eq(_player.quantum_state(), QuantumState.State.MINUS)


func test_attack_cooldown_limits_hits() -> void:
	_player.global_position = Vector2(20, 0)
	_enemy.global_position = Vector2.ZERO

	await wait_physics_frames(30)

	assert_eq(_player.quantum_state(), QuantumState.State.MINUS)
