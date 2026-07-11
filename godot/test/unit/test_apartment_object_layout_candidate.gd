extends GutTest

const SHELL_SCENE := preload("res://scenes/quarterview/QuarterviewApartmentShellCandidate.tscn")
const FOOTPRINT_SET := preload("res://resources/quarterview/apartment_shell_object_footprints.tres")

const EXPECTED_IDS := [
	"entrance_door", "bed", "fridge", "microwave", "navi_link",
	"power_module_board", "node_17", "sink_counter", "dining_table",
	"signal_booster", "ups_unit", "bathroom_fixture", "sea_horizon_poster",
	"fluorescent_light", "shoes_slippers", "cable_bundle", "wall_conduit",
	"power_housing",
]
const RETIRED_IDS := [
	"phone", "air_conditioner", "desk", "bed_placeholder", "fridge_placeholder",
	"microwave_placeholder", "sink_counter_placeholder", "small_table_placeholder",
	"desk_placeholder", "navi_chair_placeholder", "power_panel_placeholder",
	"connector_board_placeholder", "comm_device_placeholder",
	"bathroom_fixture_placeholder", "entrance_shoe_area_placeholder",
]


func test_resource_contains_exact_candidate_inventory() -> void:
	assert_eq(_sorted_ids(FOOTPRINT_SET.objects), _sorted_strings(EXPECTED_IDS))
	for retired_id in RETIRED_IDS:
		assert_false(_object_map(FOOTPRINT_SET.objects).has(retired_id), "%s must not remain a world footprint." % retired_id)


func test_fallback_inventory_matches_resource_inventory_and_metadata() -> void:
	var shell = _make_shell()
	var resource_objects := _object_map(FOOTPRINT_SET.objects)
	var fallback_objects := _object_map(shell._default_object_footprint_configs())
	assert_eq(_sorted_ids(fallback_objects.values()), _sorted_strings(EXPECTED_IDS))
	for id in EXPECTED_IDS:
		var resource = resource_objects[id]
		var fallback = fallback_objects[id]
		for property_name in [
			"room_area_id", "anchor_cell", "size_cells", "position_offset_px",
			"visual_size_px", "collision_shape_type", "collision_size_px",
			"collision_offset_px", "interaction_size_px", "interaction_offset_px",
			"blocks_movement", "uses_floor_occupancy", "placement_type",
			"parent_object_id", "wall_segment_id", "wall_position_ratio",
			"wall_offset_px", "facing_description_ko", "display_name_ko",
			"expected_image_file", "expected_scene_file", "expected_audio_set_id",
			"debug_color",
		]:
			assert_eq(fallback.get(property_name), resource.get(property_name), "%s.%s fallback must match Resource." % [id, property_name])
		assert_eq(fallback.interaction_cells, resource.interaction_cells, "%s interactions must match." % id)


func test_excel_canonical_interaction_pixel_values_are_preserved() -> void:
	var objects := _object_map(FOOTPRINT_SET.objects)
	_assert_pixels(objects["entrance_door"], Vector2i(0, 8), Vector2(0, -6), Vector2(150, 220), Vector2.ZERO, Vector2.ZERO, Vector2(96, 56), Vector2(50, 0))
	_assert_pixels(objects["bed"], Vector2i(8, 6), Vector2(10, -6), Vector2(260, 180), Vector2(180, 90), Vector2(0, 30), Vector2(120, 64), Vector2(-120, 28))
	_assert_pixels(objects["fridge"], Vector2i(10, 4), Vector2(-8, -12), Vector2(120, 190), Vector2(70, 70), Vector2(0, 38), Vector2(80, 56), Vector2(-50, 42))
	_assert_pixels(objects["microwave"], Vector2i(8, 4), Vector2(0, -60), Vector2(96, 72), Vector2.ZERO, Vector2.ZERO, Vector2(96, 56), Vector2(0, 96))
	_assert_pixels(objects["navi_link"], Vector2i(4, 1), Vector2(12, -16), Vector2(300, 240), Vector2(210, 120), Vector2(0, 45), Vector2(128, 80), Vector2(0, 150))
	_assert_pixels(objects["power_module_board"], Vector2i(8, 1), Vector2(0, -30), Vector2(200, 180), Vector2.ZERO, Vector2.ZERO, Vector2(120, 72), Vector2(-88, 92))
	_assert_pixels(objects["node_17"], Vector2i(1, 2), Vector2(0, -8), Vector2(150, 140), Vector2(90, 60), Vector2(0, 28), Vector2(96, 64), Vector2(84, 30))
	var expected_interactions := {
		"entrance_door": [Vector2i(0, 8)], "bed": [Vector2i(7, 7)],
		"fridge": [Vector2i(10, 5)], "microwave": [Vector2i(8, 5)],
		"navi_link": [Vector2i(4, 3), Vector2i(5, 3)],
		"power_module_board": [Vector2i(7, 2)], "node_17": [Vector2i(2, 2)],
	}
	for id in expected_interactions:
		assert_eq(objects[id].interaction_cells, expected_interactions[id], "%s interaction cells must remain canonical." % id)


