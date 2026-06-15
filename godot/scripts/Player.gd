extends CharacterBody2D
class_name Player

@export var speed: float = 185.0
@export var walk_animation_fps: float = 7.5

var can_move: bool = true
var facing_direction: String = "down"

@onready var visual: AnimatedSprite2D = $Visual


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
	var idle_down: Texture2D = _create_yui_pixel_texture("down", 0, true)
	var idle_up: Texture2D = _create_yui_pixel_texture("up", 0, true)
	var idle_left: Texture2D = _create_yui_pixel_texture("left", 0, true)
	var idle_right: Texture2D = _create_yui_pixel_texture("right", 0, true)

	_add_animation(frames, "idle_down", [idle_down], 1.0)
	_add_animation(frames, "idle_up", [idle_up], 1.0)
	_add_animation(frames, "idle_left", [idle_left], 1.0)
	_add_animation(frames, "idle_right", [idle_right], 1.0)
	_add_animation(frames, "walk_down", [
		_create_yui_pixel_texture("down", 0, false),
		_create_yui_pixel_texture("down", 1, false),
		_create_yui_pixel_texture("down", 2, false),
		_create_yui_pixel_texture("down", 3, false),
	], walk_animation_fps)
	_add_animation(frames, "walk_up", [
		_create_yui_pixel_texture("up", 0, false),
		_create_yui_pixel_texture("up", 1, false),
		_create_yui_pixel_texture("up", 2, false),
		_create_yui_pixel_texture("up", 3, false),
	], walk_animation_fps)
	_add_animation(frames, "walk_left", [
		_create_yui_pixel_texture("left", 0, false),
		_create_yui_pixel_texture("left", 1, false),
		_create_yui_pixel_texture("left", 2, false),
		_create_yui_pixel_texture("left", 3, false),
	], walk_animation_fps)
	_add_animation(frames, "walk_right", [
		_create_yui_pixel_texture("right", 0, false),
		_create_yui_pixel_texture("right", 1, false),
		_create_yui_pixel_texture("right", 2, false),
		_create_yui_pixel_texture("right", 3, false),
	], walk_animation_fps)

	visual.sprite_frames = frames


func _add_animation(frames: SpriteFrames, animation_name: String, textures: Array[Texture2D], fps: float) -> void:
	if not frames.has_animation(animation_name):
		frames.add_animation(animation_name)

	frames.set_animation_speed(animation_name, fps)
	frames.set_animation_loop(animation_name, animation_name.begins_with("walk_"))
	for texture in textures:
		frames.add_frame(animation_name, texture)


func _create_yui_pixel_texture(direction: String, frame_index: int, is_idle: bool) -> Texture2D:
	var image: Image = Image.create(32, 48, false, Image.FORMAT_RGBA8)
	image.fill(Color(0, 0, 0, 0))
	_paint_yui_pixel_sprite(image, direction, frame_index, is_idle)
	return ImageTexture.create_from_image(image)


