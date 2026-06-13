extends Node2D
class_name Apartment

signal nearest_interactable_changed(interactable: ApartmentInteractable)
signal interaction_requested(interactable: ApartmentInteractable)

@export var player_scene: PackedScene
@export var interactable_scene: PackedScene

var player: Player
var nearest_interactable: ApartmentInteractable
var interactables: Array[ApartmentInteractable] = []
var interactables_by_id: Dictionary = {}
var powered_device_keys: Array[String] = []
var phase_key: String = "day"

const ROOM_RECT: Rect2 = Rect2(160, 90, 960, 540)
const WALL_THICKNESS: float = 28.0


func _ready() -> void:
	_build_room_collision()
	_spawn_placeholder_furniture()
	_spawn_player()
	queue_redraw()


func _process(_delta: float) -> void:
	_update_nearest_interactable()


func request_nearest_interaction() -> void:
	if nearest_interactable != null:
		interaction_requested.emit(nearest_interactable)


func set_player_movement_enabled(is_enabled: bool) -> void:
	if player != null:
		player.set_movement_enabled(is_enabled)


func set_powered_devices(device_keys: Array[String]) -> void:
	powered_device_keys = device_keys.duplicate()

	for object_id in interactables_by_id.keys():
		var interactable: ApartmentInteractable = interactables_by_id[object_id] as ApartmentInteractable
		if interactable == null:
			continue

		interactable.set_powered(device_keys.has(_get_power_key_for_object(object_id)))

	queue_redraw()


func set_phase(next_phase_key: String) -> void:
	if phase_key == next_phase_key:
		return

	phase_key = next_phase_key
	for interactable in interactables:
		interactable.set_phase(phase_key)
	queue_redraw()


func _draw() -> void:
	var room_fill: Color = Color("#9b7047") if phase_key == "day" else Color("#493d43")
	var floor_fill: Color = Color("#b68858") if phase_key == "day" else Color("#5a4a4d")
	var wall_color: Color = Color("#5f4128") if phase_key == "day" else Color("#2d3547")
	var trim_color: Color = Color("#d5ae78") if phase_key == "day" else Color("#7f879a")

	draw_rect(ROOM_RECT, wall_color, true)
	draw_rect(ROOM_RECT.grow(-12.0), room_fill, true)
	draw_rect(ROOM_RECT.grow(-28.0), floor_fill, true)
	if phase_key == "night":
		draw_rect(ROOM_RECT.grow(-28.0), Color(0.08, 0.12, 0.2, 0.32), true)
	draw_rect(ROOM_RECT, wall_color, false, 4.0)
	draw_rect(ROOM_RECT.grow(-18.0), trim_color, false, 1.5)
	_draw_power_cables()


func _build_room_collision() -> void:
	_add_wall(Rect2(ROOM_RECT.position.x, ROOM_RECT.position.y - WALL_THICKNESS, ROOM_RECT.size.x, WALL_THICKNESS))
	_add_wall(Rect2(ROOM_RECT.position.x, ROOM_RECT.end.y, ROOM_RECT.size.x, WALL_THICKNESS))
	_add_wall(Rect2(ROOM_RECT.position.x - WALL_THICKNESS, ROOM_RECT.position.y, WALL_THICKNESS, ROOM_RECT.size.y))
	_add_wall(Rect2(ROOM_RECT.end.x, ROOM_RECT.position.y, WALL_THICKNESS, ROOM_RECT.size.y))


func _spawn_player() -> void:
	player = player_scene.instantiate() as Player
	player.position = Vector2(640, 500)
	add_child(player)


func _spawn_placeholder_furniture() -> void:
	_add_interactable({
		"id": "power_strip",
		"name": "멀티탭",
		"title": "멀티탭",
		"body": "전력 선택의 핵심 자리입니다.\n다음 단계에서 기존 콘센트 미니게임을 이곳에 연결합니다.",
		"position": Vector2(650, 330),
		"size": Vector2(170, 54),
		"color": Color("#d6c7a8"),
		"outline_color": Color("#ffe6a3"),
		"label_offset": Vector2.ZERO,
	})
	_add_interactable({
		"id": "light",
		"name": "조명",
		"title": "조명",
		"body": "방 안을 겨우 밝히는 낡은 조명입니다.",
		"position": Vector2(850, 200),
		"size": Vector2(70, 70),
		"color": Color("#d2a85f"),
		"power_units": 1,
		"day1_action_key": "light",
		"label_offset": Vector2.ZERO,
	})
	_add_interactable({
		"id": "charger",
		"name": "충전기",
		"title": "충전기",
		"body": "배터리를 회복하는 작은 장치입니다.\n전력은 낮지만 오래 빼두면 위험해집니다.",
		"position": Vector2(455, 330),
		"size": Vector2(82, 58),
		"color": Color("#4f8edb"),
		"power_units": 2,
		"day1_action_key": "charger",
		"label_offset": Vector2.ZERO,
	})
	_add_interactable({
		"id": "fan",
		"name": "선풍기",
		"title": "선풍기",
		"body": "더위를 낮출 수 있습니다.\n하지만 켜두면 다른 장치를 꽂을 여유가 줄어듭니다.",
		"position": Vector2(650, 190),
		"size": Vector2(82, 82),
		"color": Color("#52a66f"),
		"power_units": 2,
		"day1_action_key": "fan",
		"label_offset": Vector2.ZERO,
	})
	_add_interactable({
		"id": "laptop",
		"name": "노트북",
		"title": "노트북",
		"body": "재미를 회복할 수 있는 장치입니다.\n멀티탭에서는 큰 어댑터라 옆 콘센트를 막습니다.",
		"position": Vector2(650, 480),
		"size": Vector2(110, 70),
		"color": Color("#486064"),
		"power_units": 3,
		"day1_action_key": "laptop",
		"label_offset": Vector2.ZERO,
	})
	_add_interactable({
		"id": "communication_device",
		"name": "통신 장치",
		"title": "통신 장치",
		"body": "끊긴 신호 사이에서 바깥의 안내를 잡아낼 수 있을지도 모릅니다.",
		"position": Vector2(850, 330),
		"size": Vector2(124, 72),
		"color": Color("#8f6bb3"),
		"power_units": 4,
		"day1_action_key": "communication_device",
		"label_offset": Vector2.ZERO,
	})
	_add_interactable({
		"id": "bed",
		"name": "침대",
		"title": "오늘을 마친다",
		"body": "더 할 일을 정리하고 오늘 하루를 마칠 수 있습니다.",
		"position": Vector2(340, 430),
		"size": Vector2(150, 82),
		"color": Color("#7c6b5b"),
		"interaction_type": "end_day",
		"prompt_text": "[E] 하루 마치기",
		"label_offset": Vector2.ZERO,
	})


