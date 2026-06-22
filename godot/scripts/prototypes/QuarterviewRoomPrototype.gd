extends Node2D

const PROTOTYPE_HUB_SCENE := "res://scenes/prototypes/PrototypeHub.tscn"

var floor_points := PackedVector2Array([
	Vector2(245, 170),
	Vector2(965, 170),
	Vector2(1080, 555),
	Vector2(365, 650),
	Vector2(190, 360),
])

var back_wall_points := PackedVector2Array([
	Vector2(245, 70),
	Vector2(965, 70),
	Vector2(965, 170),
	Vector2(245, 170),
])

var left_wall_points := PackedVector2Array([
	Vector2(170, 150),
	Vector2(245, 70),
	Vector2(245, 170),
	Vector2(190, 360),
	Vector2(190, 610),
	Vector2(140, 565),
])

var right_wall_points := PackedVector2Array([
	Vector2(965, 70),
	Vector2(1045, 145),
	Vector2(1125, 495),
	Vector2(1080, 555),
	Vector2(965, 170),
])

const WALL_BLOCKERS := [
	{"name": "top_wall", "rect": Rect2(Vector2(220, 58), Vector2(790, 92))},
	{"name": "left_wall", "rect": Rect2(Vector2(132, 142), Vector2(82, 440))},
	{"name": "right_wall", "rect": Rect2(Vector2(1062, 145), Vector2(78, 430))},
	{"name": "bottom_wall", "rect": Rect2(Vector2(310, 626), Vector2(735, 54))},
	{"name": "upper_left_corner", "rect": Rect2(Vector2(175, 78), Vector2(96, 94))},
	{"name": "upper_right_corner", "rect": Rect2(Vector2(940, 78), Vector2(102, 96))},
]

const LAYER_Z_INDEX := {
	"FloorLayer": 0,
	"WallBackLayer": 10,
	"FurnitureBackLayer": 20,
	"ObjectLayer": 30,
	"PlayerLayer": 40,
	"FurnitureFrontLayer": 50,
	"InteractionDebugLayer": 80,
	"LabelLayer": 90,
}

const PRIMARY_ACTION_LABEL_BY_ROLE := {
	"manual_end_day": "Rest / End Day",
	"laptop_job": "Open Work",
	"phone_status": "Check Phone",
	"phone_charge": "Charge",
	"power_management": "Open Power",
	"communication": "Check Signal",
	"mystery_device": "Inspect NODE",
	"audio_hacking_device": "Enable Audio",
	"living_appliance": "Use Appliance",
	"support_device": "Use Device",
	"background_life_hint": "Inspect",
	"background_structure": "Inspect",
}

