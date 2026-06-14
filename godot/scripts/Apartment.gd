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
var used_day1_action_keys: Array[String] = []
var current_power_units: int = SurvivalState.DAY1_STARTING_POWER_UNITS
var phase_key: String = "day"

const ROOM_RECT: Rect2 = Rect2(185, 68, 930, 586)
const WALL_THICKNESS: float = 28.0


func _ready() -> void:
	_build_room_collision()
	_add_environment_blockers()
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

		var is_powered: bool = device_keys.has(_get_power_key_for_object(object_id))
		if object_id == "power_strip":
			is_powered = not device_keys.is_empty()
		interactable.set_powered(is_powered)

	queue_redraw()


func set_day1_visual_state(used_actions: Array[String], current_power: int) -> void:
	used_day1_action_keys = used_actions.duplicate()
	current_power_units = current_power

	for object_id in interactables_by_id.keys():
		var interactable: ApartmentInteractable = interactables_by_id[object_id] as ApartmentInteractable
		if interactable == null:
			continue

		interactable.set_day1_visual_state(used_day1_action_keys, current_power_units)

	queue_redraw()


func set_phase(next_phase_key: String) -> void:
	if phase_key == next_phase_key:
		return

	phase_key = next_phase_key
	for interactable in interactables:
		interactable.set_phase(phase_key)
	queue_redraw()


func _draw() -> void:
	var wall_color: Color = Color("#111314")
	var inner_wall: Color = Color("#211d1a")
	var floor_fill: Color = Color("#2c2119")
	var trim_color: Color = Color("#816845")

	draw_rect(Rect2(Vector2.ZERO, get_viewport_rect().size), Color("#050606"), true)
	draw_rect(ROOM_RECT.grow(22.0), Color("#0d0b0a"), true)
	draw_rect(ROOM_RECT, wall_color, true)
	draw_rect(ROOM_RECT.grow(-12.0), inner_wall, true)
	_draw_room_asset_backdrop(ROOM_RECT.grow(22.0), ROOM_RECT.grow(-48.0), wall_color, floor_fill)
	_draw_room_details()
	_draw_light_pool()
	_draw_power_cables()
	draw_rect(ROOM_RECT, Color("#3f3021"), false, 5.0)
	draw_rect(ROOM_RECT.grow(-12.0), trim_color, false, 1.2)
	draw_rect(ROOM_RECT.grow(-48.0), Color(0.02, 0.018, 0.015, 0.34), false, 2.0)


func _build_room_collision() -> void:
	_add_wall(Rect2(ROOM_RECT.position.x, ROOM_RECT.position.y - WALL_THICKNESS, ROOM_RECT.size.x, WALL_THICKNESS))
	_add_wall(Rect2(ROOM_RECT.position.x, ROOM_RECT.end.y, ROOM_RECT.size.x, WALL_THICKNESS))
	_add_wall(Rect2(ROOM_RECT.position.x - WALL_THICKNESS, ROOM_RECT.position.y, WALL_THICKNESS, ROOM_RECT.size.y))
	_add_wall(Rect2(ROOM_RECT.end.x, ROOM_RECT.position.y, WALL_THICKNESS, ROOM_RECT.size.y))


func _spawn_player() -> void:
	player = player_scene.instantiate() as Player
	player.position = Vector2(610, 392)
	add_child(player)


