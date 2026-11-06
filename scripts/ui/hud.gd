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
@onready var timer_label: Label = $TimerLabel
@onready var escape_label: Label = $EscapeLabel
@onready var glitch_timer: Timer = $EscapeTimer
var entanglement_timer: Timer

# Store the original position so the glitch can jump back to it
var original_label_pos: Vector2


func _ready() -> void:
	entanglement_timer = Timer.new()
	entanglement_timer.one_shot = true
	entanglement_timer.wait_time = 1.5
	entanglement_timer.timeout.connect(_on_entanglement_timer_timeout)
	add_child(entanglement_timer)
	# Save the starting position
	original_label_pos = escape_label.position
	# Connect the timer
	glitch_timer.timeout.connect(_on_glitch_timer_timeout)

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
	
func update_timer_display(time_left: float) -> void:
	# If time is up, show 0
	if time_left <= 0:
		timer_label.text = "Time: 0.0"
	else:
		# snapped() removes the super long decimal numbers so it looks clean
		timer_label.text = "Time: " + str(snapped(time_left, 0.1))
		
func show_escape_label() -> void:
	escape_label.visible = true
	glitch_timer.start() # Start the 1-second glitch loop

# --- The Glitch Effect ---
func _on_glitch_timer_timeout() -> void:
	if not escape_label.visible:
		return
		
	# Create a quick tween for a "stutter" effect
	var tween = create_tween()
	
	# Flicker the color and jitter the position rapidly (3 times)
	for i in range(3):
		tween.tween_property(escape_label, "modulate", Color(1, 0, 0, 0.5), 0.05) # Red transparent
		tween.tween_property(escape_label, "position", original_label_pos + Vector2(randf_range(-5, 5), randf_range(-5, 5)), 0.05)
		
		tween.tween_property(escape_label, "modulate", Color(0, 1, 1, 1), 0.05) # Cyan
		tween.tween_property(escape_label, "position", original_label_pos + Vector2(randf_range(-5, 5), randf_range(-5, 5)), 0.05)
		
		tween.tween_property(escape_label, "modulate", Color(1, 1, 1, 1), 0.05) # Back to normal
		tween.tween_property(escape_label, "position", original_label_pos, 0.05)
		