const OBJECT_REGISTRY := [
	{
		"key": "bed",
		"display_name": "Bed",
		"zone": "living",
		"role": "manual_end_day",
		"future_source": "apartment_bed",
		"visual_state": "idle",
		"layer": "FurnitureBackLayer",
		"position": Vector2(344, 386),
		"size": Vector2(205, 132),
		"blocks": true,
		"interactable": true,
		"color": Color(0.22, 0.34, 0.25, 1.0),
		"blocker_rect": Rect2(Vector2(246, 326), Vector2(230, 152)),
		"interaction_position": Vector2(460, 488),
		"interaction_radius": 82.0,
		"sort_y": 466,
		"thickness": 24.0,
	},
	{
		"key": "desk",
		"display_name": "Desk",
		"zone": "work",
		"role": "support_device",
		"future_source": "future_desk",
		"visual_state": "idle",
		"layer": "FurnitureBackLayer",
		"position": Vector2(762, 272),
		"size": Vector2(275, 92),
		"blocks": true,
		"interactable": false,
		"color": Color(0.36, 0.23, 0.13, 1.0),
		"blocker_rect": Rect2(Vector2(620, 222), Vector2(300, 122)),
		"sort_y": 346,
		"thickness": 18.0,
	},
	{
		"key": "laptop",
		"display_name": "Laptop",
		"zone": "work",
		"role": "laptop_job",
		"future_source": "apartment_laptop",
		"visual_state": "on",
		"layer": "ObjectLayer",
		"position": Vector2(748, 238),
		"size": Vector2(74, 36),
		"blocks": false,
		"interactable": true,
		"color": Color(0.08, 0.12, 0.15, 1.0),
		"interaction_position": Vector2(748, 360),
		"interaction_radius": 74.0,
		"sort_y": 356,
		"thickness": 7.0,
	},
	{
		"key": "fridge",
		"display_name": "Fridge",
		"zone": "kitchen",
		"role": "living_appliance",
		"future_source": "future_fridge",
		"visual_state": "idle",
		"layer": "FurnitureBackLayer",
		"position": Vector2(994, 288),
		"size": Vector2(78, 152),
		"blocks": true,
		"interactable": true,
		"color": Color(0.35, 0.38, 0.39, 1.0),
		"blocker_rect": Rect2(Vector2(954, 210), Vector2(94, 172)),
		"interaction_position": Vector2(920, 318),
		"interaction_radius": 78.0,
		"sort_y": 382,
		"thickness": 12.0,
	},
	{
		"key": "microwave",
		"display_name": "Microwave",
		"zone": "kitchen",
		"role": "living_appliance",
		"future_source": "future_microwave",
		"visual_state": "idle",
		"layer": "ObjectLayer",
		"position": Vector2(940, 448),
		"size": Vector2(104, 44),
		"blocks": true,
		"interactable": true,
		"color": Color(0.23, 0.25, 0.27, 1.0),
		"blocker_rect": Rect2(Vector2(880, 416), Vector2(144, 76)),
		"interaction_position": Vector2(860, 468),
		"interaction_radius": 68.0,
		"sort_y": 492,
		"thickness": 10.0,
	},
	{
		"key": "aircon",
		"display_name": "AC",
		"zone": "utility",
		"role": "living_appliance",
		"future_source": "future_aircon",
		"visual_state": "off",
		"layer": "WallBackLayer",
		"position": Vector2(880, 122),
		"size": Vector2(128, 30),
		"blocks": false,
		"interactable": true,
		"color": Color(0.48, 0.50, 0.48, 1.0),
		"interaction_position": Vector2(870, 186),
		"interaction_radius": 62.0,
		"sort_y": 168,
		"thickness": 6.0,
	},
	{
		"key": "power",
		"display_name": "Power",
		"zone": "power",
		"role": "power_management",
		"future_source": "apartment_outlet",
		"visual_state": "idle",
		"layer": "ObjectLayer",
		"position": Vector2(742, 462),
		"size": Vector2(126, 38),
		"blocks": false,
		"interactable": true,
		"color": Color(0.18, 0.18, 0.14, 1.0),
		"interaction_position": Vector2(742, 516),
		"interaction_radius": 78.0,
		"sort_y": 506,
		"thickness": 8.0,
	},
	{
		"key": "comm",
		"display_name": "Comm",
		"zone": "work",
		"role": "communication",
		"future_source": "apartment_communication",
		"visual_state": "off",
		"layer": "ObjectLayer",
		"position": Vector2(902, 326),
		"size": Vector2(88, 48),
		"blocks": false,
		"interactable": true,
		"color": Color(0.15, 0.19, 0.22, 1.0),
		"interaction_position": Vector2(862, 372),
		"interaction_radius": 70.0,
		"sort_y": 374,
		"thickness": 10.0,
	},
	{
		"key": "node17",
		"display_name": "NODE-17",
		"zone": "work",
		"role": "mystery_device",
		"future_source": "future_node17",
		"visual_state": "off",
		"layer": "ObjectLayer",
		"position": Vector2(890, 242),
		"size": Vector2(64, 64),
		"blocks": false,
		"interactable": true,
		"color": Color(0.16, 0.11, 0.20, 1.0),
		"interaction_position": Vector2(842, 306),
		"interaction_radius": 74.0,
		"sort_y": 314,
		"thickness": 14.0,
	},
	{
		"key": "phone",
		"display_name": "Phone",
		"zone": "living",
		"role": "phone_charge",
		"future_source": "apartment_phone_or_charger",
		"visual_state": "idle",
		"layer": "ObjectLayer",
		"position": Vector2(498, 438),
		"size": Vector2(52, 30),
		"blocks": false,
		"interactable": true,
		"color": Color(0.04, 0.06, 0.08, 1.0),
		"interaction_position": Vector2(532, 474),
		"interaction_radius": 62.0,
		"sort_y": 476,
		"thickness": 5.0,
	},
	{
		"key": "door",
		"display_name": "Door",
		"zone": "entrance",
		"role": "background_structure",
		"future_source": "none",
		"visual_state": "idle",
		"layer": "WallBackLayer",
		"position": Vector2(204, 520),
		"size": Vector2(64, 118),
		"blocks": false,
		"interactable": false,
		"color": Color(0.18, 0.12, 0.09, 1.0),
		"sort_y": 216,
		"thickness": 8.0,
	},
	{
		"key": "bathroom_door",
		"display_name": "Bath Door",
		"zone": "utility",
		"role": "background_structure",
		"future_source": "none",
		"visual_state": "idle",
		"layer": "WallBackLayer",
		"position": Vector2(276, 575),
		"size": Vector2(68, 104),
		"blocks": false,
		"interactable": false,
		"color": Color(0.16, 0.14, 0.12, 1.0),
		"sort_y": 232,
		"thickness": 8.0,
	},
	{
		"key": "speaker",
		"display_name": "Speaker",
		"zone": "work",
		"role": "audio_hacking_device",
		"future_source": "future_audio_hacking",
		"visual_state": "off",
		"layer": "ObjectLayer",
		"position": Vector2(832, 258),
		"size": Vector2(34, 52),
		"blocks": false,
		"interactable": true,
		"color": Color(0.08, 0.09, 0.10, 1.0),
		"interaction_position": Vector2(825, 342),
		"interaction_radius": 56.0,
		"sort_y": 338,
		"thickness": 8.0,
	},
	{
		"key": "ups",
		"display_name": "UPS",
		"zone": "power",
		"role": "support_device",
		"future_source": "future_ups",
		"visual_state": "idle",
		"layer": "ObjectLayer",
		"position": Vector2(836, 484),
		"size": Vector2(64, 52),
		"blocks": false,
		"interactable": true,
		"color": Color(0.12, 0.13, 0.14, 1.0),
		"interaction_position": Vector2(820, 536),
		"interaction_radius": 60.0,
		"sort_y": 536,
		"thickness": 10.0,
	},
	{
		"key": "signal_booster",
		"display_name": "Signal",
		"zone": "work",
		"role": "support_device",
		"future_source": "future_signal_booster",
		"visual_state": "off",
		"layer": "ObjectLayer",
		"position": Vector2(942, 280),
		"size": Vector2(48, 42),
		"blocks": false,
		"interactable": true,
		"color": Color(0.10, 0.16, 0.18, 1.0),
		"interaction_position": Vector2(900, 334),
		"interaction_radius": 58.0,
		"sort_y": 334,
		"thickness": 8.0,
	},
	{
		"key": "shelf",
		"display_name": "Shelf",
		"zone": "background",
		"role": "background_life_hint",
		"future_source": "future_room_prop",
		"visual_state": "idle",
		"layer": "WallBackLayer",
		"position": Vector2(410, 190),
		"size": Vector2(150, 38),
		"blocks": false,
		"interactable": false,
		"color": Color(0.26, 0.18, 0.11, 1.0),
		"sort_y": 228,
		"thickness": 7.0,
	},
	{
		"key": "small_table",
		"display_name": "Small Table",
		"zone": "living",
		"role": "background_life_hint",
		"future_source": "future_room_prop",
		"visual_state": "idle",
		"layer": "FurnitureFrontLayer",
		"position": Vector2(590, 555),
		"size": Vector2(108, 64),
		"blocks": false,
		"interactable": false,
		"color": Color(0.28, 0.18, 0.10, 1.0),
		"sort_y": 626,
		"thickness": 12.0,
	},
]

