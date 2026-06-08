extends Camera3D

# Smoothly trails the player from a fixed angle and keeps it framed.

@export var target_path := NodePath("../Player")
@export var offset := Vector3(0, 7, 9)
@export var look_height := 1.0
@export var smooth_speed := 6.0

var target: Node3D

func _ready() -> void:
	target = get_node_or_null(target_path)

func _process(delta: float) -> void:
	if target == null:
		return
	var desired := target.global_position + offset
	global_position = global_position.lerp(desired, clampf(smooth_speed * delta, 0.0, 1.0))
	look_at(target.global_position + Vector3.UP * look_height, Vector3.UP)