func test_excel_canonical_environment_pixel_values_are_preserved() -> void:
	var objects := _object_map(FOOTPRINT_SET.objects)
	_assert_pixels(objects["sink_counter"], Vector2i(8, 4), Vector2.ZERO, Vector2(220, 150), Vector2(160, 70), Vector2(0, 32), Vector2.ZERO, Vector2.ZERO)
	_assert_pixels(objects["dining_table"], Vector2i(4, 6), Vector2.ZERO, Vector2(170, 120), Vector2(130, 70), Vector2(0, 24), Vector2.ZERO, Vector2.ZERO)
	_assert_pixels(objects["signal_booster"], Vector2i(1, 2), Vector2(-68, -58), Vector2(112, 96), Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO)
	_assert_pixels(objects["ups_unit"], Vector2i(8, 2), Vector2.ZERO, Vector2(140, 110), Vector2(100, 60), Vector2(0, 22), Vector2.ZERO, Vector2.ZERO)
	_assert_pixels(objects["bathroom_fixture"], Vector2i(0, 4), Vector2.ZERO, Vector2(200, 140), Vector2(150, 80), Vector2(0, 28), Vector2.ZERO, Vector2.ZERO)
	_assert_pixels(objects["sea_horizon_poster"], Vector2i(10, 7), Vector2(0, -20), Vector2(160, 80), Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO)
	_assert_pixels(objects["fluorescent_light"], Vector2i(6, 6), Vector2.ZERO, Vector2(240, 40), Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO)
	_assert_pixels(objects["shoes_slippers"], Vector2i(1, 9), Vector2.ZERO, Vector2(100, 60), Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO)
	_assert_pixels(objects["cable_bundle"], Vector2i(2, 2), Vector2(36, 42), Vector2(80, 40), Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO)
	_assert_pixels(objects["wall_conduit"], Vector2i(7, 0), Vector2.ZERO, Vector2(128, 64), Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO)
	_assert_pixels(objects["power_housing"], Vector2i(8, 1), Vector2.ZERO, Vector2(240, 210), Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO)


func test_attachment_and_floor_occupancy_policy() -> void:
	var shell = _make_shell()
	var objects := _dictionary_map(shell._object_footprints())
	for id in ["microwave", "signal_booster", "cable_bundle", "power_housing"]:
		assert_eq(objects[id].placement_type, 2)
		assert_false(objects[id].uses_floor_occupancy)
		assert_false(shell._object_blocker_ids_for_cell(objects[id].anchor_cell).has(id), "%s must not add its own floor blocker." % id)
	assert_eq(objects["ups_unit"].placement_type, 2)
	assert_true(objects["ups_unit"].uses_floor_occupancy, "UPS keeps a real floor collision despite parent metadata.")
	assert_true(shell._object_blocked_cells().has(objects["ups_unit"].anchor_cell))
	assert_false(objects["entrance_door"].uses_floor_occupancy)
	assert_false(objects["power_module_board"].uses_floor_occupancy)


