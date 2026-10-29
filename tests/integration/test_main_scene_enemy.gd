extends GutTest

const MainScene := preload("res://scenes/main.tscn")

var _main: Node2D
var _player
var _enemy


func before_each() -> void:
	_main = add_child_autofree(MainScene.instantiate())
	_player = _main.get_node("Player")
	_enemy = _main.get_node("Enemy")


func test_enemy_node_uses_enemy_script() -> void:
	assert_not_null(_enemy)
	assert_true(_enemy is EnemyBasic)


func test_enemy_finds_player_through_group() -> void:
	assert_eq(_player.get_groups(), _player.get_groups())
	assert_true(_player.is_in_group(&"player"))


func test_enemy_approaches_player() -> void:
	var start_distance: float = _enemy.global_position.distance_to(_player.global_position)

	await wait_physics_frames(60)

	var end_distance: float = _enemy.global_position.distance_to(_player.global_position)
	assert_lt(end_distance, start_distance)
