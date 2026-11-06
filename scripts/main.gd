extends Node2D

@onready var _player = $Player
@onready var _hud: Hud = $HUD

@onready var _timer = $EndOfLevelTimer
@onready var _tilemap = $LevelRoot/TopTileMapLayer

func _ready() -> void:
	_player.quantum_state_changed.connect(_hud.show_state)
	_player.quantum_state_changed.connect(_on_quantum_state_changed)
	_player.died.connect(_on_player_died)
	_hud.show_state(_player.quantum_state())

	_timer.timeout.connect(_on_timer_timeout)
	_timer.start()

func _on_player_died() -> void:
	_player.set_physics_process(false)
	_hud.show_game_over()


func _on_quantum_state_changed(state: QuantumState.State) -> void:
	if state == QuantumState.State.ALIVE:
		_player.set_physics_process(true)
		_hud.hide_game_over()


func _on_timer_timeout() -> void:
	# Find player's grid cell
	var player_cell = _tilemap.local_to_map(_player.global_position)
	var spawn_cell = player_cell + _player.facing_direction
	
	_tilemap.set_cell(spawn_cell, 0, Vector2i(16,13))
	
	_hud.show_escape_label()
	
func _process(_delta: float) -> void:
	# Only update the HUD if the timer is actually running
	if not _timer.is_stopped():
		_hud.update_timer_display(_timer.time_left)