func test_parent_and_wall_references_are_valid_and_acyclic() -> void:
	var shell = _make_shell()
	var objects := _dictionary_map(shell._object_footprints())
	assert_eq(objects["microwave"].parent_object_id, "sink_counter")
	assert_eq(objects["signal_booster"].parent_object_id, "node_17")
	assert_eq(objects["ups_unit"].parent_object_id, "power_module_board")
	assert_eq(objects["power_housing"].parent_object_id, "power_module_board")
	assert_eq(objects["entrance_door"].wall_segment_id, "entrance_wall")
	assert_eq(objects["power_module_board"].wall_segment_id, "work_right_wall")
	assert_eq(objects["sea_horizon_poster"].wall_segment_id, "living_right_wall")
	assert_eq(objects["wall_conduit"].wall_segment_id, "work_back_wall")
	for id in objects:
		var parent_id := String(objects[id].parent_object_id)
		if int(objects[id].placement_type) == 2:
			assert_false(parent_id.is_empty(), "%s parent-attached placement requires a parent." % id)
		if parent_id.is_empty():
			continue
		assert_true(objects.has(parent_id), "%s parent must exist in the same inventory." % id)
		assert_ne(parent_id, id, "%s must not parent itself." % id)
	assert_eq(objects["power_housing"].wall_segment_id, objects["power_module_board"].wall_segment_id)
	assert_eq(objects["power_housing"].wall_position_ratio, objects["power_module_board"].wall_position_ratio)
	var entrance_wall: Dictionary = shell._wall_segment_by_id("entrance_wall")
	var entrance_unit: Dictionary = shell._object_wall_attachment_unit(objects["entrance_door"], entrance_wall)
	assert_eq(int(entrance_unit.get("offset", -1)), int(entrance_wall.get("doorway_offset", -2)))
	assert_true(shell._object_wall_attachment_is_doorway(objects["entrance_door"], entrance_wall))
	assert_eq(shell._object_placement_warnings(), [])


func test_candidate_layout_has_no_placement_or_measurement_warnings() -> void:
	var shell = _make_shell()
	assert_eq(shell._object_placement_warnings(), [], "Candidate placement validation should have zero fatal warnings.")
	assert_eq(shell._room_measurement_object_warnings(), [], "Measured room/path validation should have zero fatal warnings.")
	assert_eq(shell._room_area_for_cell(Vector2i(0, 4), false), "bathroom")
	assert_eq(_dictionary_map(shell._object_footprints())["bathroom_fixture"].room_area_id, "bathroom")


func test_expected_asset_fields_are_spec_strings_not_runtime_dependencies() -> void:
	for object in FOOTPRINT_SET.objects:
		assert_false(object.expected_image_file.is_empty(), "%s should retain its future image filename." % object.id)
		assert_false(object.expected_scene_file.is_empty(), "%s should retain its future scene/resource spec." % object.id)
		assert_false(object.expected_scene_file.begins_with("res://"), "%s expected path must stay a non-loadable logical spec." % object.id)
	var source := FileAccess.get_file_as_string("res://scripts/quarterview/QuarterviewApartmentShellCandidate.gd")
	assert_eq(source.find("load(object_data.get(\"expected_"), -1)
	assert_eq(source.find("preload(object_data.get(\"expected_"), -1)


func test_all_map_rotations_instantiate_with_the_same_inventory() -> void:
	var centers_by_rotation := []
	for rotation in [0, 1, 2, 3]:
		var shell = SHELL_SCENE.instantiate()
		shell.map_rotation = rotation
		add_child_autoqfree(shell)
		assert_eq(shell._object_footprints().size(), 18, "ROTATE_%d should instantiate all objects." % [rotation * 90])
		var objects := _dictionary_map(shell._object_footprints())
		var bed_floor: Array[Vector2] = shell._object_floor_polygon_points(objects["bed"])
		var bed_anchor: Vector2i = objects["bed"].anchor_cell
		var bed_size: Vector2i = objects["bed"].size_cells
		var expected_floor := [
			shell._iso(bed_anchor.x, bed_anchor.y),
			shell._iso(bed_anchor.x + bed_size.x, bed_anchor.y),
			shell._iso(bed_anchor.x + bed_size.x, bed_anchor.y + bed_size.y),
			shell._iso(bed_anchor.x, bed_anchor.y + bed_size.y),
		]
		assert_eq(bed_floor, expected_floor, "ROTATE_%d floor footprint must use the rotated grid corners." % [rotation * 90])
		_assert_collision_polygon_contract(shell, objects["bed"], rotation * 90)
		for id in ["bed", "entrance_door", "microwave"]:
			var expected_center: Vector2 = shell._cell_center(objects[id].anchor_cell) + Vector2(objects[id].position_offset_px) + Vector2(objects[id].wall_offset_px)
			assert_eq(shell._object_pixel_center(objects[id]), expected_center, "ROTATE_%d %s pixel offsets should remain attached to the rotated anchor." % [rotation * 90, id])
		var entrance_wall: Dictionary = shell._wall_segment_by_id("entrance_wall")
		assert_true(shell._object_wall_attachment_is_doorway(objects["entrance_door"], entrance_wall), "ROTATE_%d entrance door must stay on its doorway unit." % [rotation * 90])
		assert_eq(shell._object_placement_warnings(), [], "ROTATE_%d should preserve placement invariants." % [rotation * 90])
		centers_by_rotation.append(shell._object_pixel_center(objects["bed"]))
	for first in range(centers_by_rotation.size()):
		for second in range(first + 1, centers_by_rotation.size()):
			assert_ne(centers_by_rotation[first], centers_by_rotation[second], "Each map rotation should project Bed to a distinct screen center.")