@onready var world: Node2D = $World
@onready var floor_layer: Node2D = $World/FloorLayer
@onready var wall_back_layer: Node2D = $World/WallBackLayer
@onready var furniture_back_layer: Node2D = $World/FurnitureBackLayer
@onready var object_layer: Node2D = $World/ObjectLayer
@onready var player_layer: Node2D = $World/PlayerLayer
@onready var furniture_front_layer: Node2D = $World/FurnitureFrontLayer
@onready var interaction_debug_layer: Node2D = $World/InteractionDebugLayer
@onready var label_layer: Node2D = $World/LabelLayer
@onready var player: CharacterBody2D = $World/PlayerLayer/Player
@onready var prompt_label: Label = $UI/PromptLabel
@onready var object_panel: Control = $UI/ObjectInteractionPanel
@onready var object_panel_title: Label = $UI/ObjectInteractionPanel/Panel/Margin/VBox/TitleLabel
@onready var object_panel_detail: Label = $UI/ObjectInteractionPanel/Panel/Margin/VBox/DetailLabel
@onready var primary_button: Button = $UI/ObjectInteractionPanel/Panel/Margin/VBox/ActionButtonContainer/PrimaryButton
@onready var inspect_button: Button = $UI/ObjectInteractionPanel/Panel/Margin/VBox/ActionButtonContainer/InspectButton
@onready var close_button: Button = $UI/ObjectInteractionPanel/Panel/Margin/VBox/ActionButtonContainer/CloseButton