func _paint_yui_pixel_sprite(image: Image, direction: String, frame_index: int, is_idle: bool) -> void:
	var hair: Color = Color("#121111")
	var hair_light: Color = Color("#2b2825")
	var skin: Color = Color("#d7b39a")
	var hoodie: Color = Color("#25282a")
	var hoodie_shadow: Color = Color("#151719")
	var shirt: Color = Color("#c9c0b6")
	var pants: Color = Color("#1e2021")
	var boots: Color = Color("#0c0d0d")
	var bag: Color = Color("#1a1715")
	var patch: Color = Color("#9a7447")
	var step_values: Array[int] = [0, 1, 0, -1]
	var step: int = 0 if is_idle else step_values[frame_index % step_values.size()]
	var arm_swing: int = 0 if is_idle else -step

	_fill_pixels(image, 13, 45, 6, 2, Color(0, 0, 0, 0.34))
	if direction == "up":
		_fill_pixels(image, 8, 4, 16, 19, hair)
		_fill_pixels(image, 10, 6, 12, 4, hair_light)
		_fill_pixels(image, 9, 20, 14, 13, hoodie)
		_fill_pixels(image, 11, 24, 10, 8, hoodie_shadow)
		_fill_pixels(image, 10, 18, 12, 9, bag)
		_fill_pixels(image, 21, 21, 3, 9, hoodie_shadow)
		_paint_legs(image, pants, boots, step, true)
		return

	if direction == "left" or direction == "right":
		var facing_left: bool = direction == "left"
		var face_x: int = 9 if facing_left else 16
		var hair_x: int = 7 if facing_left else 10
		var arm_x: int = 20 if facing_left else 9
		var bag_x: int = 21 if facing_left else 8
		_fill_pixels(image, hair_x, 5, 14, 17, hair)
		_fill_pixels(image, hair_x + 2, 6, 10, 4, hair_light)
		_fill_pixels(image, face_x, 12, 7, 8, skin)
		_fill_pixels(image, face_x + (0 if facing_left else 5), 14, 2, 2, Color("#1a1512"))
		_fill_pixels(image, 10, 21, 13, 13, hoodie)
		_fill_pixels(image, 12, 22, 7, 9, shirt)
		_fill_pixels(image, bag_x, 24, 4, 7, bag)
		_fill_pixels(image, arm_x, 22 + arm_swing, 4, 12, hoodie_shadow)
		_fill_pixels(image, arm_x, 34 + arm_swing, 3, 3, skin)
		_fill_pixels(image, 10, 34 + step, 5, 9, pants)
		_fill_pixels(image, 17, 34 - step, 5, 9, pants)
		_fill_pixels(image, 9, 42 + step, 6, 3, boots)
		_fill_pixels(image, 17, 42 - step, 6, 3, boots)
		return

	_fill_pixels(image, 8, 4, 16, 17, hair)
	_fill_pixels(image, 10, 6, 12, 4, hair_light)
	_fill_pixels(image, 10, 12, 12, 9, skin)
	_fill_pixels(image, 11, 14, 2, 2, Color("#1a1512"))
	_fill_pixels(image, 19, 14, 2, 2, Color("#1a1512"))
	_fill_pixels(image, 9, 21, 14, 13, hoodie)
	_fill_pixels(image, 13, 22, 6, 10, shirt)
	_fill_pixels(image, 23, 24, 3, 7, bag)
	_fill_pixels(image, 6, 23 + arm_swing, 4, 12, hoodie_shadow)
	_fill_pixels(image, 22, 23 - arm_swing, 4, 12, hoodie_shadow)
	_fill_pixels(image, 6, 35 + arm_swing, 3, 3, skin)
	_fill_pixels(image, 23, 35 - arm_swing, 3, 3, skin)
	_fill_pixels(image, 22, 25, 4, 3, patch)
	_paint_legs(image, pants, boots, step, false)


func _paint_legs(image: Image, pants: Color, boots: Color, step: int, is_back: bool) -> void:
	var left_y: int = 33 + step
	var right_y: int = 33 - step
	_fill_pixels(image, 10, left_y, 5, 10, pants)
	_fill_pixels(image, 17, right_y, 5, 10, pants)
	_fill_pixels(image, 9, left_y + 9, 6, 4, boots)
	_fill_pixels(image, 17, right_y + 9, 6, 4, boots)
	if is_back:
		_fill_pixels(image, 13, 21, 6, 2, Color("#2f2d2b"))


func _fill_pixels(image: Image, x: int, y: int, width: int, height: int, color: Color) -> void:
	for pixel_y in range(y, y + height):
		if pixel_y < 0 or pixel_y >= image.get_height():
			continue
		for pixel_x in range(x, x + width):
			if pixel_x < 0 or pixel_x >= image.get_width():
				continue
			image.set_pixel(pixel_x, pixel_y, color)


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
