class_name Hud
extends CanvasLayer

const STATE_TEXT := {
	QuantumState.State.ALIVE: "|1> alive",
	QuantumState.State.MINUS: "|-> safe",
	QuantumState.State.PLUS: "|+> doomed",
	QuantumState.State.DEAD: "|0> dead",
}

@onready var _state_label: Label = $StateLabel
@onready var _game_over_label: Label = $GameOverLabel


func show_state(state: QuantumState.State) -> void:
	_state_label.text = STATE_TEXT.get(state, "unknown")


func show_game_over() -> void:
	_game_over_label.visible = true