func _add_interactable(config: Dictionary) -> void:
	var interactable: ApartmentInteractable = interactable_scene.instantiate() as ApartmentInteractable
	interactable.setup(config)
	interactable.position = config.get("position", Vector2.ZERO)
	add_child(interactable)
	interactables_by_id[interactable.object_id] = interactable

	var is_interactable: bool = config.get("interactable", true)
	if is_interactable:
		interactables.append(interactable)
		_add_furniture_blocker(interactable.position, config.get("size", Vector2(96, 64)))


func _add_wall(rect: Rect2) -> void:
	var wall: StaticBody2D = StaticBody2D.new()
	var shape: CollisionShape2D = CollisionShape2D.new()
	var rectangle: RectangleShape2D = RectangleShape2D.new()
	rectangle.size = rect.size
	shape.shape = rectangle
	wall.position = rect.position + rect.size * 0.5
	wall.add_child(shape)
	add_child(wall)


func _add_furniture_blocker(center: Vector2, size: Vector2) -> void:
	var blocker: StaticBody2D = StaticBody2D.new()
	var shape: CollisionShape2D = CollisionShape2D.new()
	var rectangle: RectangleShape2D = RectangleShape2D.new()
	rectangle.size = size * 0.86
	shape.shape = rectangle
	blocker.position = center
	blocker.add_child(shape)
	add_child(blocker)


func _update_nearest_interactable() -> void:
	if player == null:
		return

	var next_nearest: ApartmentInteractable = null
	var best_distance: float = INF

	for interactable in interactables:
		var distance: float = _distance_to_interactable_edge(player.global_position, interactable)
		var is_better_match: bool = distance < best_distance
		if is_equal_approx(distance, best_distance) and next_nearest != null:
			is_better_match = interactable.body_size.length() < next_nearest.body_size.length()

		if distance <= 58.0 and is_better_match:
			next_nearest = interactable
			best_distance = distance

	if next_nearest != nearest_interactable:
		nearest_interactable = next_nearest
		nearest_interactable_changed.emit(nearest_interactable)


func _draw_label(position: Vector2, text: String, color: Color = Color("#d8cfba")) -> void:
	draw_string(ThemeDB.fallback_font, position, text, HORIZONTAL_ALIGNMENT_LEFT, 520.0, 16, color)


func _draw_power_cables() -> void:
	var power_strip: ApartmentInteractable = interactables_by_id.get("power_strip") as ApartmentInteractable
	if power_strip == null:
		return

	for object_id in interactables_by_id.keys():
		if object_id == "power_strip":
			continue

		var power_key: String = _get_power_key_for_object(object_id)
		if not powered_device_keys.has(power_key):
			continue

		var interactable: ApartmentInteractable = interactables_by_id[object_id] as ApartmentInteractable
		if interactable == null:
			continue

		_draw_power_cable(power_strip.position, interactable.position)


func _draw_power_cable(start_position: Vector2, end_position: Vector2) -> void:
	var midpoint: Vector2 = (start_position + end_position) * 0.5
	var bend: Vector2 = midpoint + Vector2(0, 26)
	var points: PackedVector2Array = PackedVector2Array([start_position, bend, end_position])
	var cable_core: Color = Color("#fff07a") if phase_key == "day" else Color("#ffe066")
	draw_polyline(points, Color(0.18, 0.12, 0.07, 0.55), 5.0, true)
	draw_polyline(points, cable_core, 2.0, true)
	draw_circle(end_position, 4.0, cable_core)


func _get_power_key_for_object(object_id: String) -> String:
	if object_id == "charger":
		return "phone"

	return object_id


func _distance_to_interactable_edge(world_position: Vector2, interactable: ApartmentInteractable) -> float:
	var local_delta: Vector2 = world_position - interactable.global_position
	var half_size: Vector2 = interactable.body_size * 0.5
	var outside: Vector2 = Vector2(
		maxf(absf(local_delta.x) - half_size.x, 0.0),
		maxf(absf(local_delta.y) - half_size.y, 0.0)
	)
	return outside.length()