func test_shell_debug_key_smoke() -> void:
	var shell = _make_shell()
	for keycode in [KEY_G, KEY_W, KEY_E, KEY_O, KEY_I, KEY_L, KEY_J, KEY_H]:
		shell._unhandled_input(_key_event(keycode))
	assert_true(shell.show_floor_grid_coords)
	assert_true(shell.show_wall_ids)
	assert_true(shell.show_wall_edge_coords)
	assert_true(shell.show_occlusion_wall_debug)
	assert_true(shell.show_debug_labels)
	assert_false(shell.show_navigation_debug)
	assert_false(shell.show_object_placeholders)
	assert_false(shell.show_room_measurements)
	assert_true(shell._phone_overlay_root.visible, "H should open the shell-only Phone overlay after J smoke coverage.")
	shell._unhandled_input(_key_event(KEY_M))
	assert_true(shell.show_room_measurements)
	shell._unhandled_input(_key_event(KEY_P))
	assert_true(shell.show_object_placeholders)
	assert_false(shell.show_room_measurements)
	shell._unhandled_input(_key_event(KEY_N))
	assert_true(shell.show_navigation_debug)
	assert_false(shell.show_object_placeholders)


func test_primary_debug_modes_are_exclusive_and_same_key_returns_to_none() -> void:
	var shell = _make_shell()
	_assert_primary_mode(shell, 0, false, false, false)
	shell._unhandled_input(_key_event(KEY_M))
	_assert_primary_mode(shell, 1, true, false, false)
	shell._unhandled_input(_key_event(KEY_M))
	_assert_primary_mode(shell, 0, false, false, false)
	shell._unhandled_input(_key_event(KEY_P))
	_assert_primary_mode(shell, 2, false, true, false)
	shell._unhandled_input(_key_event(KEY_N))
	_assert_primary_mode(shell, 3, false, false, true)
	assert_eq(shell.get_node("RoomMeasurementDebugLayer").visible, false)
	assert_eq(shell.get_node("ObjectPlacementDebugLayer").visible, false)
	assert_eq(shell.get_node("NavigationDebugLayer").visible, true)


func test_shift_primary_debug_key_allows_explicit_combined_view() -> void:
	var shell = _make_shell()
	shell._unhandled_input(_key_event(KEY_M))
	shell._unhandled_input(_key_event(KEY_P, true))
	assert_true(shell.show_room_measurements)
	assert_true(shell.show_object_placeholders)
	assert_false(shell.show_navigation_debug)
	shell._unhandled_input(_key_event(KEY_N))
	_assert_primary_mode(shell, 3, false, false, true)


func test_navigation_mode_hides_all_object_placement_details() -> void:
	var shell = _make_shell()
	shell._unhandled_input(_key_event(KEY_N))
	assert_false(shell.get_node("ObjectPlacementDebugLayer").visible)
	assert_false(shell.get_node("DebugSelectionLayer").visible)
	assert_false(shell._debug_detail_label.text.contains("anchor:"))
	assert_true(shell._debug_detail_label.text.contains("이동·충돌"))


func test_measurement_mode_has_room_summary_without_object_details() -> void:
	var shell = _make_shell()
	shell._unhandled_input(_key_event(KEY_M))
	assert_true(shell.get_node("RoomMeasurementDebugLayer").visible)
	assert_false(shell.get_node("ObjectPlacementDebugLayer").visible)
	assert_false(shell.get_node("DebugLabelLayer").visible, "M should use its single per-room labels instead of the legacy broad label set.")
	assert_true(shell._debug_detail_label.text.contains("방 측량 요약"))
	assert_false(shell._debug_detail_label.text.contains("bed"))