var nearest_object: Dictionary = {}
var panel_object: Dictionary = {}


func _ready() -> void:
	_configure_layers()
	_build_collision()
	_build_placeholder_objects()
	_configure_labels()
	_configure_object_panel()


func _process(_delta: float) -> void:
	_update_nearest_interactable()
	_apply_depth_order()
	queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_B or event.keycode == KEY_BACKSPACE:
			_go_to_prototype_hub()
			get_viewport().set_input_as_handled()
			return
		if event.keycode == KEY_ESCAPE and _is_object_panel_open():
			_close_object_panel()
			get_viewport().set_input_as_handled()
			return

	if _is_object_panel_open():
		if event.is_action_pressed("interact"):
			_run_primary_action()
			get_viewport().set_input_as_handled()
		return

	if event.is_action_pressed("interact") and not nearest_object.is_empty():
		_open_object_panel(nearest_object)
		get_viewport().set_input_as_handled()


func _go_to_prototype_hub() -> void:
	print("Quarterview prototype: PrototypeHub로 돌아갑니다.")
	get_tree().change_scene_to_file(PROTOTYPE_HUB_SCENE)


func _draw() -> void:
	_draw_room_shell()
	_draw_collision_guides()
	_draw_interaction_ranges()


func _build_collision() -> void:
	for wall_data in WALL_BLOCKERS:
		_add_blocker(wall_data["name"], wall_data["rect"])

	for placeholder_data in OBJECT_REGISTRY:
		if placeholder_data["blocks"] and placeholder_data.has("blocker_rect"):
			_add_blocker("%s_blocker" % placeholder_data["key"], placeholder_data["blocker_rect"])


func _build_placeholder_objects() -> void:
	for object_data in OBJECT_REGISTRY:
		var object_node := Node2D.new()
		object_node.name = "%sPlaceholder" % object_data["key"].capitalize().replace("_", "")
		object_node.position = object_data["position"]
		object_node.z_as_relative = false
		object_node.z_index = int(object_data["sort_y"])
		_get_placeholder_layer(object_data).add_child(object_node)

		_add_placeholder_shape(object_node, object_data)
		_add_placeholder_label(object_data)


