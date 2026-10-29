class_name EnemyBasic
extends CharacterBody2D

signal hit_player
signal died

enum State { IDLE, CHASE, ATTACK }

@export var speed: float = 120.0
@export var detection_range: float = 400.0
@export var attack_range: float = 40.0
@export var attack_cooldown: float = 1.5
@export var luck: float = 0.0
@export var max_health: float = 30.0

var _state := State.IDLE
var _target: Node2D
var _cooldown := 0.0
var _health: float


func _ready() -> void:
	_health = max_health
	_target = get_tree().get_first_node_in_group(&"player")


func _physics_process(delta: float) -> void:
	_cooldown = maxf(0.0, _cooldown - delta)
	_update_state()
	_act()
	move_and_slide()


func state() -> State:
	return _state


func set_target(node: Node2D) -> void:
	_target = node


func take_damage(amount: float) -> void:
	_health -= amount
	if _health <= 0.0:
		died.emit()
		queue_free()


func _update_state() -> void:
	if not is_instance_valid(_target):
		_state = State.IDLE
		return

	var distance := global_position.distance_to(_target.global_position)
	if distance <= attack_range:
		_state = State.ATTACK
	elif distance <= detection_range:
		_state = State.CHASE
	else:
		_state = State.IDLE


func _act() -> void:
	match _state:
		State.CHASE:
			velocity = global_position.direction_to(_target.global_position) * speed
		State.ATTACK:
			velocity = Vector2.ZERO
			_attack()
		State.IDLE:
			velocity = Vector2.ZERO


func _attack() -> void:
	if _cooldown > 0.0:
		return
	_cooldown = attack_cooldown
	if _target.has_method("take_hit"):
		_target.take_hit(luck)
	hit_player.emit()
