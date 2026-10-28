
extends Area2D

@export var speed: float = 1000.0
@export var damage: float = 10.0
@export var lifetime: float = 1.2
@export var trail_length: float = 22.0

var direction: Vector2 = Vector2.RIGHT
var traveled_time: float = 0.0

@onready var trail: Line2D = $Trail


func _ready() -> void:
	body_entered.connect(_on_body_entered)

	# След остаётся в мировых координатах,
	# пока сама пуля перемещается.
	trail.top_level = true
	trail.width = 3.0
	trail.default_color = Color(1.0, 0.85, 0.35, 0.9)


func setup(start_position: Vector2, shot_direction: Vector2) -> void:
	global_position = start_position
	direction = shot_direction.normalized()
	rotation = direction.angle()


func _physics_process(delta: float) -> void:
	traveled_time += delta

	if traveled_time >= lifetime:
		queue_free()
		return

	global_position += direction * speed * delta

	# Рисуем короткий след за пулей.
	trail.clear_points()
	trail.add_point(global_position)
	trail.add_point(global_position - direction * trail_length)


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)

	queue_free()