func _add_placeholder_shape(parent: Node2D, object_data: Dictionary) -> void:
	var size: Vector2 = object_data["size"]
	var half := size * 0.5
	var thickness := float(object_data.get("thickness", 10.0))
	var color: Color = object_data["color"]
	var outline_color := Color(0.92, 0.72, 0.40, 0.45)

	var shadow := Polygon2D.new()
	shadow.position = Vector2(8, 12)
	shadow.polygon = PackedVector2Array([
		Vector2(-half.x, -half.y),
		Vector2(half.x, -half.y),
		Vector2(half.x, half.y + thickness),
		Vector2(-half.x, half.y + thickness),
	])
	shadow.color = Color(0.01, 0.01, 0.01, 0.36)
	parent.add_child(shadow)

	var face := Polygon2D.new()
	face.polygon = PackedVector2Array([
		Vector2(-half.x, half.y),
		Vector2(half.x, half.y),
		Vector2(half.x, half.y + thickness),
		Vector2(-half.x, half.y + thickness),
	])
	face.color = color.darkened(0.24)
	parent.add_child(face)

	var top := Polygon2D.new()
	top.polygon = PackedVector2Array([
		Vector2(-half.x, -half.y),
		Vector2(half.x, -half.y),
		Vector2(half.x, half.y),
		Vector2(-half.x, half.y),
	])
	top.color = color
	parent.add_child(top)

	var outline := Line2D.new()
	outline.closed = true
	outline.width = 2.0
	outline.default_color = outline_color
	outline.points = PackedVector2Array([
		Vector2(-half.x, -half.y),
		Vector2(half.x, -half.y),
		Vector2(half.x, half.y + thickness),
		Vector2(-half.x, half.y + thickness),
	])
	parent.add_child(outline)


func _add_placeholder_label(object_data: Dictionary) -> void:
	var size: Vector2 = object_data["size"]
	var label := Label.new()
	label.text = _get_object_display_name(object_data).to_upper()
	label.position = object_data["position"] + Vector2(-size.x * 0.5, -size.y * 0.5 - 25.0)
	label.add_theme_color_override("font_color", Color(0.94, 0.84, 0.66, 1.0))
	label.add_theme_color_override("font_outline_color", Color(0.02, 0.015, 0.01, 1.0))
	label.add_theme_constant_override("outline_size", 3)
	label_layer.add_child(label)


func _add_blocker(blocker_name: String, rect: Rect2) -> void:
	var body := StaticBody2D.new()
	body.name = blocker_name
	body.position = rect.position + rect.size * 0.5
	world.add_child(body)

	var shape := CollisionShape2D.new()
	var rectangle := RectangleShape2D.new()
	rectangle.size = rect.size
	shape.shape = rectangle
	body.add_child(shape)


func _configure_labels() -> void:
	prompt_label.text = ""


func _configure_object_panel() -> void:
	object_panel.visible = false
	primary_button.pressed.connect(_run_primary_action)
	inspect_button.pressed.connect(_run_inspect_action)
	close_button.pressed.connect(_close_object_panel)


func _is_object_panel_open() -> bool:
	return object_panel.visible


func _open_object_panel(object_data: Dictionary) -> void:
	panel_object = object_data
	object_panel_title.text = _get_object_display_name(object_data).to_upper()
	object_panel_detail.text = "\n".join([
		"key: %s" % object_data["key"],
		"zone: %s" % object_data["zone"],
		"role: %s" % object_data["role"],
		"future: %s" % object_data["future_source"],
		"state: %s" % object_data["visual_state"],
	])
	primary_button.text = _get_primary_action_label(String(object_data["role"]))
	object_panel.visible = true
	object_panel.move_to_front()
	prompt_label.text = ""
	player.velocity = Vector2.ZERO
	player.set_physics_process(false)
	print(
		"Quarterview prototype interact: %s / zone=%s / role=%s / future=%s / state=%s"
		% [
			object_data["key"],
			object_data["zone"],
			object_data["role"],
			object_data["future_source"],
			object_data["visual_state"],
		]
	)