func test_object_mode_draws_four_point_floor_and_collision_polygons() -> void:
	var shell = _make_shell()
	shell._unhandled_input(_key_event(KEY_P))
	var layer: Node = shell.get_node("ObjectPlacementDebugLayer")
	var floor_polygon: Polygon2D = layer.get_node("object_bed_floor_footprint")
	var collision_polygon: Polygon2D = layer.get_node("object_bed_collision_shape")
	assert_eq(floor_polygon.polygon.size(), 4)
	assert_eq(collision_polygon.polygon.size(), 4)
	var objects := _dictionary_map(shell._object_footprints())
	for id in ["entrance_door", "microwave", "power_module_board", "signal_booster", "sea_horizon_poster", "fluorescent_light", "cable_bundle", "wall_conduit", "power_housing"]:
		assert_null(layer.get_node_or_null("object_%s_collision_shape" % id), "%s must not gain fake floor collision geometry." % id)
		assert_eq(shell._object_collision_polygon_points(objects[id]), [], "%s must not project a floor collision polygon." % id)
	assert_eq(shell._object_collision_polygon_points(objects["ups_unit"]).size(), 4, "UPS keeps its floor collision despite parent metadata.")


func test_visual_bounds_are_selected_only_and_hover_click_updates_detail() -> void:
	var shell = _make_shell()
	shell._unhandled_input(_key_event(KEY_P))
	shell.show_object_visual_bounds = true
	var bed: Dictionary = _dictionary_map(shell._object_footprints())["bed"]
	var bed_viewport_position: Vector2 = shell.get_viewport().get_canvas_transform() * shell._object_pixel_center(bed)
	shell._unhandled_input(_mouse_motion_event(bed_viewport_position))
	assert_eq(shell._hovered_object_id, "bed")
	assert_not_null(shell.get_node("DebugSelectionLayer").get_node_or_null("object_bed_short_name"))
	shell._unhandled_input(_mouse_click_event(bed_viewport_position))
	assert_eq(shell._selected_object_id, "bed")
	assert_true(shell._debug_detail_label.text.contains("id: bed"))
	assert_true(_has_child_prefix(shell.get_node("DebugSelectionLayer"), "object_bed_visual_bounds"))
	shell._update_object_hover_at(Vector2(-10000, -10000))
	assert_eq(shell._hovered_object_id, "")
	assert_eq(shell._selected_object_id, "bed", "Moving hover away must preserve click selection.")


func test_inspector_mode_initialization_preserves_legacy_exports_and_combined_policy() -> void:
	var exclusive_shell = SHELL_SCENE.instantiate()
	exclusive_shell.active_debug_mode = 1
	exclusive_shell.show_navigation_debug = true
	add_child_autoqfree(exclusive_shell)
	_assert_primary_mode(exclusive_shell, 1, true, false, false)

	var combined_shell = SHELL_SCENE.instantiate()
	combined_shell.allow_combined_debug_overlays = true
	combined_shell.show_room_measurements = true
	combined_shell.show_object_placeholders = true
	add_child_autoqfree(combined_shell)
	assert_true(combined_shell.show_room_measurements)
	assert_true(combined_shell.show_object_placeholders)
	combined_shell._unhandled_input(_key_event(KEY_N))
	assert_true(combined_shell.show_room_measurements)
	assert_true(combined_shell.show_object_placeholders)
	assert_true(combined_shell.show_navigation_debug)


func test_navigation_mode_keeps_movement_and_collision_calculation_unchanged() -> void:
	var shell = _make_shell()
	var blocked_before: Array[Vector2i] = shell._object_blocked_cells()
	var walkable_before: Array[Vector2i] = shell._walkable_floor_cells()
	var edges_before: Dictionary = shell._navigation_edge_sets()
	shell._unhandled_input(_key_event(KEY_N))
	assert_eq(shell._object_blocked_cells(), blocked_before)
	assert_eq(shell._walkable_floor_cells(), walkable_before)
	assert_eq(shell._navigation_edge_sets()["blocked"].keys().size(), edges_before["blocked"].keys().size())
	assert_eq(shell._navigation_edge_sets()["passable"].keys().size(), edges_before["passable"].keys().size())


func test_f1_help_and_j_h_escape_priority_do_not_overlap() -> void:
	var shell = _make_shell()
	shell._unhandled_input(_key_event(KEY_F1))
	assert_true(shell._debug_help_panel.visible)
	shell._unhandled_input(_key_event(KEY_ESCAPE))
	assert_false(shell._debug_help_panel.visible)
	shell._unhandled_input(_key_event(KEY_F1))
	shell._unhandled_input(_key_event(KEY_J))
	assert_false(shell._debug_help_panel.visible)
	assert_true(shell._interaction_menu_panel.visible)
	shell._unhandled_input(_key_event(KEY_H))
	assert_false(shell._interaction_menu_panel.visible)
	assert_true(shell._phone_overlay_root.visible)
	shell._unhandled_input(_key_event(KEY_ESCAPE))
	assert_false(shell._phone_overlay_root.visible)
	assert_false(shell._debug_help_panel.visible)


