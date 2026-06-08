extends Area3D

# A spinning, bobbing collectible. Emits `collected` when the player touches it.

signal collected

@export var spin_speed := 2.5
@export var bob_height := 0.15
@export var bob_speed := 2.0

var _base_y := 0.0
var _t := 0.0
var _taken := false

func _ready() -> void:
	_base_y = position.y
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	_t += delta
	rotate_y(spin_speed * delta)
	position.y = _base_y + sin(_t * bob_speed) * bob_height

func _on_body_entered(body: Node3D) -> void:
	if _taken:
		return
	if body.is_in_group("player"):
		_taken = true
		collected.emit()
		_pop()

func _pop() -> void:
	set_deferred("monitoring", false)
	var tw := create_tween()
	tw.set_parallel(true)
	tw.tween_property(self, "scale", Vector3.ZERO, 0.2)
	tw.tween_property(self, "position:y", _base_y + 1.0, 0.2)
	tw.finished.connect(queue_free)