func _close_object_panel() -> void:
	object_panel.visible = false
	panel_object = {}
	player.set_physics_process(true)


func _run_primary_action() -> void:
	if panel_object.is_empty():
		return
	print(
		"Quarterview object action: %s / action=primary / role=%s / no-op"
		% [
			panel_object["key"],
			panel_object["role"],
		]
	)


func _run_inspect_action() -> void:
	if panel_object.is_empty():
		return
	print(
		"Quarterview object inspect: %s / future=%s / state=%s / no-op"
		% [
			panel_object["key"],
			panel_object["future_source"],
			panel_object["visual_state"],
		]
	)


func _get_primary_action_label(role: String) -> String:
	return String(PRIMARY_ACTION_LABEL_BY_ROLE.get(role, "Use Device"))


func _configure_layers() -> void:
	for layer_name in LAYER_Z_INDEX.keys():
		var layer := world.get_node_or_null(layer_name) as Node2D
		if layer == null:
			continue
		layer.z_as_relative = false
		layer.z_index = LAYER_Z_INDEX[layer_name]
		layer.y_sort_enabled = layer_name in ["FurnitureBackLayer", "ObjectLayer", "PlayerLayer", "FurnitureFrontLayer"]


func _get_placeholder_layer(object_data: Dictionary) -> Node2D:
	match String(object_data.get("layer", "ObjectLayer")):
		"FloorLayer":
			return floor_layer
		"WallBackLayer":
			return wall_back_layer
		"FurnitureBackLayer":
			return furniture_back_layer
		"PlayerLayer":
			return player_layer
		"FurnitureFrontLayer":
			return furniture_front_layer
		"InteractionDebugLayer":
			return interaction_debug_layer
		"LabelLayer":
			return label_layer
		_:
			return object_layer


func _apply_depth_order() -> void:
	player.z_as_relative = false
	player.z_index = int(player.global_position.y)


func get_object_definition(key: String) -> Dictionary:
	for object_data in OBJECT_REGISTRY:
		if object_data["key"] == key:
			return object_data
	return {}


func get_interactable_keys() -> Array[String]:
	var keys: Array[String] = []
	for object_data in OBJECT_REGISTRY:
		if object_data["interactable"]:
			keys.append(String(object_data["key"]))
	return keys


func get_objects_by_zone(zone: String) -> Array:
	var results := []
	for object_data in OBJECT_REGISTRY:
		if object_data["zone"] == zone:
			results.append(object_data)
	return results


func get_objects_by_role(role: String) -> Array:
	var results := []
	for object_data in OBJECT_REGISTRY:
		if object_data["role"] == role:
			results.append(object_data)
	return results


func _get_object_display_name(object_data: Dictionary) -> String:
	return String(object_data.get("display_name", object_data["key"]))


func _update_nearest_interactable() -> void:
	if _is_object_panel_open():
		prompt_label.text = ""
		return

	var next_nearest: Dictionary = {}
	var closest_distance := INF

	for object_data in OBJECT_REGISTRY:
		if not object_data["interactable"]:
			continue

		var interaction_position: Vector2 = object_data["interaction_position"]
		var radius := float(object_data["interaction_radius"])
		var distance := player.global_position.distance_to(interaction_position)
		if distance <= radius and distance < closest_distance:
			next_nearest = object_data
			closest_distance = distance

	nearest_object = next_nearest

	if nearest_object.is_empty():
		prompt_label.text = ""
	else:
		prompt_label.text = "E: %s" % _get_object_display_name(nearest_object)


