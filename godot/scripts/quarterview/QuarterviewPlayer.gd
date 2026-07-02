extends CharacterBody2D

# Candidate movement tuning. Keep these near the top so GUI feedback can map
# directly to a small number of values.
const DEFAULT_MOVE_SPEED := 185.0
const TARGET_REACHED_DISTANCE := 10.0
const TEMP_YUI_IDLE_TEXTURE_PATH := "res://assets/art/quarterview/character/yui/yui_qv_idle_4dir.png"
const TEMP_YUI_WALK_TEXTURE_PATH := "res://assets/art/quarterview/character/yui/yui_qv_walk_4dir.png"
const TEMP_YUI_FRAME_SIZE := Vector2i(128, 128)
const TEMP_YUI_IDLE_FRAME_COUNT := 4
const TEMP_YUI_WALK_FRAME_COUNT := 6
const DEFAULT_TEMP_YUI_IDLE_FRAME_LIMIT := 2
const DEFAULT_TEMP_YUI_IDLE_FPS := 0.8
const DEFAULT_TEMP_YUI_WALK_FPS := 6.0
const DEFAULT_TEMP_YUI_VISUAL_SCALE := 1.8
const DEFAULT_TEMP_YUI_VISUAL_OFFSET := Vector2(0, -56)

@export var move_speed := DEFAULT_MOVE_SPEED
@export var temp_yui_visual_scale := DEFAULT_TEMP_YUI_VISUAL_SCALE
@export var temp_yui_visual_offset := DEFAULT_TEMP_YUI_VISUAL_OFFSET
@export var temp_yui_idle_frame_limit := DEFAULT_TEMP_YUI_IDLE_FRAME_LIMIT
@export var temp_yui_idle_fps := DEFAULT_TEMP_YUI_IDLE_FPS
@export var temp_yui_walk_fps := DEFAULT_TEMP_YUI_WALK_FPS
var keyboard_input_enabled := false
var path_points: PackedVector2Array = PackedVector2Array()
var path_index := 0
var temp_yui_idle_texture: Texture2D
var temp_yui_walk_texture: Texture2D
var temp_yui_sprite: Sprite2D
var temp_yui_sprite_loaded := false
var temp_yui_direction_index := 1
var temp_yui_frame_index := 0
var temp_yui_frame_time := 0.0
var temp_yui_was_walking := false


func _ready() -> void:
	_setup_temp_yui_sprite()


func set_keyboard_input_enabled(enabled: bool) -> void:
	keyboard_input_enabled = enabled


func set_move_target(target: Vector2) -> void:
	set_path(PackedVector2Array([target]))


func set_path(points: PackedVector2Array) -> void:
	path_points = points
	path_index = 0

	if path_points.size() > 0 and global_position.distance_to(path_points[0]) <= TARGET_REACHED_DISTANCE:
		path_index = 1

	if path_index >= path_points.size():
		clear_move_target()


func clear_move_target() -> void:
	path_points.clear()
	path_index = 0


func has_active_target() -> bool:
	return path_index < path_points.size()


func is_at_target() -> bool:
	return not has_active_target()


func _physics_process(delta: float) -> void:
	var input_vector := Vector2.ZERO

	if keyboard_input_enabled:
		if Input.is_key_pressed(KEY_LEFT):
			input_vector.x -= 1.0
		if Input.is_key_pressed(KEY_RIGHT):
			input_vector.x += 1.0
		if Input.is_key_pressed(KEY_UP):
			input_vector.y -= 1.0
		if Input.is_key_pressed(KEY_DOWN):
			input_vector.y += 1.0

	if input_vector != Vector2.ZERO:
		clear_move_target()
		velocity = input_vector.normalized() * move_speed
	elif has_active_target():
		var current_target := path_points[path_index]
		var to_target := current_target - global_position
		if to_target.length() <= TARGET_REACHED_DISTANCE:
			global_position = current_target
			path_index += 1
			if has_active_target():
				velocity = (path_points[path_index] - global_position).normalized() * move_speed
			else:
				velocity = Vector2.ZERO
		else:
			velocity = to_target.normalized() * move_speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()
	z_index = int(global_position.y)
	_update_temp_yui_sprite(delta)
	queue_redraw()


func _draw() -> void:
	draw_circle(Vector2(8, 18), 28.0, Color(0.0, 0.0, 0.0, 0.32))
	if temp_yui_sprite_loaded:
		return

	draw_rect(Rect2(Vector2(-14, -34), Vector2(28, 56)), Color(0.08, 0.10, 0.12, 1.0), true)
	draw_rect(Rect2(Vector2(-11, -46), Vector2(22, 22)), Color(0.12, 0.13, 0.15, 1.0), true)
	draw_line(Vector2(-14, -30), Vector2(14, 18), Color(0.86, 0.74, 0.52, 0.68), 3.0)


func _setup_temp_yui_sprite() -> void:
	if not ResourceLoader.exists(TEMP_YUI_IDLE_TEXTURE_PATH) or not ResourceLoader.exists(TEMP_YUI_WALK_TEXTURE_PATH):
		return

	temp_yui_idle_texture = load(TEMP_YUI_IDLE_TEXTURE_PATH) as Texture2D
	temp_yui_walk_texture = load(TEMP_YUI_WALK_TEXTURE_PATH) as Texture2D
	if temp_yui_idle_texture == null or temp_yui_walk_texture == null:
		return

	temp_yui_sprite = Sprite2D.new()
	temp_yui_sprite.name = "TempYuiSprite"
	temp_yui_sprite.centered = true
	temp_yui_sprite.region_enabled = true
	temp_yui_sprite.position = temp_yui_visual_offset
	temp_yui_sprite.scale = Vector2.ONE * temp_yui_visual_scale
	add_child(temp_yui_sprite)
	temp_yui_sprite_loaded = true
	_update_temp_yui_sprite(0.0)


func _update_temp_yui_sprite(delta: float) -> void:
	if not temp_yui_sprite_loaded:
		return

	var is_walking := velocity.length() > 1.0
	if is_walking:
		temp_yui_direction_index = _get_temp_yui_direction_index(velocity)

	if temp_yui_was_walking != is_walking:
		temp_yui_frame_time = 0.0
		temp_yui_frame_index = 0
		temp_yui_was_walking = is_walking
	else:
		temp_yui_frame_time += delta

	var frame_count := TEMP_YUI_WALK_FRAME_COUNT
	if not is_walking:
		frame_count = int(clamp(temp_yui_idle_frame_limit, 1, TEMP_YUI_IDLE_FRAME_COUNT))
	var frame_rate: float = temp_yui_walk_fps if is_walking else temp_yui_idle_fps
	frame_rate = max(frame_rate, 0.1)
	temp_yui_frame_index = int(floor(temp_yui_frame_time * frame_rate)) % frame_count

	temp_yui_sprite.texture = temp_yui_walk_texture if is_walking else temp_yui_idle_texture
	temp_yui_sprite.region_rect = Rect2(
		Vector2(temp_yui_frame_index * TEMP_YUI_FRAME_SIZE.x, temp_yui_direction_index * TEMP_YUI_FRAME_SIZE.y),
		Vector2(TEMP_YUI_FRAME_SIZE.x, TEMP_YUI_FRAME_SIZE.y)
	)


func _get_temp_yui_direction_index(motion: Vector2) -> int:
	if motion.y < 0.0:
		return 3 if motion.x >= 0.0 else 2
	return 1 if motion.x >= 0.0 else 0