func _spawn_placeholder_furniture() -> void:
	_add_interactable({
		"id": "power_strip",
		"name": "멀티탭",
		"title": "멀티탭",
		"body": "방 안 기기들의 전원을 연결하는 낡은 멀티탭입니다.",
		"position": Vector2(710, 476),
		"size": Vector2(128, 38),
		"color": Color("#6f614e"),
		"outline_color": Color("#ffe6a3"),
		"prompt_text": "[E] 멀티탭 관리",
		"label_offset": Vector2.ZERO,
	})
	_add_interactable({
		"id": "light",
		"name": "조명",
		"title": "조명",
		"body": "방 안을 겨우 밝히는 낡은 조명입니다.",
		"position": Vector2(620, 134),
		"size": Vector2(138, 34),
		"color": Color("#a8894e"),
		"power_units": 1,
		"day1_action_key": "light",
		"label_offset": Vector2.ZERO,
	})
	_add_interactable({
		"id": "charger",
		"name": "충전기",
		"title": "충전기",
		"body": "배터리를 회복하는 작은 장치입니다.\n전력은 낮지만 오래 빼두면 위험해집니다.",
		"position": Vector2(928, 508),
		"size": Vector2(54, 36),
		"color": Color("#4e5e67"),
		"power_units": 2,
		"day1_action_key": "charger",
		"label_offset": Vector2.ZERO,
	})
	_add_interactable({
		"id": "fan",
		"name": "선풍기",
		"title": "선풍기",
		"body": "더위를 낮출 수 있습니다.\n하지만 켜두면 다른 장치를 꽂을 여유가 줄어듭니다.",
		"position": Vector2(850, 256),
		"size": Vector2(70, 82),
		"color": Color("#53645b"),
		"power_units": 2,
		"day1_action_key": "fan",
		"label_offset": Vector2.ZERO,
	})
	_add_interactable({
		"id": "laptop",
		"name": "노트북",
		"title": "노트북",
		"body": "오래된 노트북입니다.\n전력을 사용해 로그와 바깥 정보를 확인할 수 있습니다.",
		"position": Vector2(610, 234),
		"size": Vector2(96, 52),
		"color": Color("#3b4748"),
		"power_units": 3,
		"day1_action_key": "laptop",
		"label_offset": Vector2.ZERO,
	})
	_add_interactable({
		"id": "communication_device",
		"name": "통신 장치",
		"title": "통신 장치",
		"body": "끊긴 신호 사이에서 바깥의 안내를 잡아낼 수 있을지도 모릅니다.",
		"position": Vector2(980, 344),
		"size": Vector2(84, 56),
		"color": Color("#5e5368"),
		"power_units": 4,
		"day1_action_key": "communication_device",
		"label_offset": Vector2.ZERO,
	})
	_add_interactable({
		"id": "bed",
		"name": "침대",
		"title": "오늘을 마친다",
		"body": "더 할 일을 정리하고 오늘 하루를 마칠 수 있습니다.",
		"position": Vector2(350, 455),
		"size": Vector2(178, 112),
		"color": Color("#5a5047"),
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


func _add_environment_blockers() -> void:
	# Non-interactive room features still need small blockers so the top-down
	# movement reads as an apartment floor, not a board the player can cross.
	_add_furniture_blocker(Vector2(1039, 219), Vector2(72, 154))
	_add_furniture_blocker(Vector2(806, 195), Vector2(92, 150))
	_add_furniture_blocker(Vector2(365, 144), Vector2(190, 38))


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


func _draw_floorboards(rect: Rect2) -> void:
	for index in range(13):
		var y := rect.position.y + 28.0 + float(index) * 34.0
		draw_line(Vector2(rect.position.x, y), Vector2(rect.end.x, y), Color(0.17, 0.12, 0.075, 0.34), 1.0)
	for index in range(9):
		var x := rect.position.x + 42.0 + float(index) * 92.0
		draw_line(Vector2(x, rect.position.y), Vector2(x, rect.end.y), Color(0.08, 0.06, 0.04, 0.14), 1.0)


func _draw_room_asset_backdrop(wall_rect: Rect2, floor_rect: Rect2, wall_fallback: Color, floor_fallback: Color) -> void:
	# The P0 room art sits under the existing collision and interactable layer so
	# gameplay stays anchored while primitive furniture is gradually replaced.
	draw_rect(wall_rect, wall_fallback, true)
	draw_texture_rect(AssetPaths.ROOM_WALL_BASE, wall_rect, false, Color(1, 1, 1, 0.55))
	draw_rect(floor_rect, floor_fallback, true)
	draw_texture_rect(AssetPaths.ROOM_FLOOR_BASE, floor_rect, false, Color(1, 1, 1, 0.62))
	_draw_floorboards(floor_rect)


func _draw_room_details() -> void:
	var floor_rect := ROOM_RECT.grow(-48.0)
	_draw_window(Rect2(Vector2(270, 104), Vector2(190, 92)))
	_draw_desk(Rect2(Vector2(500, 238), Vector2(205, 70)))
	_draw_shelf(Rect2(Vector2(760, 120), Vector2(92, 150)))
	_draw_door(Rect2(Vector2(1004, 142), Vector2(70, 154)))
	_draw_rug(Rect2(Vector2(545, 406), Vector2(210, 92)))
	_draw_small_clutter(floor_rect)


func _draw_window(rect: Rect2) -> void:
	draw_rect(rect, Color("#0c1217"), true)
	draw_rect(rect, Color("#5f513d"), false, 3.0)
	draw_line(Vector2(rect.get_center().x, rect.position.y), Vector2(rect.get_center().x, rect.end.y), Color("#332b23"), 2.0)
	draw_line(Vector2(rect.position.x, rect.get_center().y), Vector2(rect.end.x, rect.get_center().y), Color("#332b23"), 2.0)
	for index in range(9):
		var x := rect.position.x + 22.0 + float(index) * 16.0
		draw_circle(Vector2(x, rect.end.y - 22.0 - float(index % 3) * 9.0), 2.0, Color(0.95, 0.68, 0.34, 0.32))
	draw_rect(Rect2(rect.position + Vector2(-6, 0), Vector2(rect.size.x + 12, 18)), Color(0.08, 0.07, 0.06, 0.82), true)
	for index in range(5):
		var y := rect.position.y + 18.0 + float(index) * 12.0
		draw_line(Vector2(rect.position.x, y), Vector2(rect.end.x, y), Color(0.5, 0.45, 0.36, 0.22), 1.0)


func _draw_desk(rect: Rect2) -> void:
	draw_rect(Rect2(rect.position + Vector2(5, 7), rect.size), Color(0.02, 0.018, 0.014, 0.5), true)
	draw_rect(rect, Color("#2f2319"), true)
	draw_rect(rect.grow(-5.0), Color("#4a3422"), true)
	draw_rect(rect, Color("#80643e"), false, 2.0)
	draw_line(rect.position + Vector2(8.0, 8.0), rect.position + Vector2(rect.size.x - 8.0, 8.0), Color(0.95, 0.75, 0.45, 0.18), 1.0)
	for index in range(4):
		var y := rect.position.y + 12.0 + float(index) * 14.0
		draw_line(Vector2(rect.position.x + 10.0, y), Vector2(rect.end.x - 10.0, y), Color(0.72, 0.55, 0.34, 0.12), 1.0)
	draw_rect(Rect2(rect.position + Vector2(20, 15), Vector2(30, 18)), Color("#211f1c"), true)
	draw_rect(Rect2(rect.end - Vector2(58, 42), Vector2(30, 26)), Color("#2a211a"), true)
	draw_circle(rect.position + Vector2(155, 28), 6.0, Color("#786b58"))


func _draw_shelf(rect: Rect2) -> void:
	draw_rect(rect, Color("#2b211a"), true)
	draw_rect(rect, Color("#5b4933"), false, 2.0)
	for index in range(4):
		var y := rect.position.y + 28.0 + float(index) * 30.0
		draw_line(Vector2(rect.position.x, y), Vector2(rect.end.x, y), Color("#51412f"), 2.0)
	for index in range(7):
		var item_rect := Rect2(rect.position + Vector2(10 + float(index % 3) * 24.0, 12 + float(index / 3) * 38.0), Vector2(14, 22))
		draw_rect(item_rect, Color("#6b5840").darkened(float(index % 2) * 0.18), true)


func _draw_door(rect: Rect2) -> void:
	draw_rect(rect, Color("#1b2224"), true)
	draw_rect(rect, Color("#5d4c36"), false, 2.0)
	draw_rect(Rect2(rect.position + Vector2(13, 34), Vector2(44, 28)), Color("#26343a"), true)
	draw_circle(rect.position + Vector2(56, 86), 3.0, Color("#b6985b"))


func _draw_rug(rect: Rect2) -> void:
	draw_rect(rect, Color(0.12, 0.15, 0.13, 0.62), true)
	draw_rect(rect, Color(0.44, 0.37, 0.25, 0.4), false, 1.0)


func _draw_small_clutter(_floor_rect: Rect2) -> void:
	var boxes := [
		Rect2(Vector2(905, 475), Vector2(48, 34)),
		Rect2(Vector2(940, 515), Vector2(38, 48)),
		Rect2(Vector2(440, 520), Vector2(42, 32)),
		Rect2(Vector2(835, 515), Vector2(54, 34)),
	]
	for rect in boxes:
		draw_rect(rect, Color("#2b241e"), true)
		draw_rect(rect, Color("#594633"), false, 1.0)


func _draw_light_pool() -> void:
	if not used_day1_action_keys.has("light"):
		return

	var glow_rect := Rect2(Vector2(398, 92), Vector2(440, 270))
	draw_texture_rect(AssetPaths.FLUORESCENT_GLOW, glow_rect, false, Color(1, 1, 1, 0.24))

	var desk_center := Vector2(610, 242)
	for index in range(4, 0, -1):
		var alpha := 0.01 * float(index)
		draw_circle(desk_center, 32.0 * float(index), Color(0.95, 0.68, 0.31, alpha))
	var floor_center := Vector2(610, 385)
	for index in range(3, 0, -1):
		var alpha := 0.008 * float(index)
		draw_circle(floor_center, 42.0 * float(index), Color(0.92, 0.62, 0.26, alpha))


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

		_draw_power_cable(power_strip.position, interactable.position, object_id)


func _draw_power_cable(start_position: Vector2, end_position: Vector2, object_id: String) -> void:
	var midpoint: Vector2 = (start_position + end_position) * 0.5
	var bend_offset := Vector2(0, 28)
	var points := PackedVector2Array()
	match object_id:
		"laptop":
			bend_offset = Vector2(-18, 18)
		"charger":
			bend_offset = Vector2(36, 8)
		"communication_device":
			bend_offset = Vector2(58, -8)
		"fan":
			bend_offset = Vector2(18, -12)
		"light":
			# Route the fluorescent fixture line along the room instead of cutting a
			# bright diagonal through the play area.
			points = PackedVector2Array([
				start_position,
				Vector2(start_position.x, 410),
				Vector2(end_position.x, 410),
				end_position,
			])

	if points.size() == 0:
		var bend: Vector2 = midpoint + bend_offset
		points = PackedVector2Array([start_position, bend, end_position])

	var cable_core: Color = Color("#fff07a") if phase_key == "day" else Color("#ffe066")
	var cable_alpha := 0.42 if object_id == "light" else 0.62
	draw_polyline(points, Color(0.18, 0.12, 0.07, cable_alpha), 4.0, true)
	draw_polyline(points, Color(cable_core.r, cable_core.g, cable_core.b, cable_alpha), 1.4, true)
	draw_circle(end_position, 3.2, Color(cable_core.r, cable_core.g, cable_core.b, cable_alpha))


func _get_power_key_for_object(object_id: String) -> String:
	return object_id


func _distance_to_interactable_edge(world_position: Vector2, interactable: ApartmentInteractable) -> float:
	var local_delta: Vector2 = world_position - interactable.global_position
	var half_size: Vector2 = interactable.body_size * 0.5
	var outside: Vector2 = Vector2(
		maxf(absf(local_delta.x) - half_size.x, 0.0),
		maxf(absf(local_delta.y) - half_size.y, 0.0)
	)
	return outside.length()
