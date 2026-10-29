extends GutTest

const PlayerScene := preload("res://scenes/player.tscn")

var _player


func before_each() -> void:
	_player = add_child_autofree(PlayerScene.instantiate())


func test_starts_alive() -> void:
	assert_eq(_player.quantum_state(), QuantumState.State.ALIVE)


func test_first_hit_enters_superposition() -> void:
	_player.take_hit()

	assert_eq(_player.quantum_state(), QuantumState.State.MINUS)


func test_second_hit_collapses_to_basis_state() -> void:
	_player.take_hit()
	_player.take_hit()

	assert_ne(_player.quantum_state(), QuantumState.State.MINUS)


func test_hit_emits_state_change() -> void:
	watch_signals(_player)

	_player.take_hit()

	assert_signal_emitted(_player, "quantum_state_changed")
