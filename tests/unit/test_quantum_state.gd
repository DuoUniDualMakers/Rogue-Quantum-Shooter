extends GutTest

const MARGIN := 0.0001

var _rng: RandomNumberGenerator
var _quantum: QuantumState


func before_each() -> void:
	_rng = RandomNumberGenerator.new()
	_rng.seed = 42
	_quantum = QuantumState.new(_rng)


func test_starts_alive() -> void:
	assert_almost_eq(_quantum.probability_alive(), 1.0, MARGIN)
	assert_eq(_quantum.state(), QuantumState.State.ALIVE)


func test_first_hit_enters_minus_superposition() -> void:
	_quantum.apply_gate(QuantumState.Gate.H)

	assert_almost_eq(_quantum.probability_alive(), 0.5, MARGIN)
	assert_eq(_quantum.state(), QuantumState.State.MINUS)


func test_hadamard_twice_restores_state() -> void:
	_quantum.apply_gate(QuantumState.Gate.H)
	_quantum.apply_gate(QuantumState.Gate.H)

	assert_almost_eq(_quantum.probability_alive(), 1.0, MARGIN)
	assert_eq(_quantum.state(), QuantumState.State.ALIVE)


func test_z_flips_phase_without_changing_probability() -> void:
	_quantum.apply_gate(QuantumState.Gate.H)
	_quantum.apply_gate(QuantumState.Gate.Z)

	assert_almost_eq(_quantum.probability_alive(), 0.5, MARGIN)
	assert_eq(_quantum.state(), QuantumState.State.PLUS)


func test_x_swaps_basis_states() -> void:
	_quantum.apply_gate(QuantumState.Gate.X)

	assert_almost_eq(_quantum.probability_alive(), 0.0, MARGIN)
	assert_eq(_quantum.state(), QuantumState.State.DEAD)


func test_level_gate_passes_minus() -> void:
	_quantum.apply_gate(QuantumState.Gate.H)
	assert_eq(_quantum.state(), QuantumState.State.MINUS)

	_quantum.apply_gate(QuantumState.Gate.H)

	assert_eq(_quantum.state(), QuantumState.State.ALIVE)


func test_level_gate_kills_plus() -> void:
	_quantum.apply_gate(QuantumState.Gate.H)
	_quantum.apply_gate(QuantumState.Gate.Z)
	assert_eq(_quantum.state(), QuantumState.State.PLUS)

	_quantum.apply_gate(QuantumState.Gate.H)

	assert_eq(_quantum.state(), QuantumState.State.DEAD)


func test_luck_reduces_death_chance() -> void:
	_quantum.apply_gate(QuantumState.Gate.H)

	assert_almost_eq(_quantum.death_chance(0.0), 0.5, MARGIN)
	assert_almost_eq(_quantum.death_chance(0.5), 0.3, MARGIN)
	assert_almost_eq(_quantum.death_chance(1.0), 0.1, MARGIN)


func test_luck_is_clamped() -> void:
	_quantum.apply_gate(QuantumState.Gate.H)

	assert_almost_eq(_quantum.death_chance(-1.0), 0.5, MARGIN)
	assert_almost_eq(_quantum.death_chance(2.0), 0.1, MARGIN)


func test_measure_alive_state_never_kills() -> void:
	assert_eq(_quantum.measure(0.0), QuantumState.State.ALIVE)
	assert_eq(_quantum.state(), QuantumState.State.ALIVE)


func test_measure_collapses_and_reports() -> void:
	_quantum.apply_gate(QuantumState.Gate.H)
	watch_signals(_quantum)

	var result := _quantum.measure(0.0)

	assert_signal_emitted(_quantum, "collapsed")
	assert_true(result == QuantumState.State.ALIVE or result == QuantumState.State.DEAD)
	assert_eq(_quantum.state(), result)


func test_measure_leaves_definite_state() -> void:
	_quantum.apply_gate(QuantumState.Gate.H)

	_quantum.measure(0.5)

	var alive_chance := _quantum.probability_alive()
	assert_true(alive_chance == 0.0 or alive_chance == 1.0)


func test_first_hit_enters_minus() -> void:
	assert_eq(_quantum.resolve_hit(0.0, 0.99), QuantumState.State.MINUS)


func test_surviving_in_minus_flips_to_plus() -> void:
	_quantum.resolve_hit(0.0, 0.99)

	assert_eq(_quantum.resolve_hit(0.0, 0.99), QuantumState.State.PLUS)


func test_lethal_roll_in_minus_collapses_to_dead() -> void:
	_quantum.resolve_hit(0.0, 0.99)

	assert_eq(_quantum.resolve_hit(0.0, 0.0), QuantumState.State.DEAD)


func test_surviving_in_plus_stays_in_plus() -> void:
	_quantum.resolve_hit(0.0, 0.99)
	_quantum.resolve_hit(0.0, 0.99)

	assert_eq(_quantum.resolve_hit(0.0, 0.99), QuantumState.State.PLUS)


func test_plus_is_deadlier_than_minus() -> void:
	assert_gt(
		_quantum.death_chance(0.0, QuantumState.PLUS_DEATH_BASE),
		_quantum.death_chance(0.0, QuantumState.MINUS_DEATH_BASE)
	)


func test_die_collapses_to_dead() -> void:
	_quantum.apply_gate(QuantumState.Gate.H)

	_quantum.die()

	assert_eq(_quantum.state(), QuantumState.State.DEAD)
