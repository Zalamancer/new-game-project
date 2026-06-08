extends CharacterBody3D

# Third-person arcade mover for the coin-collecting game.
# Camera stays behind the player, so "up" always means away from the camera.

@export var speed := 7.0
@export var jump_force := 8.5
@export var gravity := 22.0
@export var turn_speed := 12.0

func _physics_process(delta: float) -> void:
	var input_dir := Vector3.ZERO
	if Input.is_action_pressed("ui_up") or Input.is_physical_key_pressed(KEY_W):
		input_dir.z -= 1.0
	if Input.is_action_pressed("ui_down") or Input.is_physical_key_pressed(KEY_S):
		input_dir.z += 1.0
	if Input.is_action_pressed("ui_left") or Input.is_physical_key_pressed(KEY_A):
		input_dir.x -= 1.0
	if Input.is_action_pressed("ui_right") or Input.is_physical_key_pressed(KEY_D):
		input_dir.x += 1.0

	var dir := input_dir.normalized()
	velocity.x = dir.x * speed
	velocity.z = dir.z * speed

	if not is_on_floor():
		velocity.y -= gravity * delta

	if is_on_floor() and Input.is_action_just_pressed("ui_accept"):
		velocity.y = jump_force

	move_and_slide()

	# Rotate the body so its nose (-Z) points where it is moving.
	if dir.length() > 0.1:
		var target_angle := atan2(-dir.x, -dir.z)
		rotation.y = lerp_angle(rotation.y, target_angle, turn_speed * delta)
