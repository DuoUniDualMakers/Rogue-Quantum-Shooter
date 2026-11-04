extends Node2D

@onready var _player = $Player
@onready var _hud: Hud = $HUD


func _ready() -> void:
	_player.quantum_state_changed.connect(_hud.show_state)
	_player.quantum_state_changed.connect(_on_quantum_state_changed)
	_player.died.connect(_on_player_died)
	_hud.show_state(_player.quantum_state())


func _on_player_died() -> void:
	_player.set_physics_process(false)
	_hud.show_game_over()


func _on_quantum_state_changed(state: QuantumState.State) -> void:
	if state == QuantumState.State.ALIVE:
		_player.set_physics_process(true)
		_hud.hide_game_over()
