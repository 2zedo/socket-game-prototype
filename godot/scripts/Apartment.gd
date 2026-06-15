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

const ROOM_RECT: Rect2 = Rect2(70, 36, 1140, 642)
const FLOOR_RECT: Rect2 = Rect2(112, 206, 1032, 402)
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
	var wall_color: Color = Color("#2b231d")
	var inner_wall: Color = Color("#3b3028")
	var floor_fill: Color = Color("#4a3020")
	var trim_color: Color = Color("#9f7847")

	draw_rect(Rect2(Vector2.ZERO, get_viewport_rect().size), Color("#100e0c"), true)
	draw_rect(ROOM_RECT.grow(22.0), Color("#17110d"), true)
	draw_rect(ROOM_RECT, wall_color, true)
	draw_rect(ROOM_RECT.grow(-12.0), inner_wall, true)
	_draw_room_asset_backdrop(ROOM_RECT.grow(22.0), FLOOR_RECT, wall_color, floor_fill)
	_draw_wall_floor_separation(FLOOR_RECT)
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
	player.position = Vector2(610, 386)
	add_child(player)


func _spawn_placeholder_furniture() -> void:
	_add_interactable({
		"id": "power_strip",
		"name": "멀티탭",
		"title": "멀티탭",
		"body": "방 안 기기들의 전원을 모으는 핵심 멀티탭입니다.",
		"position": Vector2(640, 444),
		"size": Vector2(154, 56),
		"color": Color("#77654c"),
		"outline_color": Color("#ffe6a3"),
		"prompt_text": "[E] 멀티탭 관리",
		"label_offset": Vector2.ZERO,
	})
	_add_interactable({
		"id": "light",
		"name": "조명",
		"title": "조명",
		"body": "방 안을 겨우 밝히는 낡은 조명입니다.",
		"position": Vector2(884, 184),
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
		"position": Vector2(838, 506),
		"size": Vector2(60, 44),
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
		"position": Vector2(1082, 376),
		"size": Vector2(78, 96),
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
		"position": Vector2(930, 252),
		"size": Vector2(96, 56),
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
		"position": Vector2(1034, 520),
		"size": Vector2(86, 58),
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
		"position": Vector2(250, 390),
		"size": Vector2(210, 150),
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
	_add_furniture_blocker(Vector2(640, 116), Vector2(360, 112))
	_add_furniture_blocker(Vector2(456, 190), Vector2(112, 186))
	_add_furniture_blocker(Vector2(944, 262), Vector2(292, 106))
	_add_furniture_blocker(Vector2(1068, 178), Vector2(92, 178))
	_add_furniture_blocker(Vector2(972, 572), Vector2(352, 86))
	_add_furniture_blocker(Vector2(222, 566), Vector2(266, 120))


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
	draw_texture_rect(AssetPaths.ROOM_WALL_BASE, wall_rect, false, Color(1, 0.92, 0.82, 0.28))
	draw_rect(floor_rect, floor_fallback, true)
	draw_texture_rect(AssetPaths.ROOM_FLOOR_BASE, floor_rect, false, Color(1, 0.88, 0.74, 0.42))
	_draw_floorboards(floor_rect)


func _draw_wall_floor_separation(floor_rect: Rect2) -> void:
	var top_wall: Rect2 = Rect2(ROOM_RECT.position + Vector2(18, 18), Vector2(ROOM_RECT.size.x - 36, floor_rect.position.y - ROOM_RECT.position.y - 18))
	var left_entry: Rect2 = Rect2(Vector2(ROOM_RECT.position.x + 26.0, floor_rect.end.y - 104.0), Vector2(286.0, 122.0))
	draw_rect(top_wall, Color(0.16, 0.13, 0.105, 0.22), true)
	draw_rect(left_entry, Color("#211c18"), true)
	draw_rect(left_entry, Color(0.68, 0.55, 0.38, 0.22), false, 1.0)
	var molding_y: float = floor_rect.position.y
	draw_rect(Rect2(Vector2(floor_rect.position.x - 18, molding_y - 10), Vector2(floor_rect.size.x + 34, 13)), Color(0.18, 0.12, 0.075, 0.78), true)
	draw_line(Vector2(floor_rect.position.x - 18, molding_y), Vector2(floor_rect.end.x + 14, molding_y), Color(0.68, 0.50, 0.30, 0.48), 2.0)


func _draw_room_details() -> void:
	_draw_window(Rect2(Vector2(522, 70), Vector2(260, 112)))
	_draw_wall_decor()
	_draw_bathroom_hint(Rect2(Vector2(114, 520), Vector2(220, 122)))
	_draw_entry_door(Rect2(Vector2(470, 604), Vector2(138, 62)))
	_draw_desk(Rect2(Vector2(814, 214), Vector2(276, 88)))
	_draw_shelf(Rect2(Vector2(398, 118), Vector2(112, 188)))
	_draw_appliance_shelf(Rect2(Vector2(1064, 118), Vector2(96, 190)))
	_draw_kitchen_counter(Rect2(Vector2(780, 552), Vector2(340, 62)))
	_draw_rug(Rect2(Vector2(712, 360), Vector2(320, 174)))
	_draw_round_table(Vector2(870, 420), 56.0)
	_draw_power_hub_plate(Vector2(640, 444))
	_draw_small_clutter(FLOOR_RECT)


func _draw_window(rect: Rect2) -> void:
	draw_rect(Rect2(rect.position + Vector2(-16, -16), Vector2(rect.size.x + 32, rect.size.y + 32)), Color(0.05, 0.04, 0.032, 0.84), true)
	var sky_color: Color = Color("#9a8160") if phase_key == "day" else Color("#08111e")
	var light_alpha: float = 0.24 if phase_key == "day" else 0.035
	draw_rect(rect, sky_color, true)
	draw_rect(rect.grow(5.0), Color("#171411"), false, 5.0)
	draw_rect(rect, Color("#5f513d"), false, 3.0)
	draw_line(Vector2(rect.get_center().x, rect.position.y), Vector2(rect.get_center().x, rect.end.y), Color("#332b23"), 2.0)
	draw_line(Vector2(rect.position.x, rect.get_center().y), Vector2(rect.end.x, rect.get_center().y), Color("#332b23"), 2.0)
	for index in range(9):
		var x: float = rect.position.x + 22.0 + float(index) * 16.0
		draw_circle(Vector2(x, rect.end.y - 22.0 - float(index % 3) * 9.0), 2.0, Color(0.95, 0.68, 0.34, 0.32))
	draw_rect(Rect2(rect.position + Vector2(-20, rect.size.y - 4), Vector2(rect.size.x + 40, 110)), Color(0.95, 0.66, 0.35, light_alpha), true)
	draw_rect(Rect2(rect.position + Vector2(-8, -6), Vector2(rect.size.x + 16, 16)), Color(0.08, 0.07, 0.06, 0.86), true)
	for index in range(5):
		var y: float = rect.position.y + 18.0 + float(index) * 12.0
		draw_line(Vector2(rect.position.x, y), Vector2(rect.end.x, y), Color(0.5, 0.45, 0.36, 0.22), 1.0)


func _draw_wall_decor() -> void:
	draw_rect(Rect2(Vector2(220, 112), Vector2(78, 54)), Color("#2d261f"), true)
	draw_rect(Rect2(Vector2(220, 112), Vector2(78, 54)), Color("#766044"), false, 1.0)
	draw_rect(Rect2(Vector2(236, 126), Vector2(18, 18)), Color("#4d463c"), true)
	draw_rect(Rect2(Vector2(264, 123), Vector2(20, 26)), Color("#3a342d"), true)
	draw_rect(Rect2(Vector2(858, 92), Vector2(118, 78)), Color("#2d251e"), true)
	draw_rect(Rect2(Vector2(858, 92), Vector2(118, 78)), Color("#80633e"), false, 2.0)
	draw_rect(Rect2(Vector2(878, 110), Vector2(30, 22)), Color("#4c443a"), true)
	draw_rect(Rect2(Vector2(922, 110), Vector2(34, 42)), Color("#5d5142"), true)


func _draw_entry_door(rect: Rect2) -> void:
	draw_rect(Rect2(rect.position + Vector2(6, 6), rect.size), Color(0.02, 0.016, 0.012, 0.42), true)
	draw_rect(rect, Color("#4d321f"), true)
	draw_rect(rect, Color("#8a6238"), false, 2.0)
	draw_rect(Rect2(rect.position + Vector2(12.0, 12.0), Vector2(rect.size.x - 24.0, 12.0)), Color(0.95, 0.75, 0.45, 0.12), true)
	draw_circle(rect.position + Vector2(rect.size.x - 20.0, rect.size.y * 0.52), 3.5, Color("#c4a16a"))


func _draw_desk(rect: Rect2) -> void:
	draw_rect(Rect2(rect.position + Vector2(5, 7), rect.size), Color(0.02, 0.018, 0.014, 0.5), true)
	draw_rect(Rect2(rect.position + Vector2(14, rect.size.y - 4), Vector2(10, 34)), Color("#1a130e"), true)
	draw_rect(Rect2(rect.end - Vector2(24, 4), Vector2(10, 34)), Color("#1a130e"), true)
	draw_rect(rect, Color("#2f2319"), true)
	draw_rect(rect.grow(-5.0), Color("#4a3422"), true)
	draw_rect(rect, Color("#80643e"), false, 2.0)
	draw_rect(Rect2(rect.position + Vector2(0, rect.size.y - 8), Vector2(rect.size.x, 8)), Color(0.08, 0.055, 0.035, 0.72), true)
	draw_line(rect.position + Vector2(8.0, 8.0), rect.position + Vector2(rect.size.x - 8.0, 8.0), Color(0.95, 0.75, 0.45, 0.18), 1.0)
	for index in range(4):
		var y := rect.position.y + 12.0 + float(index) * 14.0
		draw_line(Vector2(rect.position.x + 10.0, y), Vector2(rect.end.x - 10.0, y), Color(0.72, 0.55, 0.34, 0.12), 1.0)
	draw_rect(Rect2(rect.position + Vector2(20, 15), Vector2(30, 18)), Color("#211f1c"), true)
	draw_rect(Rect2(rect.end - Vector2(70, 48), Vector2(46, 32)), Color("#2a211a"), true)
	draw_circle(rect.position + Vector2(58, 28), 9.0, Color("#6f5d43"))
	draw_line(rect.position + Vector2(40, 22), rect.position + Vector2(68, 4), Color("#201912"), 3.0, true)
	draw_circle(rect.position + Vector2(74, 5), 8.0, Color("#d8b36b"))


func _draw_shelf(rect: Rect2) -> void:
	draw_rect(rect, Color("#2b211a"), true)
	draw_rect(rect, Color("#5b4933"), false, 2.0)
	for index in range(4):
		var y := rect.position.y + 28.0 + float(index) * 30.0
		draw_line(Vector2(rect.position.x, y), Vector2(rect.end.x, y), Color("#51412f"), 2.0)
	for index in range(7):
		var item_rect := Rect2(rect.position + Vector2(10 + float(index % 3) * 24.0, 12 + float(index / 3) * 38.0), Vector2(14, 22))
		draw_rect(item_rect, Color("#6b5840").darkened(float(index % 2) * 0.18), true)


func _draw_appliance_shelf(rect: Rect2) -> void:
	draw_rect(rect, Color("#2b211a"), true)
	draw_rect(rect, Color("#5b4933"), false, 2.0)
	for index in range(3):
		var y: float = rect.position.y + 48.0 + float(index) * 46.0
		draw_line(Vector2(rect.position.x, y), Vector2(rect.end.x, y), Color("#51412f"), 2.0)
	var microwave: Rect2 = Rect2(rect.position + Vector2(14.0, 22.0), Vector2(68.0, 42.0))
	draw_rect(microwave, Color("#2a2d30"), true)
	draw_rect(microwave, Color("#7e6a51"), false, 1.5)
	draw_rect(Rect2(microwave.position + Vector2(8, 9), Vector2(34, 22)), Color("#11181e"), true)
	for index in range(3):
		draw_circle(microwave.position + Vector2(54.0, 12.0 + float(index) * 9.0), 2.0, Color("#b79b66"))
	draw_rect(Rect2(rect.position + Vector2(18.0, 88.0), Vector2(58.0, 42.0)), Color("#4a4034"), true)


func _draw_door(rect: Rect2) -> void:
	draw_rect(Rect2(rect.position + Vector2(-10, -12), Vector2(rect.size.x + 20, rect.size.y + 28)), Color("#161210"), true)
	draw_rect(Rect2(rect.position + Vector2(-6, -8), Vector2(rect.size.x + 12, rect.size.y + 16)), Color("#60472e"), false, 3.0)
	draw_rect(rect, Color("#1b2224"), true)
	draw_rect(rect, Color("#5d4c36"), false, 2.0)
	draw_line(rect.position + Vector2(8, 12), rect.position + Vector2(8, rect.size.y - 12), Color(0.65, 0.5, 0.32, 0.2), 1.0)
	draw_line(rect.position + Vector2(rect.size.x - 10, 10), rect.position + Vector2(rect.size.x - 10, rect.size.y - 10), Color(0.0, 0.0, 0.0, 0.3), 2.0)
	draw_rect(Rect2(rect.position + Vector2(13, 34), Vector2(44, 28)), Color("#26343a"), true)
	draw_circle(rect.position + Vector2(56, 86), 3.0, Color("#b6985b"))


func _draw_bathroom_hint(rect: Rect2) -> void:
	draw_rect(Rect2(rect.position + Vector2(5, 5), rect.size), Color(0.02, 0.016, 0.012, 0.45), true)
	draw_rect(rect, Color("#2a241f"), true)
	draw_rect(rect, Color("#6e5940"), false, 2.0)
	var door_rect: Rect2 = Rect2(rect.position + Vector2(34.0, 20.0), Vector2(rect.size.x - 68.0, rect.size.y - 28.0))
	draw_rect(door_rect, Color("#3a3028"), true)
	draw_rect(door_rect, Color("#8a6d4a"), false, 1.6)
	draw_string(ThemeDB.fallback_font, door_rect.position + Vector2(38.0, 35.0), "화장실", HORIZONTAL_ALIGNMENT_CENTER, 64.0, 12, Color("#d4c5a4"))
	draw_circle(door_rect.position + Vector2(door_rect.size.x - 16.0, door_rect.size.y * 0.55), 3.0, Color("#b6985b"))


func _draw_kitchen_counter(rect: Rect2) -> void:
	draw_rect(Rect2(rect.position + Vector2(4, 5), rect.size), Color(0.02, 0.016, 0.012, 0.46), true)
	draw_rect(rect, Color("#2d241d"), true)
	draw_rect(rect.grow(-5.0), Color("#4b3927"), true)
	draw_rect(rect, Color("#7a5d39"), false, 2.0)
	var sink_rect: Rect2 = Rect2(rect.position + Vector2(24.0, 14.0), Vector2(58.0, 28.0))
	draw_rect(sink_rect, Color("#2e3537"), true)
	draw_rect(sink_rect, Color("#8b806b"), false, 1.0)
	var shelf_rect: Rect2 = Rect2(rect.position + Vector2(112.0, 10.0), Vector2(118.0, 34.0))
	draw_rect(shelf_rect, Color("#33261b"), true)
	draw_rect(shelf_rect, Color("#70563a"), false, 1.0)
	var stove_rect: Rect2 = Rect2(rect.position + Vector2(250.0, 10.0), Vector2(52.0, 38.0))
	draw_rect(stove_rect, Color("#25231f"), true)
	draw_rect(stove_rect, Color("#6c5a40"), false, 1.0)
	draw_circle(stove_rect.get_center(), 12.0, Color("#171512"))


func _draw_rug(rect: Rect2) -> void:
	draw_rect(rect, Color("#2c3b2d").darkened(0.18), true)
	draw_rect(rect, Color(0.68, 0.56, 0.36, 0.28), false, 1.0)


func _draw_round_table(center: Vector2, radius: float) -> void:
	draw_circle(center + Vector2(4.0, 6.0), radius, Color(0.02, 0.016, 0.012, 0.42))
	draw_circle(center, radius, Color("#57391f"))
	draw_arc(center, radius, 0.0, TAU, 48, Color("#8b653b"), 2.0, true)
	draw_rect(Rect2(center + Vector2(-20.0, -10.0), Vector2(38.0, 18.0)), Color("#31517b"), true)
	draw_circle(center + Vector2(36.0, 16.0), 9.0, Color("#2f4758"))


func _draw_power_hub_plate(center: Vector2) -> void:
	var plate_rect: Rect2 = Rect2(center - Vector2(100.0, 52.0), Vector2(200.0, 104.0))
	draw_rect(plate_rect, Color(0.05, 0.04, 0.032, 0.34), true)
	draw_rect(plate_rect, Color(0.75, 0.58, 0.33, 0.25), false, 1.5)
	draw_rect(Rect2(center - Vector2(82.0, 35.0), Vector2(164.0, 70.0)), Color(0.08, 0.065, 0.045, 0.2), false, 1.0)


func _draw_small_clutter(_floor_rect: Rect2) -> void:
	var boxes: Array[Rect2] = [
		Rect2(Vector2(176, 590), Vector2(42, 22)),
		Rect2(Vector2(230, 598), Vector2(36, 18)),
		Rect2(Vector2(1048, 560), Vector2(44, 26)),
		Rect2(Vector2(438, 300), Vector2(34, 18)),
	]
	for rect in boxes:
		draw_rect(rect, Color("#2b241e"), true)
		draw_rect(rect, Color("#594633"), false, 1.0)
	draw_line(Vector2(476, 616), Vector2(544, 622), Color("#201812"), 3.0, true)
	draw_line(Vector2(488, 626), Vector2(552, 630), Color("#201812"), 2.0, true)


func _draw_light_pool() -> void:
	if not used_day1_action_keys.has("light"):
		return

	var glow_rect: Rect2 = Rect2(Vector2(742, 128), Vector2(390, 278))
	draw_texture_rect(AssetPaths.FLUORESCENT_GLOW, glow_rect, false, Color(1.0, 0.88, 0.58, 0.2))

	var desk_center: Vector2 = Vector2(948, 250)
	for index in range(4, 0, -1):
		var alpha: float = 0.012 * float(index)
		draw_circle(desk_center, 32.0 * float(index), Color(0.95, 0.68, 0.31, alpha))
	var floor_center: Vector2 = Vector2(760, 430)
	for index in range(3, 0, -1):
		var alpha: float = 0.008 * float(index)
		draw_circle(floor_center, 42.0 * float(index), Color(0.92, 0.62, 0.26, alpha))


func _draw_power_cables() -> void:
	var power_strip: ApartmentInteractable = interactables_by_id.get("power_strip") as ApartmentInteractable
	if power_strip == null:
		return

	for object_id in interactables_by_id.keys():
		if object_id == "power_strip" or object_id == "light":
			continue

		var power_key: String = _get_power_key_for_object(object_id)
		if not powered_device_keys.has(power_key):
			continue

		var interactable: ApartmentInteractable = interactables_by_id[object_id] as ApartmentInteractable
		if interactable == null:
			continue

		_draw_power_cable(power_strip.position, interactable.position, object_id)


func _draw_power_cable(start_position: Vector2, end_position: Vector2, object_id: String) -> void:
	var points: PackedVector2Array = PackedVector2Array()
	match object_id:
		"laptop":
			points = PackedVector2Array([
				start_position + Vector2(12.0, -26.0),
				Vector2(684.0, 390.0),
				Vector2(826.0, 316.0),
				end_position + Vector2(-28.0, 18.0),
			])
		"charger":
			points = PackedVector2Array([
				start_position + Vector2(42.0, 26.0),
				Vector2(724.0, 502.0),
				end_position + Vector2(-18.0, 10.0),
			])
		"communication_device":
			points = PackedVector2Array([
				start_position + Vector2(56.0, 30.0),
				Vector2(768.0, 548.0),
				Vector2(972.0, 548.0),
				end_position + Vector2(-24.0, 8.0),
			])
		"fan":
			points = PackedVector2Array([
				start_position + Vector2(64.0, -2.0),
				Vector2(804.0, 420.0),
				Vector2(1018.0, 398.0),
				end_position + Vector2(-28.0, 20.0),
			])

	if points.size() == 0:
		var midpoint: Vector2 = (start_position + end_position) * 0.5
		var bend: Vector2 = midpoint + Vector2(0.0, 24.0)
		points = PackedVector2Array([start_position, bend, end_position])

	var cable_alpha: float = 0.78 if phase_key == "day" else 0.9
	draw_polyline(points, Color(0.015, 0.011, 0.009, cable_alpha), 4.4, true)
	draw_polyline(points, Color(0.13, 0.095, 0.065, 0.45), 1.2, true)


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
