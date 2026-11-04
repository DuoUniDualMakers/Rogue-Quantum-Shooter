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
@onready var x_gate_label: Label = $XGateLabel
@onready var entanglement_result_label: Label = $EntanglementResult
var entanglement_timer: Timer

func _ready() -> void:
	entanglement_timer = Timer.new()
	entanglement_timer.one_shot = true
	entanglement_timer.wait_time = 1.5
	entanglement_timer.timeout.connect(_on_entanglement_timer_timeout)
	add_child(entanglement_timer)

func _on_entanglement_timer_timeout() -> void:
	entanglement_result_label.visible = false

func show_state(state: QuantumState.State) -> void:
	_state_label.text = STATE_TEXT.get(state, "unknown")

func update_x_gate_charges(amount: int) -> void:
	x_gate_label.text = "X Gate: " + str(amount)

func show_game_over() -> void:
	_game_over_label.visible = true

func hide_game_over() -> void:
	_game_over_label.visible = false
	
func show_entanglement_result(message: String) -> void:
	entanglement_result_label.text = message
	entanglement_result_label.visible = true
	entanglement_timer.start()
