extends CharacterBody2D
class_name Player

@export var speed: float = 185.0
@export var walk_animation_fps: float = 5.0

var can_move: bool = true
var facing_direction: String = "down"

@onready var visual: AnimatedSprite2D = $Visual


func _ready() -> void:
	_setup_yui_sprite_frames()
	_update_visual(Vector2.ZERO)


func _physics_process(_delta: float) -> void:
	if not can_move:
		velocity = Vector2.ZERO
		move_and_slide()
		_update_visual(Vector2.ZERO)
		return

	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	move_and_slide()
	_update_visual(direction)


func set_movement_enabled(is_enabled: bool) -> void:
	can_move = is_enabled


func _setup_yui_sprite_frames() -> void:
	# The visual sprite is intentionally separate from collision and movement so
	# future character art swaps do not change gameplay detection.
	var frames := SpriteFrames.new()
	var idle_down := _load_yui_texture(AssetPaths.YUI_IDLE_DOWN_PATH)
	var idle_up := _load_yui_texture(AssetPaths.YUI_IDLE_UP_PATH)
	var idle_left := _load_yui_texture(AssetPaths.YUI_IDLE_LEFT_PATH)
	var idle_right := _load_yui_texture(AssetPaths.YUI_IDLE_RIGHT_PATH)

	_add_animation(frames, "idle_down", [idle_down], 1.0)
	_add_animation(frames, "idle_up", [idle_up], 1.0)
	_add_animation(frames, "idle_left", [idle_left], 1.0)
	_add_animation(frames, "idle_right", [idle_right], 1.0)
	_add_animation(frames, "walk_down", [
		_load_yui_texture(AssetPaths.YUI_WALK_DOWN_01_PATH, idle_down),
		_load_yui_texture(AssetPaths.YUI_WALK_DOWN_02_PATH, idle_down),
	], walk_animation_fps)
	_add_animation(frames, "walk_up", [
		_load_yui_texture(AssetPaths.YUI_WALK_UP_01_PATH, idle_up),
		_load_yui_texture(AssetPaths.YUI_WALK_UP_02_PATH, idle_up),
	], walk_animation_fps)
	_add_animation(frames, "walk_left", [
		_load_yui_texture(AssetPaths.YUI_WALK_LEFT_01_PATH, idle_left),
		_load_yui_texture(AssetPaths.YUI_WALK_LEFT_02_PATH, idle_left),
	], walk_animation_fps)
	_add_animation(frames, "walk_right", [
		_load_yui_texture(AssetPaths.YUI_WALK_RIGHT_01_PATH, idle_right),
		_load_yui_texture(AssetPaths.YUI_WALK_RIGHT_02_PATH, idle_right),
	], walk_animation_fps)

	visual.sprite_frames = frames


func _add_animation(frames: SpriteFrames, animation_name: String, textures: Array, fps: float) -> void:
	if not frames.has_animation(animation_name):
		frames.add_animation(animation_name)

	frames.set_animation_speed(animation_name, fps)
	frames.set_animation_loop(animation_name, animation_name.begins_with("walk_"))
	for texture in textures:
		frames.add_frame(animation_name, texture)


func _load_yui_texture(path: String, fallback: Texture2D = AssetPaths.YUI_PLAYER_IDLE_BACK) -> Texture2D:
	return AssetPaths.load_texture_or_fallback(path, fallback)


func _update_visual(direction: Vector2) -> void:
	if direction.length_squared() > 0.001:
		facing_direction = _get_cardinal_direction(direction)
		_play_animation("walk_%s" % facing_direction)
		return

	_play_animation("idle_%s" % facing_direction)


func _get_cardinal_direction(direction: Vector2) -> String:
	if absf(direction.x) > absf(direction.y):
		return "right" if direction.x > 0.0 else "left"

	return "down" if direction.y > 0.0 else "up"


func _play_animation(animation_name: String) -> void:
	if visual.animation == animation_name and visual.is_playing():
		return

	visual.play(animation_name)
