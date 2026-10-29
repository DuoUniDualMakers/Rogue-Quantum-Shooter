extends GutTest

const MainScene := preload("res://scenes/main.tscn")

var _main: Node2D
var _player
var _hud: Hud


func before_each() -> void:
	_main = add_child_autofree(MainScene.instantiate())
	_player = _main.get_node("Player")
	_hud = _main.get_node("HUD")


func test_hud_starts_with_alive_state() -> void:
	assert_string_contains(_hud.get_node("StateLabel").text, "alive")


func test_hit_updates_hud() -> void:
	_player.take_hit()

	assert_string_contains(_hud.get_node("StateLabel").text, "safe")


func test_death_shows_game_over_and_stops_player() -> void:
	_player.died.emit()

	assert_true(_hud.get_node("GameOverLabel").visible)
	assert_false(_player.is_physics_processing())