func _draw_room_shell() -> void:
	draw_colored_polygon(left_wall_points, Color(0.14, 0.12, 0.14, 1.0))
	draw_colored_polygon(right_wall_points, Color(0.13, 0.115, 0.13, 1.0))
	draw_colored_polygon(back_wall_points, Color(0.20, 0.17, 0.15, 1.0))
	draw_colored_polygon(floor_points, Color(0.24, 0.16, 0.10, 1.0))

	draw_polyline(_closed_points(floor_points), Color(0.78, 0.58, 0.32, 0.65), 2.0, true)
	draw_line(Vector2(245, 170), Vector2(965, 170), Color(0.95, 0.72, 0.42, 0.55), 3.0)
	draw_line(Vector2(245, 82), Vector2(965, 82), Color(0.06, 0.055, 0.05, 0.95), 6.0)

	_draw_window_placeholder()
	_draw_door_placeholder()
	_draw_floor_guides()


func _draw_window_placeholder() -> void:
	var window_rect := Rect2(Vector2(480, 96), Vector2(210, 50))
	draw_rect(window_rect, Color(0.025, 0.06, 0.12, 1.0), true)
	draw_rect(window_rect, Color(0.68, 0.82, 1.0, 0.42), false, 2.0)
	draw_line(window_rect.position + Vector2(window_rect.size.x * 0.5, 0), window_rect.position + Vector2(window_rect.size.x * 0.5, window_rect.size.y), Color(0.68, 0.82, 1.0, 0.35), 1.5)
	draw_line(window_rect.position + Vector2(0, window_rect.size.y * 0.52), window_rect.position + Vector2(window_rect.size.x, window_rect.size.y * 0.52), Color(0.68, 0.82, 1.0, 0.35), 1.5)


func _draw_door_placeholder() -> void:
	var door_points := PackedVector2Array([
		Vector2(1010, 205),
		Vector2(1065, 240),
		Vector2(1100, 390),
		Vector2(1042, 364),
	])
	draw_colored_polygon(door_points, Color(0.18, 0.12, 0.09, 1.0))
	draw_polyline(_closed_points(door_points), Color(0.84, 0.64, 0.38, 0.52), 2.0, true)


func _draw_floor_guides() -> void:
	for index in range(7):
		var t := float(index) / 6.0
		var left := Vector2(220, 350).lerp(Vector2(365, 650), t)
		var right := Vector2(965, 170).lerp(Vector2(1080, 555), t)
		draw_line(left, right, Color(0.10, 0.075, 0.055, 0.35), 1.0)


func _draw_collision_guides() -> void:
	for wall_data in WALL_BLOCKERS:
		draw_rect(wall_data["rect"], Color(0.95, 0.18, 0.12, 0.14), true)
		draw_rect(wall_data["rect"], Color(1.0, 0.26, 0.18, 0.55), false, 2.0)

	for object_data in OBJECT_REGISTRY:
		if object_data["blocks"] and object_data.has("blocker_rect"):
			draw_rect(object_data["blocker_rect"], Color(1.0, 0.42, 0.10, 0.10), true)
			draw_rect(object_data["blocker_rect"], Color(1.0, 0.42, 0.10, 0.58), false, 2.0)


func _draw_interaction_ranges() -> void:
	for object_data in OBJECT_REGISTRY:
		if not object_data["interactable"]:
			continue

		var interaction_position: Vector2 = object_data["interaction_position"]
		var radius := float(object_data["interaction_radius"])
		var color := Color(0.15, 0.95, 0.46, 0.30)
		var width := 1.5

		if not nearest_object.is_empty() and nearest_object["key"] == object_data["key"]:
			color = Color(1.0, 0.86, 0.22, 0.70)
			width = 3.0

		draw_arc(interaction_position, radius, 0.0, TAU, 56, color, width)
		draw_circle(interaction_position, 4.0, color)


func _closed_points(points: PackedVector2Array) -> PackedVector2Array:
	var closed := PackedVector2Array(points)
	if not closed.is_empty():
		closed.append(closed[0])
	return closed
