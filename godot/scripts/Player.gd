extends CharacterBody2D
class_name Player

@export var speed: float = 185.0
@export var walk_animation_fps: float = 7.5

var can_move: bool = true
var facing_direction: String = "down"

@onready var visual: AnimatedSprite2D = $Visual

const YUI_FRAME_SIZE: Vector2i = Vector2i(96, 96)
const YUI_ROW_DOWN: int = 0
const YUI_ROW_LEFT: int = 1
const YUI_ROW_RIGHT: int = 2
const YUI_ROW_UP: int = 3


func _ready() -> void:
	visual.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_setup_yui_sprite_frames()
	_update_visual(Vector2.ZERO)


func _physics_process(_delta: float) -> void:
	if not can_move:
		velocity = Vector2.ZERO
		move_and_slide()
		_update_visual(Vector2.ZERO)
		return

	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	move_and_slide()
	_update_visual(direction)


func set_movement_enabled(is_enabled: bool) -> void:
	can_move = is_enabled


func _setup_yui_sprite_frames() -> void:
	# The visual sprite is intentionally separate from collision and movement so
	# future character art swaps do not change gameplay detection.
	var frames: SpriteFrames = SpriteFrames.new()
	var idle_down: Texture2D = _get_yui_frame(YUI_ROW_DOWN, 0)
	var idle_up: Texture2D = _get_yui_frame(YUI_ROW_UP, 0)
	var idle_left: Texture2D = _get_yui_frame(YUI_ROW_LEFT, 0)
	var idle_right: Texture2D = _get_yui_frame(YUI_ROW_RIGHT, 0)

	_add_animation(frames, "idle_down", [idle_down], 1.0)
	_add_animation(frames, "idle_up", [idle_up], 1.0)
	_add_animation(frames, "idle_left", [idle_left], 1.0)
	_add_animation(frames, "idle_right", [idle_right], 1.0)
	_add_animation(frames, "walk_down", [
		_get_yui_frame(YUI_ROW_DOWN, 0),
		_get_yui_frame(YUI_ROW_DOWN, 1),
		_get_yui_frame(YUI_ROW_DOWN, 2),
		_get_yui_frame(YUI_ROW_DOWN, 3),
	], walk_animation_fps)
	_add_animation(frames, "walk_up", [
		_get_yui_frame(YUI_ROW_UP, 0),
		_get_yui_frame(YUI_ROW_UP, 1),
		_get_yui_frame(YUI_ROW_UP, 2),
		_get_yui_frame(YUI_ROW_UP, 3),
	], walk_animation_fps)
	_add_animation(frames, "walk_left", [
		_get_yui_frame(YUI_ROW_LEFT, 0),
		_get_yui_frame(YUI_ROW_LEFT, 1),
		_get_yui_frame(YUI_ROW_LEFT, 2),
		_get_yui_frame(YUI_ROW_LEFT, 3),
	], walk_animation_fps)
	_add_animation(frames, "walk_right", [
		_get_yui_frame(YUI_ROW_RIGHT, 0),
		_get_yui_frame(YUI_ROW_RIGHT, 1),
		_get_yui_frame(YUI_ROW_RIGHT, 2),
		_get_yui_frame(YUI_ROW_RIGHT, 3),
	], walk_animation_fps)

	visual.sprite_frames = frames


func _add_animation(frames: SpriteFrames, animation_name: String, textures: Array[Texture2D], fps: float) -> void:
	if not frames.has_animation(animation_name):
		frames.add_animation(animation_name)

	frames.set_animation_speed(animation_name, fps)
	frames.set_animation_loop(animation_name, animation_name.begins_with("walk_"))
	for texture in textures:
		frames.add_frame(animation_name, texture)


func _get_yui_frame(row: int, column: int) -> Texture2D:
	var atlas_texture: AtlasTexture = AtlasTexture.new()
	atlas_texture.atlas = AssetPaths.YUI_WALK_4DIR_RGBA
	atlas_texture.region = Rect2(
		Vector2(column * YUI_FRAME_SIZE.x, row * YUI_FRAME_SIZE.y),
		Vector2(float(YUI_FRAME_SIZE.x), float(YUI_FRAME_SIZE.y))
	)
	return atlas_texture


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
