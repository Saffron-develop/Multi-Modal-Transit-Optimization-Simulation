extends Camera2D

@export var zoom_speed: float = 0.05
@export var move_speed: float = 100.0

var pan_start_pos: Vector2 = Vector2.ZERO
var target_zoom: Vector2 = Vector2.ONE


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		# Mouse wheel zoom
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			camera_zoom_in()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			camera_zoom_out()

	elif event is InputEventKey:
		# WASD movement
		if event.is_action_pressed("move_right"):
			position += Vector2(move_speed * get_process_delta_time(), 0)
		elif event.is_action_pressed("move_left"):
			position += Vector2(-move_speed * get_process_delta_time(), 0)
		elif event.is_action_pressed("move_down"):
			position += Vector2(0, move_speed * get_process_delta_time())
		elif event.is_action_pressed("move_up"):
			position += Vector2(0, -move_speed * get_process_delta_time())

func camera_zoom_in() -> void:
	target_zoom -= Vector2(zoom_speed, zoom_speed)
	target_zoom = target_zoom.clamp(Vector2(0.1, 0.1), Vector2(5.0, 5.0))

func camera_zoom_out() -> void:
	target_zoom += Vector2(zoom_speed, zoom_speed)
	target_zoom = target_zoom.clamp(Vector2(0.1, 0.1), Vector2(5.0, 5.0))

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pan"):
		pan_start_pos = get_global_mouse_position()
	if Input.is_action_pressed("pan"):
		var mouse_pos = get_global_mouse_position()
		position = lerp(position, global_position + (pan_start_pos - mouse_pos), delta * 5)

	zoom = lerp(zoom, target_zoom, delta * 8)