func _make_shell():
	var shell = SHELL_SCENE.instantiate()
	add_child_autoqfree(shell)
	return shell


func _object_map(objects: Array) -> Dictionary:
	var result := {}
	for object in objects:
		result[String(object.id)] = object
	return result


func _dictionary_map(objects: Array[Dictionary]) -> Dictionary:
	var result := {}
	for object in objects:
		result[String(object.id)] = object
	return result


func _sorted_ids(objects: Array) -> Array:
	var ids := []
	for object in objects:
		ids.append(String(object.id))
	ids.sort()
	return ids


func _sorted_strings(values: Array) -> Array:
	var result := values.duplicate()
	result.sort()
	return result


func _assert_pixels(object, anchor: Vector2i, offset: Vector2, visual: Vector2, collision: Vector2, collision_offset: Vector2, interaction: Vector2, interaction_offset: Vector2) -> void:
	assert_eq(object.anchor_cell, anchor)
	assert_eq(object.position_offset_px, offset)
	assert_eq(object.visual_size_px, visual)
	assert_eq(object.collision_size_px, collision)
	assert_eq(object.collision_offset_px, collision_offset)
	assert_eq(object.interaction_size_px, interaction)
	assert_eq(object.interaction_offset_px, interaction_offset)


func _assert_primary_mode(shell, mode: int, measurement: bool, objects: bool, navigation: bool) -> void:
	assert_eq(shell.active_debug_mode, mode)
	assert_eq(shell.show_room_measurements, measurement)
	assert_eq(shell.show_object_placeholders, objects)
	assert_eq(shell.show_navigation_debug, navigation)


func _has_child_prefix(parent: Node, prefix: String) -> bool:
	for child in parent.get_children():
		if String(child.name).begins_with(prefix):
			return true
	return false


func _assert_collision_polygon_contract(shell, object_data: Dictionary, rotation_degrees: int) -> void:
	var points: Array[Vector2] = shell._object_collision_polygon_points(object_data)
	assert_eq(points.size(), 4)
	var center := Vector2.ZERO
	for point in points:
		center += point
	center /= float(points.size())
	var expected_center: Vector2 = shell._object_pixel_center(object_data) + Vector2(object_data.collision_offset_px)
	assert_lt(center.distance_to(expected_center), 0.001, "ROTATE_%d collision offset must remain a screen-pixel vector." % rotation_degrees)
	assert_lt(absf(points[0].distance_to(points[1]) - float(object_data.collision_size_px.x)), 0.001, "ROTATE_%d collision width must remain in screen pixels." % rotation_degrees)
	assert_lt(absf(points[1].distance_to(points[2]) - float(object_data.collision_size_px.y)), 0.001, "ROTATE_%d collision depth must remain in screen pixels." % rotation_degrees)
	var anchor: Vector2i = object_data.anchor_cell
	var expected_axis_a: Vector2 = (shell._iso(anchor.x + 1, anchor.y) - shell._iso(anchor.x, anchor.y)).normalized()
	var expected_axis_b: Vector2 = (shell._iso(anchor.x, anchor.y + 1) - shell._iso(anchor.x, anchor.y)).normalized()
	assert_gt((points[1] - points[0]).normalized().dot(expected_axis_a), 0.999, "ROTATE_%d collision width must follow the rotated floor axis." % rotation_degrees)
	assert_gt((points[2] - points[1]).normalized().dot(expected_axis_b), 0.999, "ROTATE_%d collision depth must follow the rotated floor axis." % rotation_degrees)


func _key_event(keycode: Key, shift := false) -> InputEventKey:
	var event := InputEventKey.new()
	event.keycode = keycode
	event.pressed = true
	event.shift_pressed = shift
	return event


func _mouse_motion_event(position: Vector2) -> InputEventMouseMotion:
	var event := InputEventMouseMotion.new()
	event.position = position
	return event


func _mouse_click_event(position: Vector2) -> InputEventMouseButton:
	var event := InputEventMouseButton.new()
	event.position = position
	event.button_index = MOUSE_BUTTON_LEFT
	event.pressed = true
	return event
