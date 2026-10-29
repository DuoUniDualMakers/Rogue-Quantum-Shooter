class_name QuantumState
extends RefCounted

signal changed
signal collapsed(from_state: State, to_state: State)

enum State { ALIVE, PLUS, MINUS, DEAD }
enum Gate { H, X, Z }

const EPSILON := 0.000001
const INV_SQRT_2 := 0.7071067811865476
const LUCK_WEIGHT := 0.8
const MINUS_DEATH_BASE := 0.5
const PLUS_DEATH_BASE := 0.8

var _amp_zero := Vector2.ZERO
var _amp_one := Vector2(1.0, 0.0)
var _rng: RandomNumberGenerator


func _init(rng: RandomNumberGenerator) -> void:
	_rng = rng


func probability_alive() -> float:
	return _amp_one.x * _amp_one.x + _amp_one.y * _amp_one.y


func death_chance(luck: float, base_chance: float = -1.0) -> float:
	var base := base_chance if base_chance >= 0.0 else 1.0 - probability_alive()
	var luck_scale := 1.0 - LUCK_WEIGHT * clampf(luck, 0.0, 1.0)
	return base * luck_scale


func state() -> State:
	var alive_chance := probability_alive()
	if alive_chance > 1.0 - EPSILON:
		return State.ALIVE
	if alive_chance < EPSILON:
		return State.DEAD
	return State.PLUS if _phase_is_positive() else State.MINUS


func apply_gate(gate: Gate) -> void:
	match gate:
		Gate.H:
			var zero := _amp_zero
			var one := _amp_one
			_amp_zero = (zero + one) * INV_SQRT_2
			_amp_one = (zero - one) * INV_SQRT_2
		Gate.X:
			var zero := _amp_zero
			_amp_zero = _amp_one
			_amp_one = zero
		Gate.Z:
			_amp_one = -_amp_one
	changed.emit()


func die() -> void:
	var previous := state()
	_amp_zero = Vector2(1.0, 0.0)
	_amp_one = Vector2.ZERO
	changed.emit()
	if previous != State.DEAD:
		collapsed.emit(previous, State.DEAD)


func resolve_hit(luck: float, roll: float) -> State:
	match state():
		State.ALIVE:
			apply_gate(Gate.H)
		State.MINUS:
			if roll < death_chance(luck, MINUS_DEATH_BASE):
				die()
			else:
				apply_gate(Gate.Z)
		State.PLUS:
			if roll < death_chance(luck, PLUS_DEATH_BASE):
				die()
		State.DEAD:
			pass
	return state()


func measure(luck: float = 0.0) -> State:
	var previous := state()
	var dead := _rng.randf() < death_chance(luck)
	_amp_zero = Vector2(1.0, 0.0) if dead else Vector2.ZERO
	_amp_one = Vector2.ZERO if dead else Vector2(1.0, 0.0)
	var current := State.DEAD if dead else State.ALIVE
	changed.emit()
	if current != previous:
		collapsed.emit(previous, current)
	return current


func _phase_is_positive() -> bool:
	var relative_phase := atan2(_amp_one.y, _amp_one.x) - atan2(_amp_zero.y, _amp_zero.x)
	return cos(relative_phase) >= 0.0
