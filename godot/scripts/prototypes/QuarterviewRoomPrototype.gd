extends Node2D

const INPUT_PROMPTS_SCRIPT := preload("res://scripts/prototypes/PrototypeInputPrompts.gd")
const PROTOTYPE_SFX_SCRIPT := preload("res://scripts/prototypes/PrototypeSfx.gd")
const PROTOTYPE_UTILS := preload("res://scripts/prototypes/PrototypeSceneUtils.gd")

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

const ROOM_OBJECT_DEFINITION_SCRIPT := preload("res://scripts/resources/RoomObjectDefinition.gd")
const OBJECT_RESOURCE_PATHS := [
	"res://resources/rooms/quarterview/objects/bed.tres",
	"res://resources/rooms/quarterview/objects/desk.tres",
	"res://resources/rooms/quarterview/objects/laptop.tres",
	"res://resources/rooms/quarterview/objects/fridge.tres",
	"res://resources/rooms/quarterview/objects/microwave.tres",
	"res://resources/rooms/quarterview/objects/aircon.tres",
	"res://resources/rooms/quarterview/objects/power.tres",
	"res://resources/rooms/quarterview/objects/comm.tres",
	"res://resources/rooms/quarterview/objects/node17.tres",
	"res://resources/rooms/quarterview/objects/phone.tres",
	"res://resources/rooms/quarterview/objects/door.tres",
	"res://resources/rooms/quarterview/objects/bathroom_door.tres",
	"res://resources/rooms/quarterview/objects/speaker.tres",
	"res://resources/rooms/quarterview/objects/ups.tres",
	"res://resources/rooms/quarterview/objects/signal_booster.tres",
	"res://resources/rooms/quarterview/objects/shelf.tres",
	"res://resources/rooms/quarterview/objects/small_table.tres",
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
@onready var ui_layer: CanvasLayer = $UI
@onready var prompt_label: Label = $UI/PromptLabel
@onready var object_panel: Control = $UI/ObjectInteractionPanel
@onready var object_panel_title: Label = $UI/ObjectInteractionPanel/Panel/Margin/VBox/TitleLabel
@onready var object_panel_detail: Label = $UI/ObjectInteractionPanel/Panel/Margin/VBox/DetailLabel
@onready var primary_button: Button = $UI/ObjectInteractionPanel/Panel/Margin/VBox/ActionButtonContainer/PrimaryButton
@onready var inspect_button: Button = $UI/ObjectInteractionPanel/Panel/Margin/VBox/ActionButtonContainer/InspectButton
@onready var close_button: Button = $UI/ObjectInteractionPanel/Panel/Margin/VBox/ActionButtonContainer/CloseButton

var nearest_object: Dictionary = {}
var panel_object: Dictionary = {}
var debug_overlay_enabled := false
var object_registry: Array[Dictionary] = []
var nearby_prompt_row: HBoxContainer
var nearby_prompt_text: Label
var sfx


func _ready() -> void:
	object_registry = _load_object_definitions()
	_configure_sfx()
	_configure_layers()
	_build_collision()
	_build_placeholder_objects()
	_configure_labels()
	_configure_input_prompt_icons()
	_configure_object_panel()


func _configure_sfx() -> void:
	sfx = PROTOTYPE_SFX_SCRIPT.new()
	sfx.name = "PrototypeSfx"
	add_child(sfx)


func _process(_delta: float) -> void:
	_update_nearest_interactable()
	_apply_depth_order()
	queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if PROTOTYPE_UTILS.is_hub_back_event(event):
			_go_to_prototype_hub()
			get_viewport().set_input_as_handled()
			return
		if PROTOTYPE_UTILS.is_debug_toggle_event(event):
			_toggle_debug_overlay()
			get_viewport().set_input_as_handled()
			return
		if PROTOTYPE_UTILS.is_cancel_event(event) and _is_object_panel_open():
			_close_object_panel()
			get_viewport().set_input_as_handled()
			return

	if _is_object_panel_open():
		if PROTOTYPE_UTILS.is_confirm_event(event):
			_run_primary_action()
			get_viewport().set_input_as_handled()
		return

	if PROTOTYPE_UTILS.is_confirm_event(event) and not nearest_object.is_empty():
		_open_object_panel(nearest_object)
		get_viewport().set_input_as_handled()


func _go_to_prototype_hub() -> void:
	sfx.play_cancel()
	print("Quarterview prototype: PrototypeHub로 돌아갑니다.")
	PROTOTYPE_UTILS.go_to_hub(self)


func _draw() -> void:
	_draw_room_shell()
	if debug_overlay_enabled:
		_draw_collision_guides()
		_draw_interaction_ranges()


func _build_collision() -> void:
	for wall_data in WALL_BLOCKERS:
		_add_blocker(wall_data["name"], wall_data["rect"])

	for placeholder_data in object_registry:
		if placeholder_data["blocks"] and placeholder_data["blocker_rect"].size != Vector2.ZERO:
			_add_blocker("%s_blocker" % placeholder_data["key"], placeholder_data["blocker_rect"])


func _build_placeholder_objects() -> void:
	for object_data in object_registry:
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
	label_layer.visible = debug_overlay_enabled


func _configure_input_prompt_icons() -> void:
	var guide_box := INPUT_PROMPTS_SCRIPT.create_prompt_box(
		[
			{"keys": ["arrows"], "text": "Move"},
			{"keys": ["e"], "text": "Interact"},
			{"keys": ["d"], "text": "Debug overlay"},
			{"keys": ["b", "backspace"], "text": "Prototype Hub"},
			{"keys": ["escape"], "text": "Close panel"},
		],
		Vector2(24, 24),
		Color(0.93, 0.86, 0.72, 1.0)
	)
	guide_box.position = Vector2(24, 196)
	ui_layer.add_child(guide_box)

	nearby_prompt_row = INPUT_PROMPTS_SCRIPT.create_prompt_row(["e"], "", Vector2(34, 34), Color(1.0, 0.86, 0.45, 1.0))
	nearby_prompt_row.name = "NearbyObjectPrompt"
	nearby_prompt_row.position = Vector2(520, 642)
	nearby_prompt_row.visible = false
	ui_layer.add_child(nearby_prompt_row)
	nearby_prompt_text = nearby_prompt_row.get_node("PromptText") as Label


func _toggle_debug_overlay() -> void:
	debug_overlay_enabled = not debug_overlay_enabled
	sfx.play_select()
	label_layer.visible = debug_overlay_enabled
	if _is_object_panel_open() and not panel_object.is_empty():
		_refresh_object_panel_detail()
	queue_redraw()
	print("Quarterview prototype debug overlay: %s" % ("ON" if debug_overlay_enabled else "OFF"))


func _configure_object_panel() -> void:
	object_panel.visible = false
	primary_button.pressed.connect(_run_primary_action)
	inspect_button.pressed.connect(_run_inspect_action)
	close_button.pressed.connect(_close_object_panel)
	for button in [primary_button, inspect_button, close_button]:
		button.mouse_entered.connect(sfx.play_select)
		button.focus_entered.connect(sfx.play_select)


func _is_object_panel_open() -> bool:
	return object_panel.visible


func _open_object_panel(object_data: Dictionary) -> void:
	panel_object = object_data
	sfx.play_open()
	object_panel_title.text = _get_object_display_name(object_data).to_upper()
	_refresh_object_panel_detail()
	primary_button.text = String(object_data.get("primary_action_label", "Interact"))
	inspect_button.text = String(object_data.get("inspect_action_label", "Inspect"))
	object_panel.visible = true
	object_panel.move_to_front()
	prompt_label.text = ""
	_set_nearby_prompt("")
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
	if _is_object_panel_open():
		sfx.play_cancel()
	object_panel.visible = false
	panel_object = {}
	player.set_physics_process(true)


func _run_primary_action() -> void:
	if panel_object.is_empty():
		return
	sfx.play_confirm()
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
	sfx.play_select()
	print(
		"Quarterview object inspect: %s / future=%s / state=%s / no-op"
		% [
			panel_object["key"],
			panel_object["future_source"],
			panel_object["visual_state"],
		]
	)


func _refresh_object_panel_detail() -> void:
	if panel_object.is_empty():
		object_panel_detail.text = ""
		return

	if debug_overlay_enabled:
		object_panel_detail.text = "\n".join([
			"key: %s" % panel_object["key"],
			"zone: %s" % panel_object["zone"],
			"role: %s" % panel_object["role"],
			"future: %s" % panel_object["future_source"],
			"state: %s" % panel_object["visual_state"],
		])
	else:
		object_panel_detail.text = "\n".join([
			"state: %s" % panel_object["visual_state"],
			"prototype no-op action only",
		])


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


func _load_object_definitions() -> Array[Dictionary]:
	var loaded_objects: Array[Dictionary] = []
	var seen_keys := {}

	for resource_path in OBJECT_RESOURCE_PATHS:
		var resource := load(resource_path)
		if resource == null:
			push_warning("Quarterview object resource missing: %s" % resource_path)
			continue
		if resource.get_script() != ROOM_OBJECT_DEFINITION_SCRIPT:
			push_warning("Quarterview object resource has wrong type: %s" % resource_path)
			continue

		var definition = resource
		if not definition.is_valid_definition():
			push_warning("Quarterview object resource is invalid: %s" % resource_path)
			continue
		if seen_keys.has(definition.key):
			push_warning("Quarterview object resource duplicate key skipped: %s" % definition.key)
			continue

		seen_keys[definition.key] = true
		loaded_objects.append(_object_definition_to_dictionary(definition))

	return loaded_objects


func _object_definition_to_dictionary(definition) -> Dictionary:
	return {
		"key": definition.key,
		"display_name": definition.display_name,
		"zone": definition.zone,
		"role": definition.role,
		"future_source": definition.future_source,
		"visual_state": definition.visual_state,
		"layer": definition.layer,
		"position": definition.position,
		"size": definition.size,
		"blocks": definition.blocks,
		"interactable": definition.interactable,
		"color": definition.color,
		"blocker_rect": definition.blocker_rect,
		"interaction_position": definition.get_interaction_position(),
		"interaction_radius": definition.interaction_radius,
		"sort_y": definition.sort_y,
		"thickness": definition.thickness,
		"primary_action_label": definition.get_primary_label(),
		"inspect_action_label": definition.inspect_action_label,
	}


func get_object_definition(key: String) -> Dictionary:
	for object_data in object_registry:
		if object_data["key"] == key:
			return object_data
	return {}


func get_interactable_keys() -> Array[String]:
	var keys: Array[String] = []
	for object_data in object_registry:
		if object_data["interactable"]:
			keys.append(String(object_data["key"]))
	return keys


func get_objects_by_zone(zone: String) -> Array:
	var results := []
	for object_data in object_registry:
		if object_data["zone"] == zone:
			results.append(object_data)
	return results


func get_objects_by_role(role: String) -> Array:
	var results := []
	for object_data in object_registry:
		if object_data["role"] == role:
			results.append(object_data)
	return results


func _get_object_display_name(object_data: Dictionary) -> String:
	return String(object_data.get("display_name", object_data["key"]))


func _update_nearest_interactable() -> void:
	if _is_object_panel_open():
		prompt_label.text = ""
		_set_nearby_prompt("")
		return

	var next_nearest: Dictionary = {}
	var closest_distance := INF

	for object_data in object_registry:
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
		_set_nearby_prompt("")
	else:
		prompt_label.text = ""
		_set_nearby_prompt(_get_object_display_name(nearest_object))


func _set_nearby_prompt(prompt_text: String) -> void:
	if nearby_prompt_row == null or nearby_prompt_text == null:
		return
	nearby_prompt_text.text = prompt_text
	nearby_prompt_row.visible = prompt_text != ""


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

	for object_data in object_registry:
		if object_data["blocks"] and object_data["blocker_rect"].size != Vector2.ZERO:
			draw_rect(object_data["blocker_rect"], Color(1.0, 0.42, 0.10, 0.10), true)
			draw_rect(object_data["blocker_rect"], Color(1.0, 0.42, 0.10, 0.58), false, 2.0)


func _draw_interaction_ranges() -> void:
	for object_data in object_registry:
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
