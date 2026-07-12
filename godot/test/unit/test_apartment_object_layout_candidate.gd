extends GutTest

const SHELL_SCENE := preload("res://scenes/quarterview/QuarterviewApartmentShellCandidate.tscn")
const FOOTPRINT_SET := preload("res://resources/quarterview/apartment_shell_object_footprints.tres")
const FOOTPRINT_CONFIG_SCRIPT := preload("res://scripts/quarterview/ApartmentObjectFootprintConfig.gd")

const EXPECTED_IDS := [
	"entrance_door", "bed", "fridge", "microwave", "navi_link",
	"power_module_board", "node_17", "sink_counter", "dining_table",
	"signal_booster", "ups_unit", "bathroom_fixture", "sea_horizon_poster",
	"fluorescent_light", "shoes_slippers", "cable_bundle", "wall_conduit",
	"power_housing",
]
const DIRECT_INTERACTION_IDS := [
	"entrance_door", "bed", "fridge", "microwave", "navi_link",
	"power_module_board", "node_17",
]
const NON_INTERACTION_IDS := [
	"sink_counter", "dining_table", "signal_booster", "ups_unit",
	"bathroom_fixture", "sea_horizon_poster", "fluorescent_light",
	"shoes_slippers", "cable_bundle", "wall_conduit", "power_housing",
]
const EDITABLE_NODE_IDS := DIRECT_INTERACTION_IDS
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
			"room_area_id", "category", "anchor_type", "anchor_cell", "size_cells", "position_offset_px",
			"visual_size_px", "collision_shape_type", "collision_size_px",
			"collision_offset_px", "interaction_size_px", "interaction_offset_px",
			"blocks_movement", "uses_floor_occupancy",
			"parent_object_id", "wall_segment_id", "wall_position_ratio",
			"wall_offset_px", "facing_description_ko", "display_name_ko",
			"expected_image_file", "expected_scene_file", "expected_audio_set_id",
			"debug_color",
		]:
			assert_eq(fallback.get(property_name), resource.get(property_name), "%s.%s fallback must match Resource." % [id, property_name])
		assert_eq(fallback.interaction_cells, resource.interaction_cells, "%s interactions must match." % id)


func test_migrated_resources_keep_logic_without_duplicate_scene_geometry() -> void:
	var objects := _object_map(FOOTPRINT_SET.objects)
	for id in EDITABLE_NODE_IDS:
		_assert_pixels(objects[id], Vector2i.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO)
		assert_eq(objects[id].size_cells, Vector2i.ZERO, "%s Resource must not duplicate Scene occupancy size." % id)
		assert_eq(objects[id].collision_shape_type, FOOTPRINT_CONFIG_SCRIPT.CollisionShapeType.NONE)
		assert_eq(objects[id].interaction_cells, [], "%s Resource must not duplicate Scene use points." % id)
		assert_eq(objects[id].interaction_cell, Vector2i(-1, -1))


func test_editable_object_scene_nodes_are_the_rotated_view_geometry_authority() -> void:
	var shell = _make_shell()
	var expected_paths := {
		"entrance_door": "EditableObjectNodes/EntranceWallParentAnchor/EntranceDoor",
		"bed": "EditableObjectNodes/Bed",
		"fridge": "EditableObjectNodes/Fridge",
		"navi_link": "EditableObjectNodes/NaviLink",
		"microwave": "EditableObjectNodes/SinkCounterParentAnchor/Microwave",
		"power_module_board": "EditableObjectNodes/WorkBackWallParentAnchor/PowerModuleBoard",
		"node_17": "EditableObjectNodes/Node17",
	}
	for id in expected_paths:
		var object_node: Node = shell.get_node(expected_paths[id])
		assert_eq(String(object_node.object_id), id)
		assert_true(object_node.is_in_group("apartment_editable_object"))
		assert_true(object_node.get_node("Visual") is Node2D)
		assert_true(object_node.get_node("Visual/Sprite2D") is Sprite2D)
		assert_true(object_node.get_node("Visual/VisualPreview") is Polygon2D)
		assert_true(object_node.get_node("BasePoint") is Marker2D)
		assert_true(object_node.get_node("TopPoint") is Marker2D)
		assert_not_null(object_node.get_node_or_null("Body"))
		assert_true(object_node.get_node("SelectionArea") is Area2D)
		assert_true(object_node.get_node("SelectionArea/SelectionPolygon") is CollisionPolygon2D)
		assert_not_null(object_node.get_node_or_null("InteractionArea"))
		assert_true(object_node.get_node("InteractionArea/InteractionPolygon") is CollisionPolygon2D)
		assert_not_null(object_node.get_node_or_null("UsePoint"))
		assert_not_null(object_node.get_node_or_null("AttachmentSocket"))
		assert_null(object_node.get_node_or_null("PlacementFootprint"), "Current seven interaction objects must not duplicate Body occupancy.")
		assert_eq(object_node.geometry_warnings(), [])
		assert_eq(object_node.get_node("Body").collision_layer, 0)
		assert_eq(object_node.get_node("Body").collision_mask, 0)
		assert_eq(object_node.get_node("SelectionArea").collision_layer, 0)
		assert_eq(object_node.get_node("SelectionArea").collision_mask, 0)
		assert_false(object_node.get_node("SelectionArea").monitoring)
		assert_false(object_node.get_node("SelectionArea").monitorable)
		assert_eq(object_node.get_node("InteractionArea").collision_layer, 0)
		assert_eq(object_node.get_node("InteractionArea").collision_mask, 0)

	for id in ["entrance_door", "bed", "fridge", "navi_link", "node_17"]:
		var body_polygon: CollisionPolygon2D = shell.get_node(expected_paths[id]).get_node("Body/BodyPolygon")
		assert_eq(body_polygon.scale, Vector2.ONE)
		assert_gt(body_polygon.polygon.size(), 3)
		assert_true(body_polygon.editor_description.contains("꼭짓점"))
	for id in ["microwave", "power_module_board"]:
		assert_null(shell.get_node(expected_paths[id]).get_node_or_null("Body/BodyPolygon"))
	for id in expected_paths:
		var object_node: Node = shell.get_node(expected_paths[id])
		assert_eq(object_node.get_node("SelectionArea/SelectionPolygon").scale, Vector2.ONE)
		assert_gt(object_node.get_node("SelectionArea/SelectionPolygon").polygon.size(), 3)
		assert_true(object_node.get_node("SelectionArea/SelectionPolygon").editor_description.contains("hover/click"))
		assert_eq(object_node.get_node("InteractionArea/InteractionPolygon").scale, Vector2.ONE)
		assert_true(object_node.get_node("InteractionArea/InteractionPolygon").editor_description.contains("UsePoint와 독립"))
		assert_true(object_node.get_node("UsePoint").editor_description.contains("캐릭터가 이동"))
		assert_true(object_node.get_node("AttachmentSocket").editor_description.contains("부착 기준점"))
		assert_true(object_node.get_node("BasePoint").editor_description.contains("설치되는 기준점"))
		assert_true(object_node.get_node("TopPoint").editor_description.contains("높이"))
		assert_true(object_node.get_node("Visual/VisualPreview").editor_description.contains("실제 이미지가 없을 때"))
		assert_ne(object_node.get_node("BasePoint").position, object_node.get_node("TopPoint").position)

	var objects := _dictionary_map(shell._object_footprints())
	var expected_centers := {
		"entrance_door": Vector2(516, 184), "bed": Vector2(1262, 424),
		"fridge": Vector2(1124, 230), "navi_link": Vector2(1264, 94),
		"microwave": Vector2(996, 114), "power_module_board": Vector2(1476, 96),
		"node_17": Vector2(996, 38),
	}
	var expected_base_points := {
		"entrance_door": Vector2(516, 190), "bed": Vector2(1262, 514),
		"fridge": Vector2(1124, 303), "navi_link": Vector2(1264, 214),
		"microwave": Vector2(996, 174), "power_module_board": Vector2(1476, 126),
		"node_17": Vector2(996, 108),
	}
	var expected_use_cells := {
		"entrance_door": [Vector2i(0, 8)], "bed": [Vector2i(8, 7)],
		"fridge": [Vector2i(5, 5)], "navi_link": [Vector2i(5, 3)],
		"microwave": [Vector2i(4, 5)], "power_module_board": [Vector2i(7, 2)],
		"node_17": [Vector2i(2, 2)],
	}
	for id in EDITABLE_NODE_IDS:
		assert_true(objects[id].node_backed)
		assert_eq(objects[id].source, "scene_node")
		assert_eq(objects[id].visual_source, "SPRITE2D" if id == "fridge" else "VISUAL_PREVIEW")
		assert_eq(shell._object_pixel_center(objects[id]), expected_centers[id])
		assert_eq(objects[id].base_point_world, expected_base_points[id])
		assert_ne(objects[id].top_point_world, objects[id].base_point_world)
		assert_gt(float(objects[id].height_px), 0.0)
		assert_eq(objects[id].selection_source, "SELECTION_POLYGON")
		assert_eq(shell._object_selection_polygons(objects[id]).size(), 1)
		assert_eq(shell._object_interaction_cells(objects[id]), expected_use_cells[id])
		assert_eq(shell._object_interaction_polygons(objects[id]).size(), 1)
	assert_eq(shell._object_collision_polygon_points(objects["fridge"]).size(), 4)
	assert_eq(shell._object_collision_polygon_points(objects["navi_link"]).size(), 5, "Preserve the user-authored NAVI fifth vertex.")
	for id in ["bed", "fridge", "navi_link", "node_17"]:
		assert_eq(shell._object_floor_polygon_points(objects[id]), shell._object_collision_polygon_points(objects[id]))
		assert_eq(objects[id].floor_occupancy_source, "BODY_POLYGON")
	assert_eq(shell._object_collision_polygon_points(objects["entrance_door"]).size(), 4)
	assert_eq(shell._object_floor_polygon_points(objects["entrance_door"]), [])
	assert_eq(objects["entrance_door"].floor_occupancy_source, "NONE")
	assert_eq(shell._object_collision_polygon_points(objects["microwave"]), [])
	assert_eq(shell._object_collision_polygon_points(objects["power_module_board"]), [])
	assert_eq(objects["microwave"].floor_occupancy_source, "NONE")
	assert_eq(objects["power_module_board"].floor_occupancy_source, "NONE")
	for id in EXPECTED_IDS:
		if EDITABLE_NODE_IDS.has(id):
			continue
		assert_false(bool(objects[id].get("node_backed", false)), "%s must keep the Resource fallback path." % id)
		assert_eq(objects[id].source, "resource")


func test_editable_geometry_channels_are_independent_and_parent_anchors_propagate() -> void:
	var shell = _make_shell()
	var fridge: Node2D = shell.get_node("EditableObjectNodes/Fridge")
	var fridge_use_point: Node2D = fridge.get_node("UsePoint")
	var before := _dictionary_map(shell._object_footprints())
	var before_interaction_point: Vector2 = shell._object_interaction_polygons(before["fridge"])[0][0]
	var before_use_cell: Vector2i = shell._object_interaction_cells(before["fridge"])[0]
	var before_selection_point: Vector2 = shell._object_selection_polygons(before["fridge"])[0][0]
	var before_base_point: Vector2 = before["fridge"].base_point_world
	var before_top_point: Vector2 = before["fridge"].top_point_world
	fridge_use_point.position += Vector2(64, 32)
	var after_use_move := _dictionary_map(shell._object_footprints())
	assert_eq(shell._object_interaction_polygons(after_use_move["fridge"])[0][0], before_interaction_point, "UsePoint must not move InteractionPolygon.")
	assert_ne(shell._object_interaction_cells(after_use_move["fridge"])[0], before_use_cell)
	assert_eq(shell._object_selection_polygons(after_use_move["fridge"])[0][0], before_selection_point)
	assert_eq(after_use_move["fridge"].base_point_world, before_base_point)

	var selection_area: Node2D = fridge.get_node("SelectionArea")
	selection_area.position += Vector2(24, -12)
	var after_selection_move := _dictionary_map(shell._object_footprints())
	assert_eq(shell._object_selection_polygons(after_selection_move["fridge"])[0][0], before_selection_point + Vector2(24, -12))
	assert_eq(shell._object_interaction_polygons(after_selection_move["fridge"])[0][0], before_interaction_point)
	assert_eq(shell._object_interaction_cells(after_selection_move["fridge"])[0], shell._object_interaction_cells(after_use_move["fridge"])[0])

	var base_point: Marker2D = fridge.get_node("BasePoint")
	base_point.position += Vector2(12, 6)
	var after_base_move := _dictionary_map(shell._object_footprints())
	assert_eq(after_base_move["fridge"].base_point_world, before_base_point + Vector2(12, 6))
	assert_eq(after_base_move["fridge"].top_point_world, before_top_point)
	assert_eq(shell._object_selection_polygons(after_base_move["fridge"])[0][0], before_selection_point + Vector2(24, -12))

	var interaction_area: Node2D = fridge.get_node("InteractionArea")
	var use_cell_before_area_move: Vector2i = shell._object_interaction_cells(after_use_move["fridge"])[0]
	interaction_area.position += Vector2(16, 8)
	var after_area_move := _dictionary_map(shell._object_footprints())
	assert_eq(shell._object_interaction_polygons(after_area_move["fridge"])[0][0], before_interaction_point + Vector2(16, 8))
	assert_eq(shell._object_interaction_cells(after_area_move["fridge"])[0], use_cell_before_area_move, "InteractionArea must not move UsePoint access cell.")
	assert_eq(shell._object_selection_polygons(after_area_move["fridge"])[0][0], before_selection_point + Vector2(24, -12))

	var body_shape: CollisionPolygon2D = fridge.get_node("Body/BodyPolygon")
	var collision_before: Array[Vector2] = shell._object_collision_polygon_points(after_use_move["fridge"])
	var blocked_before: Array[Vector2i] = shell._object_blocked_cells()
	body_shape.position += Vector2(64, 32)
	var after_body_move := _dictionary_map(shell._object_footprints())
	assert_eq(shell._object_collision_polygon_points(after_body_move["fridge"])[0], collision_before[0] + Vector2(64, 32))
	assert_ne(shell._object_blocked_cells(), blocked_before)

	for anchor_path_and_id in [
		["EditableObjectNodes/SinkCounterParentAnchor", "microwave"],
		["EditableObjectNodes/WorkBackWallParentAnchor", "power_module_board"],
	]:
		var parent_anchor: Node2D = shell.get_node(anchor_path_and_id[0])
		var object_before: Dictionary = _dictionary_map(shell._object_footprints())[anchor_path_and_id[1]]
		var center_before: Vector2 = shell._object_pixel_center(object_before)
		var interaction_before: Vector2 = shell._object_interaction_polygons(object_before)[0][0]
		var selection_before: Vector2 = shell._object_selection_polygons(object_before)[0][0]
		var base_before: Vector2 = object_before.base_point_world
		parent_anchor.position += Vector2(16, 8)
		var object_after: Dictionary = _dictionary_map(shell._object_footprints())[anchor_path_and_id[1]]
		assert_eq(shell._object_pixel_center(object_after), center_before + Vector2(16, 8))
		assert_eq(shell._object_interaction_polygons(object_after)[0][0], interaction_before + Vector2(16, 8))
		assert_eq(shell._object_selection_polygons(object_after)[0][0], selection_before + Vector2(16, 8))
		assert_eq(object_after.base_point_world, base_before + Vector2(16, 8))

	var board_socket: Node2D = shell.get_node("EditableObjectNodes/WorkBackWallParentAnchor/PowerModuleBoard/AttachmentSocket")
	var housing_before: Vector2 = shell._object_pixel_center(_dictionary_map(shell._object_footprints())["power_housing"])
	board_socket.position += Vector2(8, 4)
	var housing_after: Vector2 = shell._object_pixel_center(_dictionary_map(shell._object_footprints())["power_housing"])
	assert_eq(housing_after, housing_before + Vector2(8, 4), "Resource child attachments must follow AttachmentSocket.")


func test_new_interaction_nodes_keep_selection_interaction_and_use_independent() -> void:
	var shell = _make_shell()
	for path_and_id in [
		["EditableObjectNodes/Bed", "bed"],
		["EditableObjectNodes/Node17", "node_17"],
		["EditableObjectNodes/EntranceWallParentAnchor/EntranceDoor", "entrance_door"],
	]:
		var object_node: Node2D = shell.get_node(path_and_id[0])
		var object_id := String(path_and_id[1])
		var before: Dictionary = _dictionary_map(shell._object_footprints())[object_id]
		var selection_before: Vector2 = shell._object_selection_polygons(before)[0][0]
		var interaction_before: Vector2 = shell._object_interaction_polygons(before)[0][0]
		var use_before: Vector2 = Vector2(before.use_points_world[0])
		object_node.get_node("SelectionArea").position += Vector2(18, -9)
		var after_selection: Dictionary = _dictionary_map(shell._object_footprints())[object_id]
		assert_eq(shell._object_selection_polygons(after_selection)[0][0], selection_before + Vector2(18, -9))
		assert_eq(shell._object_interaction_polygons(after_selection)[0][0], interaction_before)
		assert_eq(Vector2(after_selection.use_points_world[0]), use_before)
		object_node.get_node("InteractionArea").position += Vector2(-12, 6)
		var after_interaction: Dictionary = _dictionary_map(shell._object_footprints())[object_id]
		assert_eq(shell._object_selection_polygons(after_interaction)[0][0], selection_before + Vector2(18, -9))
		assert_eq(shell._object_interaction_polygons(after_interaction)[0][0], interaction_before + Vector2(-12, 6))
		assert_eq(Vector2(after_interaction.use_points_world[0]), use_before)
		object_node.get_node("UsePoint").position += Vector2(10, 5)
		var after_use: Dictionary = _dictionary_map(shell._object_footprints())[object_id]
		assert_eq(shell._object_interaction_polygons(after_use)[0][0], interaction_before + Vector2(-12, 6))
		assert_eq(Vector2(after_use.use_points_world[0]), use_before + Vector2(10, 5))


func test_node_17_attachment_socket_keeps_resource_children_attached() -> void:
	var shell = _make_shell()
	var objects_before := _dictionary_map(shell._object_footprints())
	assert_eq(objects_before["signal_booster"].parent_object_id, "node_17")
	assert_eq(objects_before["cable_bundle"].parent_object_id, "node_17")
	var booster_before: Vector2 = shell._object_pixel_center(objects_before["signal_booster"])
	var cable_before: Vector2 = shell._object_pixel_center(objects_before["cable_bundle"])
	var node_center_before: Vector2 = shell._object_pixel_center(objects_before["node_17"])
	var socket: Marker2D = shell.get_node("EditableObjectNodes/Node17/AttachmentSocket")
	socket.position += Vector2(14, 7)
	var objects_after := _dictionary_map(shell._object_footprints())
	assert_eq(shell._object_pixel_center(objects_after["signal_booster"]), booster_before + Vector2(14, 7))
	assert_eq(shell._object_pixel_center(objects_after["cable_bundle"]), cable_before + Vector2(14, 7))
	assert_eq(shell._object_pixel_center(objects_after["node_17"]), node_center_before, "Socket edits must not move NODE-17 itself.")


func test_entrance_door_open_state_switches_wall_collision_without_floor_occupancy() -> void:
	var shell = _make_shell()
	shell._unhandled_input(_key_event(KEY_P))
	var door_node: Node2D = shell.get_node("EditableObjectNodes/EntranceWallParentAnchor/EntranceDoor")
	var body_polygon: CollisionPolygon2D = door_node.get_node("Body/BodyPolygon")
	var entrance_wall: Dictionary = shell._wall_segment_by_id("entrance_wall")
	var closed_door: Dictionary = _dictionary_map(shell._object_footprints())["entrance_door"]
	var doorway_edge: Dictionary = shell._object_wall_attachment_unit(closed_door, entrance_wall).edge
	var edge_key: String = shell._edge_key(doorway_edge.from_cell, doorway_edge.to_cell)
	var doorway_from_world: Vector2 = shell._iso(float(doorway_edge.from_cell.x), float(doorway_edge.from_cell.y))
	var doorway_to_world: Vector2 = shell._iso(float(doorway_edge.to_cell.x), float(doorway_edge.to_cell.y))
	var closed_collision := PackedVector2Array(shell._object_collision_polygon_points(closed_door))
	assert_false(door_node.is_open)
	assert_false(body_polygon.disabled)
	assert_eq(closed_collision.size(), 4)
	assert_true(Geometry2D.is_point_in_polygon(doorway_from_world, closed_collision), "Closed door BodyPolygon must cover doorway start %s; polygon=%s." % [doorway_from_world, closed_collision])
	assert_true(Geometry2D.is_point_in_polygon(doorway_to_world, closed_collision), "Closed door BodyPolygon must cover doorway end %s; polygon=%s." % [doorway_to_world, closed_collision])
	assert_eq(shell._object_floor_polygon_points(closed_door), [])
	assert_true(shell._navigation_edge_sets().blocked.has(edge_key))
	assert_false(shell._navigation_edge_sets().passable.has(edge_key))
	assert_not_null(shell.get_node("ObjectPlacementDebugLayer").get_node_or_null("object_entrance_door_collision_shape"))
	shell._select_object_for_debug("entrance_door")
	assert_true(shell._debug_detail_label.text.contains("open state: CLOSED / BodyPolygon: ACTIVE"))

	shell.set_entrance_door_open(true)
	var open_door: Dictionary = _dictionary_map(shell._object_footprints())["entrance_door"]
	assert_true(door_node.is_open)
	assert_true(body_polygon.disabled)
	assert_eq(shell._object_collision_polygon_points(open_door), [])
	assert_eq(shell._object_floor_polygon_points(open_door), [])
	assert_false(shell._navigation_edge_sets().blocked.has(edge_key))
	assert_true(shell._navigation_edge_sets().passable.has(edge_key))
	assert_null(shell.get_node("ObjectPlacementDebugLayer").get_node_or_null("object_entrance_door_collision_shape"))
	assert_eq(door_node.geometry_warnings(), [])
	assert_true(shell._debug_detail_label.text.contains("open state: OPEN / BodyPolygon: DISABLED"))

	shell.set_entrance_door_open(false)
	assert_false(body_polygon.disabled)
	assert_true(shell._navigation_edge_sets().blocked.has(edge_key))


func test_visual_preview_is_independent_from_collision_geometry() -> void:
	var shell = _make_shell()
	var bed: Node2D = shell.get_node("EditableObjectNodes/Bed")
	var preview: Polygon2D = bed.get_node("Visual/VisualPreview")
	var before: Dictionary = _dictionary_map(shell._object_footprints())["bed"]
	var collision_before: Array[Vector2] = shell._object_collision_polygon_points(before)
	preview.position += Vector2(24, -12)
	var preview_move: Dictionary = _dictionary_map(shell._object_footprints())["bed"]
	assert_eq(shell._object_pixel_center(preview_move), shell._object_pixel_center(before) + Vector2(24, -12))
	assert_eq(shell._object_collision_polygon_points(preview_move), collision_before, "VisualPreview must never drive collision.")


func test_optional_placement_footprint_is_supported_but_absent_from_current_seven() -> void:
	var shell = _make_shell()
	for id in EDITABLE_NODE_IDS:
		assert_null(shell._editable_object_node_by_id(id).get_node_or_null("PlacementFootprint"))
	var fridge: Node2D = shell.get_node("EditableObjectNodes/Fridge")
	var collision_before: PackedVector2Array = fridge.call("body_world_polygon")
	var placement := Polygon2D.new()
	placement.name = "PlacementFootprint"
	placement.visible = false
	placement.polygon = PackedVector2Array([Vector2(-80, -40), Vector2(80, -40), Vector2(80, 40), Vector2(-80, 40)])
	fridge.add_child(placement)
	var object_data: Dictionary = _dictionary_map(shell._object_footprints())["fridge"]
	assert_eq(object_data.floor_occupancy_source, "PLACEMENT_FOOTPRINT")
	assert_eq(PackedVector2Array(object_data.floor_polygons[0]), PackedVector2Array(fridge.call("placement_footprint_world_polygon")))
	assert_eq(PackedVector2Array(object_data.collision_polygons[0]), collision_before)


func test_editable_object_configuration_warnings_cover_invalid_contracts() -> void:
	var shell = _make_shell()
	var fridge: Node2D = shell.get_node("EditableObjectNodes/Fridge")
	var interaction: CollisionPolygon2D = fridge.get_node("InteractionArea/InteractionPolygon")
	var original_interaction := interaction.polygon
	interaction.polygon = PackedVector2Array([Vector2.ZERO, Vector2.ONE])
	assert_true(_strings_contain(Array(fridge.call("geometry_warnings")), "InteractionArea/InteractionPolygon requires at least 3 points"))
	assert_true(_strings_contain(Array(fridge.call("_get_configuration_warnings")), "InteractionArea/InteractionPolygon requires at least 3 points"))
	interaction.polygon = original_interaction
	interaction.disabled = true
	assert_true(_strings_contain(Array(fridge.call("geometry_warnings")), "interactive object requires InteractionArea/InteractionPolygon"))
	interaction.disabled = false

	var selection: CollisionPolygon2D = fridge.get_node("SelectionArea/SelectionPolygon")
	var original_selection := selection.polygon
	selection.polygon = PackedVector2Array([Vector2.ZERO, Vector2.ONE])
	assert_true(_strings_contain(Array(fridge.call("geometry_warnings")), "SelectionArea/SelectionPolygon requires at least 3 points"))
	selection.polygon = original_selection
	selection.scale = Vector2(1.1, 1.0)
	assert_true(_strings_contain(Array(fridge.call("geometry_warnings")), "SelectionArea/SelectionPolygon scale must remain (1, 1)"))
	selection.scale = Vector2.ONE
	var selection_area: Area2D = fridge.get_node("SelectionArea")
	selection_area.monitoring = true
	assert_true(_strings_contain(Array(fridge.call("geometry_warnings")), "SelectionArea must remain debug-only"))
	selection_area.monitoring = false

	var body: StaticBody2D = fridge.get_node("Body")
	var legacy_shape := CollisionShape2D.new()
	legacy_shape.shape = RectangleShape2D.new()
	body.add_child(legacy_shape)
	assert_true(_strings_contain(Array(fridge.call("geometry_warnings")), "legacy CollisionShape2D"))
	legacy_shape.free()

	var body_polygon: CollisionPolygon2D = fridge.get_node("Body/BodyPolygon")
	body.remove_child(body_polygon)
	assert_true(_strings_contain(Array(fridge.call("geometry_warnings")), "blocks_movement requires Body/BodyPolygon"))
	body.add_child(body_polygon)
	body_polygon.disabled = true
	assert_true(_strings_contain(Array(fridge.call("geometry_warnings")), "blocks_movement requires Body/BodyPolygon"))
	body_polygon.disabled = false
	body_polygon.scale = Vector2(1.1, 1.0)
	assert_true(_strings_contain(Array(fridge.call("geometry_warnings")), "scale must remain (1, 1)"))
	body_polygon.scale = Vector2.ONE

	var config = _object_map(FOOTPRINT_SET.objects)["fridge"]
	config.visual_size_px = Vector2(1, 1)
	assert_true(_strings_contain(Array(fridge.call("geometry_warnings")), "Resource geometry must remain disabled"))
	config.visual_size_px = Vector2.ZERO

	var use_point: Marker2D = fridge.get_node("UsePoint")
	fridge.remove_child(use_point)
	assert_true(_strings_contain(Array(fridge.call("geometry_warnings")), "required NodePath is missing: UsePoint"))
	assert_true(_strings_contain(Array(fridge.call("geometry_warnings")), "interactive object requires UsePoint"))
	fridge.add_child(use_point)

	var top_point: Marker2D = fridge.get_node("TopPoint")
	var top_position := top_point.position
	top_point.position = fridge.get_node("BasePoint").position
	assert_true(_strings_contain(Array(fridge.call("geometry_warnings")), "BasePoint and TopPoint must identify different"))
	top_point.position = top_position

	var socket: Marker2D = fridge.get_node("AttachmentSocket")
	fridge.remove_child(socket)
	assert_true(_strings_contain(Array(fridge.call("geometry_warnings")), "required NodePath is missing: AttachmentSocket"))
	socket.free()


func test_rotated_floorplan_environment_layout_values_are_preserved() -> void:
	var objects := _object_map(FOOTPRINT_SET.objects)
	_assert_pixels(objects["sink_counter"], Vector2i(3, 4), Vector2.ZERO, Vector2(220, 150), Vector2(160, 70), Vector2(0, 32), Vector2.ZERO, Vector2.ZERO)
	_assert_pixels(objects["dining_table"], Vector2i(4, 7), Vector2.ZERO, Vector2(170, 120), Vector2(130, 70), Vector2(0, 24), Vector2.ZERO, Vector2.ZERO)
	_assert_pixels(objects["signal_booster"], Vector2i(1, 2), Vector2(-68, -58), Vector2(112, 96), Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO)
	_assert_pixels(objects["ups_unit"], Vector2i(8, 2), Vector2.ZERO, Vector2(140, 110), Vector2(100, 60), Vector2(0, 22), Vector2.ZERO, Vector2.ZERO)
	_assert_pixels(objects["bathroom_fixture"], Vector2i(0, 4), Vector2.ZERO, Vector2(200, 140), Vector2(150, 80), Vector2(0, 28), Vector2.ZERO, Vector2.ZERO)
	_assert_pixels(objects["sea_horizon_poster"], Vector2i(11, 7), Vector2(0, -20), Vector2(160, 80), Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO)
	_assert_pixels(objects["fluorescent_light"], Vector2i(6, 6), Vector2.ZERO, Vector2(240, 40), Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO)
	_assert_pixels(objects["shoes_slippers"], Vector2i(1, 9), Vector2.ZERO, Vector2(100, 60), Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO)
	_assert_pixels(objects["cable_bundle"], Vector2i(2, 2), Vector2(36, 42), Vector2(80, 40), Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO)
	_assert_pixels(objects["wall_conduit"], Vector2i(3, 0), Vector2.ZERO, Vector2(128, 64), Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO)
	_assert_pixels(objects["power_housing"], Vector2i(6, 0), Vector2.ZERO, Vector2(240, 210), Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO)


func test_attachment_and_floor_occupancy_policy() -> void:
	var shell = _make_shell()
	var objects := _dictionary_map(shell._object_footprints())
	for id in ["microwave", "signal_booster", "cable_bundle", "power_housing"]:
		assert_eq(objects[id].anchor_type, FOOTPRINT_CONFIG_SCRIPT.AnchorType.PARENT_OBJECT)
		assert_false(objects[id].uses_floor_occupancy)
		assert_false(shell._object_blocker_ids_for_cell(objects[id].anchor_cell).has(id), "%s must not add its own floor blocker." % id)
	assert_eq(objects["ups_unit"].anchor_type, FOOTPRINT_CONFIG_SCRIPT.AnchorType.FLOOR)
	assert_true(objects["ups_unit"].uses_floor_occupancy, "UPS is floor-anchored and keeps a real floor collision.")
	assert_true(shell._object_blocked_cells().has(objects["ups_unit"].anchor_cell))
	assert_false(objects["entrance_door"].uses_floor_occupancy)
	assert_true(objects["entrance_door"].blocks_movement, "Door contract records closed-state wall blocking without adding a floor blocker.")
	assert_gt(Vector2(objects["entrance_door"].collision_size_px).x, 0.0)
	assert_eq(shell._object_floor_polygon_points(objects["entrance_door"]), [])
	assert_false(objects["power_module_board"].uses_floor_occupancy)


func test_parent_and_wall_references_are_valid_and_acyclic() -> void:
	var shell = _make_shell()
	var objects := _dictionary_map(shell._object_footprints())
	assert_eq(objects["microwave"].parent_object_id, "sink_counter")
	assert_eq(objects["signal_booster"].parent_object_id, "node_17")
	assert_eq(objects["power_housing"].parent_object_id, "power_module_board")
	assert_eq(objects["entrance_door"].wall_segment_id, "entrance_wall")
	assert_eq(objects["power_module_board"].wall_segment_id, "work_back_wall")
	assert_eq(objects["sea_horizon_poster"].wall_segment_id, "living_right_wall")
	assert_eq(objects["wall_conduit"].wall_segment_id, "work_back_wall")
	for id in objects:
		var parent_id := String(objects[id].parent_object_id)
		if int(objects[id].anchor_type) == FOOTPRINT_CONFIG_SCRIPT.AnchorType.PARENT_OBJECT:
			assert_false(parent_id.is_empty(), "%s parent-attached placement requires a parent." % id)
		if parent_id.is_empty():
			continue
		assert_true(objects.has(parent_id), "%s parent must exist in the same inventory." % id)
		assert_ne(parent_id, id, "%s must not parent itself." % id)
	assert_eq(objects["power_housing"].wall_segment_id, objects["power_module_board"].wall_segment_id)
	assert_true(String(objects["power_module_board"].node_path).contains("WorkBackWallParentAnchor"))
	assert_true(String(objects["microwave"].node_path).contains("SinkCounterParentAnchor"))
	var entrance_wall: Dictionary = shell._wall_segment_by_id("entrance_wall")
	var entrance_unit: Dictionary = shell._object_wall_attachment_unit(objects["entrance_door"], entrance_wall)
	assert_eq(int(entrance_unit.get("offset", -1)), int(entrance_wall.get("doorway_offset", -2)))
	assert_true(shell._object_wall_attachment_is_doorway(objects["entrance_door"], entrance_wall))
	assert_eq(shell._object_placement_warnings(), [])


func test_wall_attached_objects_use_valid_wall_edge_anchors() -> void:
	var shell = _make_shell()
	var objects := _dictionary_map(shell._object_footprints())
	for id in ["entrance_door", "power_module_board", "sea_horizon_poster", "wall_conduit"]:
		var object_data: Dictionary = objects[id]
		assert_eq(object_data.anchor_type, FOOTPRINT_CONFIG_SCRIPT.AnchorType.WALL_EDGE, "%s must use WALL_EDGE." % id)
		assert_false(object_data.uses_floor_occupancy, "%s must not fake a floor footprint." % id)
		var wall: Dictionary = shell._wall_segment_by_id(String(object_data.wall_segment_id))
		assert_false(wall.is_empty(), "%s wall must exist." % id)
		if id == "entrance_door":
			assert_true(shell._object_wall_attachment_is_doorway(object_data, wall))
		else:
			assert_true(shell._object_wall_attachment_is_available(object_data, wall))


func test_direct_interaction_contract_contains_exactly_seven_world_objects() -> void:
	var shell = _make_shell()
	var objects := _dictionary_map(shell._object_footprints())
	assert_eq(_sorted_strings(shell._direct_interaction_object_ids()), _sorted_strings(DIRECT_INTERACTION_IDS))
	assert_eq(shell._interaction_debug_object_ids().size(), 8, "J debug menu keeps Phone separate from seven world objects.")
	assert_true(shell._interaction_debug_object_ids().has("phone"))
	for id in DIRECT_INTERACTION_IDS:
		assert_eq(objects[id].category, &"interaction")
		assert_true(objects[id].node_backed, "%s must use Scene Node geometry." % id)
		assert_eq(objects[id].source, "scene_node")
		assert_true(shell._object_has_valid_interaction_area(objects[id]), "%s needs a valid interaction area." % id)
		assert_gt(Vector2(objects[id].interaction_size_px).x, 0.0)
		assert_gt(Vector2(objects[id].interaction_size_px).y, 0.0)
		assert_false(shell._object_interaction_cells(objects[id]).is_empty(), "%s needs at least one access cell." % id)


func test_environment_and_decoration_objects_have_no_gameplay_interaction_geometry() -> void:
	var shell = _make_shell()
	var objects := _dictionary_map(shell._object_footprints())
	for id in NON_INTERACTION_IDS:
		assert_ne(String(objects[id].category), "interaction", "%s must remain P-debug-only, not directly usable." % id)
		assert_false(bool(objects[id].get("node_backed", false)), "%s must stay Resource-backed in stage 2." % id)
		assert_eq(objects[id].source, "resource")
		assert_eq(Vector2(objects[id].interaction_size_px), Vector2.ZERO)
		assert_eq(shell._object_raw_interaction_cells(objects[id]), [])
		assert_eq(shell._object_interaction_cells(objects[id]), [])
		assert_false(shell._object_has_valid_interaction_area(objects[id]))


func test_priority_interaction_cells_touch_their_object_or_parent_collision() -> void:
	var shell = _make_shell()
	var objects := _dictionary_map(shell._object_footprints())
	for id in ["bed", "fridge", "node_17", "navi_link"]:
		var object_data: Dictionary = objects[id]
		var collision_polygon := PackedVector2Array(shell._object_collision_polygon_points(object_data))
		assert_gt(collision_polygon.size(), 3, "%s must have collision geometry." % id)
		for interaction_points in shell._object_interaction_polygons(object_data):
			var interaction_polygon := PackedVector2Array(interaction_points)
			assert_false(Geometry2D.intersect_polygons(interaction_polygon, collision_polygon).is_empty(), "%s interaction cell must touch its collision." % id)

	var microwave: Dictionary = objects["microwave"]
	var sink_collision_polygon := PackedVector2Array(shell._object_collision_polygon_points(objects["sink_counter"]))
	var microwave_polygon := PackedVector2Array(shell._object_interaction_polygons(microwave)[0])
	assert_false(Geometry2D.intersect_polygons(microwave_polygon, sink_collision_polygon).is_empty(), "Microwave interaction must touch its parent sink-counter collision.")


func test_rotated_floorplan_layout_invariants() -> void:
	var objects := _object_map(FOOTPRINT_SET.objects)
	var expected_anchors := {
		"sink_counter": Vector2i(3, 4),
		"dining_table": Vector2i(4, 7),
		"bathroom_fixture": Vector2i(0, 4),
	}
	for id in expected_anchors:
		assert_eq(objects[id].anchor_cell, expected_anchors[id], "%s rotated-floorplan anchor changed unexpectedly." % id)
	assert_eq(objects["microwave"].parent_object_id, &"sink_counter")
	assert_eq(objects["entrance_door"].wall_segment_id, &"entrance_wall")
	assert_eq(objects["power_module_board"].wall_segment_id, &"work_back_wall")
	assert_eq(objects["wall_conduit"].wall_segment_id, &"work_back_wall")
	assert_eq(objects["wall_conduit"].wall_position_ratio, 0.31)
	assert_eq(objects["sea_horizon_poster"].anchor_cell, Vector2i(11, 7))
	for id in DIRECT_INTERACTION_IDS:
		assert_eq(objects[id].anchor_cell, Vector2i.ZERO)
		assert_eq(objects[id].size_cells, Vector2i.ZERO)


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
		var fallback_floor: Array[Vector2] = shell._object_floor_polygon_points(objects["sink_counter"])
		var fallback_anchor: Vector2i = objects["sink_counter"].anchor_cell
		var fallback_size: Vector2i = objects["sink_counter"].size_cells
		var expected_floor := [
			shell._iso(fallback_anchor.x, fallback_anchor.y),
			shell._iso(fallback_anchor.x + fallback_size.x, fallback_anchor.y),
			shell._iso(fallback_anchor.x + fallback_size.x, fallback_anchor.y + fallback_size.y),
			shell._iso(fallback_anchor.x, fallback_anchor.y + fallback_size.y),
		]
		assert_eq(fallback_floor, expected_floor, "ROTATE_%d Resource fallback floor must use rotated grid corners." % [rotation * 90])
		_assert_collision_polygon_contract(shell, objects["sink_counter"], rotation * 90)
		var fallback_center: Vector2 = shell._cell_center(objects["sink_counter"].anchor_cell) + Vector2(objects["sink_counter"].position_offset_px)
		assert_eq(shell._object_pixel_center(objects["sink_counter"]), fallback_center)
		for id in EDITABLE_NODE_IDS:
			assert_eq(bool(objects[id].get("node_backed", false)), rotation == 1, "%s Scene geometry is authored only for ROTATE_90." % id)
		if rotation == 1:
			assert_eq(shell._object_pixel_center(objects["microwave"]), Vector2(996, 114))
			assert_eq(shell._object_pixel_center(objects["bed"]), Vector2(1262, 424))
			assert_eq(shell._object_pixel_center(objects["node_17"]), Vector2(996, 38))
			assert_eq(shell._object_pixel_center(objects["entrance_door"]), Vector2(516, 184))
		else:
			for id in EDITABLE_NODE_IDS:
				assert_eq(shell._object_occupied_cells(objects[id]), [], "%s must not become a fallback blocker outside ROTATE_90." % id)
				assert_false(shell._object_blocker_ids_for_cell(Vector2i.ZERO).has(id), "%s must not block fallback cell (0, 0)." % id)
		var entrance_wall: Dictionary = shell._wall_segment_by_id("entrance_wall")
		assert_true(shell._object_wall_attachment_is_doorway(objects["entrance_door"], entrance_wall), "ROTATE_%d entrance door must stay on its doorway unit." % [rotation * 90])
		assert_eq(shell._object_placement_warnings(), [], "ROTATE_%d should preserve placement invariants." % [rotation * 90])
		centers_by_rotation.append(shell._object_pixel_center(objects["sink_counter"]))
	for first in range(centers_by_rotation.size()):
		for second in range(first + 1, centers_by_rotation.size()):
			assert_ne(centers_by_rotation[first], centers_by_rotation[second], "Each map rotation should project fallback geometry to a distinct screen center.")


func test_shell_debug_key_smoke() -> void:
	var shell = _make_shell()
	for keycode in [KEY_G, KEY_W, KEY_E, KEY_O, KEY_V, KEY_L, KEY_J, KEY_H]:
		shell._unhandled_input(_key_event(keycode))
	assert_true(shell.show_floor_grid_coords)
	assert_true(shell.show_wall_ids)
	assert_true(shell.show_wall_edge_coords)
	assert_true(shell.show_occlusion_wall_debug)
	assert_true(shell.show_debug_labels)
	assert_true(shell.wall_inspection_transparency)
	_assert_layer_alpha(shell.get_node("WallLayer"), 0.18)
	_assert_layer_alpha(shell.get_node("OcclusionStubLayer"), 0.18)
	_assert_layer_alpha(shell.get_node("DoorAndWindowLayer"), 0.18)
	assert_false(shell.show_navigation_debug)
	assert_false(shell.show_object_placeholders)
	assert_false(shell.show_room_measurements)
	assert_true(shell._phone_overlay_root.visible, "H should open the shell-only Phone overlay after J smoke coverage.")
	shell._unhandled_input(_key_event(KEY_M))
	assert_true(shell.show_room_measurements)
	shell._unhandled_input(_key_event(KEY_P))
	assert_true(shell.show_object_placeholders)
	assert_false(shell.show_room_measurements)
	assert_true(shell._object_legend_label.visible)
	shell._unhandled_input(_key_event(KEY_N))
	assert_true(shell.show_navigation_debug)
	assert_false(shell.show_object_placeholders)
	assert_false(shell._object_legend_label.visible)


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
	assert_false(shell._object_legend_label.visible)
	assert_false(shell._debug_detail_label.text.contains("anchor:"))
	assert_true(shell._debug_detail_label.text.contains("이동·충돌"))


func test_measurement_mode_has_room_summary_without_object_details() -> void:
	var shell = _make_shell()
	shell._unhandled_input(_key_event(KEY_M))
	assert_true(shell.get_node("RoomMeasurementDebugLayer").visible)
	assert_false(shell.get_node("ObjectPlacementDebugLayer").visible)
	assert_false(shell._object_legend_label.visible)
	assert_false(shell.get_node("DebugLabelLayer").visible, "M should use its single per-room labels instead of the legacy broad label set.")
	assert_true(shell._debug_detail_label.text.contains("방 측량 요약"))
	assert_false(shell._debug_detail_label.text.contains("bed"))


func test_object_mode_draws_four_point_floor_and_collision_polygons() -> void:
	var shell = _make_shell()
	shell._unhandled_input(_key_event(KEY_P))
	var layer: Node = shell.get_node("ObjectPlacementDebugLayer")
	var floor_polygon: Polygon2D = layer.get_node("object_bed_floor_footprint")
	assert_eq(floor_polygon.polygon.size(), 4)
	assert_not_null(layer.get_node_or_null("object_bed_composite_collision_outline"))
	var objects := _dictionary_map(shell._object_footprints())
	assert_eq(shell._object_collision_polygon_points(objects["entrance_door"]).size(), 4)
	assert_eq(shell._object_floor_polygon_points(objects["entrance_door"]), [])
	assert_not_null(layer.get_node_or_null("object_entrance_door_collision_shape"))
	assert_null(layer.get_node_or_null("object_entrance_door_floor_footprint"))
	for id in ["microwave", "power_module_board", "signal_booster", "sea_horizon_poster", "fluorescent_light", "cable_bundle", "wall_conduit", "power_housing"]:
		assert_null(layer.get_node_or_null("object_%s_collision_shape" % id), "%s must not gain fake floor collision geometry." % id)
		assert_eq(shell._object_collision_polygon_points(objects[id]), [], "%s must not project a floor collision polygon." % id)
	assert_eq(shell._object_collision_polygon_points(objects["ups_unit"]).size(), 4, "UPS keeps its floor collision despite parent metadata.")


func test_object_mode_draws_scene_node_collision_separately_from_grid_occupancy() -> void:
	var shell = _make_shell()
	shell._unhandled_input(_key_event(KEY_P))
	var layer: Node = shell.get_node("ObjectPlacementDebugLayer")
	var objects := _dictionary_map(shell._object_footprints())
	assert_true(shell._object_floor_collision_are_equivalent(objects["fridge"]))
	assert_not_null(layer.get_node_or_null("object_fridge_floor_footprint"))
	assert_null(layer.get_node_or_null("object_fridge_collision_shape"), "Equivalent Body occupancy/collision must not duplicate a red face.")
	assert_not_null(layer.get_node_or_null("object_fridge_composite_collision_outline"))
	assert_eq(layer.get_node("object_fridge_floor_footprint").polygon, PackedVector2Array(shell._object_collision_polygon_points(objects["fridge"])))
	assert_true(shell._object_floor_collision_are_equivalent(objects["navi_link"]))
	assert_eq(layer.get_node("object_navi_link_floor_footprint").polygon.size(), 5)
	for id in ["bed", "node_17"]:
		assert_true(shell._object_floor_collision_are_equivalent(objects[id]))
		assert_not_null(layer.get_node_or_null("object_%s_floor_footprint" % id))
		assert_null(layer.get_node_or_null("object_%s_collision_shape" % id))
		assert_not_null(layer.get_node_or_null("object_%s_composite_collision_outline" % id))


func test_invalid_or_empty_interaction_data_draws_no_orange_geometry() -> void:
	var shell = _make_shell()
	shell._unhandled_input(_key_event(KEY_P))
	var layer: Node = shell.get_node("ObjectPlacementDebugLayer")
	for id in NON_INTERACTION_IDS:
		assert_false(_has_child_prefix(layer, "object_%s_interaction_" % id), "%s must not draw orange geometry." % id)
	for id in DIRECT_INTERACTION_IDS:
		assert_true(_has_child_prefix(layer, "object_%s_interaction_area" % id), "%s must draw its owned interaction area." % id)
	for id in EDITABLE_NODE_IDS:
		assert_true(_has_child_prefix(layer, "object_%s_use_point" % id), "%s must draw its independent UsePoint marker." % id)
		assert_false(_has_child_prefix(layer, "object_%s_interaction_marker" % id), "%s must not use the polygon center as its UsePoint." % id)


func test_scene_selection_priority_and_repeated_click_cycle_over_environment_overlap() -> void:
	var shell = _make_shell()
	shell._unhandled_input(_key_event(KEY_P))
	var objects := _dictionary_map(shell._object_footprints())
	var overlap_world_position: Vector2 = shell._polygon_bounds(shell._object_selection_polygons(objects["fridge"])[0]).get_center()
	var microwave: Node2D = shell.get_node("EditableObjectNodes/SinkCounterParentAnchor/Microwave")
	microwave.get_node("SelectionArea").global_position = overlap_world_position
	var candidates: Array[Dictionary] = shell._object_hit_candidates(overlap_world_position)
	assert_eq(_candidate_ids(candidates).slice(0, 2), ["fridge", "microwave"])
	assert_eq(candidates[0].hit_kind, "selection")
	assert_eq(candidates[1].hit_kind, "selection")

	shell._update_object_hover_at(overlap_world_position)
	assert_eq(shell._hovered_object_id, "fridge", "SelectionPolygon must beat overlapping environment geometry.")
	assert_true(shell._debug_detail_label.text.contains("selection owner: fridge"))
	assert_true(shell._select_hovered_object(overlap_world_position))
	assert_eq(shell._selected_object_id, "fridge")
	assert_true(shell._debug_detail_label.text.contains("선택 1/2"))
	assert_true(shell._select_hovered_object(overlap_world_position))
	assert_eq(shell._selected_object_id, "microwave")
	assert_true(shell._debug_detail_label.text.contains("선택 2/2"))
	assert_true(shell._select_hovered_object(overlap_world_position))
	assert_eq(shell._selected_object_id, "fridge", "Third click must wrap to the first ranked candidate.")


func test_scene_selection_polygon_is_independent_from_interaction_polygon() -> void:
	var shell = _make_shell()
	var fridge: Node2D = shell.get_node("EditableObjectNodes/Fridge")
	var selection_area: Node2D = fridge.get_node("SelectionArea")
	var interaction_area: Node2D = fridge.get_node("InteractionArea")
	selection_area.position = Vector2(400, 400)
	interaction_area.position = Vector2(-400, -400)
	var objects := _dictionary_map(shell._object_footprints())
	var selection_center: Vector2 = shell._polygon_bounds(shell._object_selection_polygons(objects["fridge"])[0]).get_center()
	var interaction_center: Vector2 = shell._polygon_bounds(shell._object_interaction_polygons(objects["fridge"])[0]).get_center()
	assert_eq(shell._object_hit_candidate(objects["fridge"], selection_center).hit_kind, "selection")
	assert_eq(shell._object_hit_candidate(objects["fridge"], interaction_center), {}, "InteractionPolygon must not act as the debug selection area for node-backed objects.")


func test_visual_bounds_are_created_only_for_selected_object() -> void:
	var shell = _make_shell()
	shell.show_object_visual_bounds = true
	shell._unhandled_input(_key_event(KEY_P))
	var object_layer: Node = shell.get_node("ObjectPlacementDebugLayer")
	for id in EXPECTED_IDS:
		assert_false(_has_child_prefix(object_layer, "object_%s_visual_bounds" % id))
	shell._select_object_for_debug("fridge")
	assert_true(_has_child_prefix(shell.get_node("DebugSelectionLayer"), "object_fridge_visual_bounds"))


func test_object_mode_legend_and_selected_bounds_show_anchor_detail() -> void:
	var shell = _make_shell()
	shell._unhandled_input(_key_event(KEY_P))
	shell.show_object_visual_bounds = true
	assert_true(shell._object_legend_label.visible)
	assert_true(shell._object_legend_label.text.contains("collision"))
	assert_true(shell._object_legend_label.text.contains("AttachmentSocket"))
	assert_true(shell._object_legend_label.text.contains("VisualPreview"))
	assert_true(shell._object_legend_label.text.contains("InteractionPolygon"))
	assert_true(shell._object_legend_label.text.contains("SelectionPolygon"))
	assert_true(shell._object_legend_label.text.contains("BasePoint"))
	assert_true(shell._object_legend_label.text.contains("TopPoint"))
	assert_true(shell._object_legend_label.text.contains("UsePoint"))
	assert_true(shell._object_legend_label.text.contains("파랑 채움 + 빨강 테두리"))
	assert_true(shell._object_legend_label.text.contains("후보 순환"))
	assert_true(shell._object_legend_label.text.contains("전체 벽 반투명"))
	assert_gt(shell._debug_detail_panel.get_global_rect().position.x, 0.0, "P detail panel must stay inside the viewport.")
	var bed: Dictionary = _dictionary_map(shell._object_footprints())["bed"]
	var bed_viewport_position: Vector2 = shell.get_viewport().get_canvas_transform() * shell._object_pixel_center(bed)
	shell._unhandled_input(_mouse_motion_event(bed_viewport_position))
	assert_eq(shell._hovered_object_id, "bed")
	assert_not_null(shell.get_node("DebugSelectionLayer").get_node_or_null("object_bed_short_name"))
	shell._unhandled_input(_mouse_click_event(bed_viewport_position))
	assert_eq(shell._selected_object_id, "bed")
	assert_true(shell._debug_detail_label.text.contains("id: bed"))
	assert_true(shell._debug_detail_label.text.contains("anchor resolved: FLOOR"))
	assert_true(_has_child_prefix(shell.get_node("DebugSelectionLayer"), "object_bed_visual_bounds"))
	assert_true(_has_child_prefix(shell.get_node("DebugSelectionLayer"), "object_bed_occupancy_bounds"))
	assert_true(_has_child_prefix(shell.get_node("DebugSelectionLayer"), "object_bed_composite_collision_outline"))
	assert_true(_has_child_prefix(shell.get_node("DebugSelectionLayer"), "object_bed_interaction_bounds"))
	shell._update_object_hover_at(Vector2(-10000, -10000))
	assert_eq(shell._hovered_object_id, "")
	assert_eq(shell._selected_object_id, "bed", "Moving hover away must preserve click selection.")
	shell._select_object_for_debug("fridge")
	assert_true(shell._debug_detail_label.text.contains("geometry source: SCENE_NODE"))
	assert_true(shell._debug_detail_label.text.contains("EditableObjectNodes/Fridge"))
	assert_true(shell._debug_detail_label.text.contains("UsePoint:"))
	assert_true(shell._debug_detail_label.text.contains("visual source: SPRITE2D"))
	assert_true(shell._debug_detail_label.text.contains("floor source: BODY_POLYGON"))
	assert_true(shell._debug_detail_label.text.contains("selection source: SELECTION_POLYGON"))
	assert_true(shell._debug_detail_label.text.contains("BasePoint:"))
	assert_true(shell._debug_detail_label.text.contains("TopPoint:"))
	assert_true(shell._debug_detail_label.text.contains("AttachmentSocket:"))
	assert_true(_has_child_prefix(shell.get_node("ObjectPlacementDebugLayer"), "object_fridge_selection_area"))
	assert_true(_has_child_prefix(shell.get_node("ObjectPlacementDebugLayer"), "object_fridge_base_point"))
	assert_true(_has_child_prefix(shell.get_node("ObjectPlacementDebugLayer"), "object_fridge_top_point"))
	assert_true(_has_child_prefix(shell.get_node("ObjectPlacementDebugLayer"), "object_fridge_height_guide"))
	assert_true(_has_child_prefix(shell.get_node("DebugSelectionLayer"), "object_fridge_selected_selection_area"))
	assert_true(_has_child_prefix(shell.get_node("DebugSelectionLayer"), "object_fridge_selected_base_point"))
	shell._select_object_for_debug("bed")
	assert_true(shell._debug_detail_label.text.contains("geometry source: SCENE_NODE"))
	assert_true(shell._debug_detail_label.text.contains("EditableObjectNodes/Bed"))
	var board: Dictionary = _dictionary_map(shell._object_footprints())["power_module_board"]
	shell._select_object_for_debug("power_module_board")
	assert_true(shell._debug_detail_label.text.contains("work_back_wall"))
	assert_true(_has_child_prefix(shell.get_node("DebugSelectionLayer"), "object_power_module_board_selected_attachment_socket"))
	assert_true(_has_child_prefix(shell.get_node("DebugSelectionLayer"), "object_power_module_board_selected_attachment_wall_edge"))
	assert_ne(shell._object_anchor_world_position(board), shell._cell_center(board.anchor_cell), "Wall anchor must resolve from its wall edge, not a fake floor center.")


func test_wall_transparency_toggle_is_visual_only() -> void:
	var shell = _make_shell()
	var blocked_before: Array[Vector2i] = shell._object_blocked_cells()
	var edges_before: Dictionary = shell._navigation_edge_sets()
	var wall_count_before: int = shell._wall_segments().size()
	shell._unhandled_input(_key_event(KEY_V))
	assert_true(shell.wall_inspection_transparency)
	_assert_layer_alpha(shell.get_node("WallLayer"), 0.18)
	_assert_layer_alpha(shell.get_node("OcclusionStubLayer"), 0.18)
	_assert_layer_alpha(shell.get_node("DoorAndWindowLayer"), 0.18)
	_assert_layer_alpha(shell.get_node("FloorEdgeLayer"), 1.0)
	_assert_layer_alpha(shell.get_node("NavigationDebugLayer"), 1.0)
	assert_eq(shell._wall_segments().size(), wall_count_before)
	assert_eq(shell._object_blocked_cells(), blocked_before)
	assert_eq(shell._navigation_edge_sets()["blocked"].keys().size(), edges_before["blocked"].keys().size())
	assert_true(shell._compact_help_label.text.contains("전체벽=반투명"))
	shell.preview_revealed_walls = true
	shell._redraw_reveal_sensitive_layers()
	_assert_layer_alpha(shell.get_node("WallLayer"), 0.18)
	_assert_layer_alpha(shell.get_node("DoorAndWindowLayer"), 0.18)
	assert_eq(shell._navigation_edge_sets()["blocked"].keys().size(), edges_before["blocked"].keys().size())
	shell._unhandled_input(_key_event(KEY_V))
	assert_false(shell.wall_inspection_transparency)
	_assert_layer_alpha(shell.get_node("WallLayer"), 1.0)
	_assert_layer_alpha(shell.get_node("OcclusionStubLayer"), 1.0)
	_assert_layer_alpha(shell.get_node("DoorAndWindowLayer"), 1.0)


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
	var help_labels: Array[Node] = shell._debug_help_panel.find_children("*", "Label", true, false)
	var help_text := ""
	for label in help_labels:
		help_text += String(label.text)
	assert_true(help_text.contains("V  전체 candidate 벽·문·창 반투명"))
	assert_true(help_text.contains("ROTATE_90 / full_map"))
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


func _candidate_ids(candidates: Array[Dictionary]) -> Array[String]:
	var ids: Array[String] = []
	for candidate in candidates:
		ids.append(String(candidate.get("id", "")))
	return ids


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


func _strings_contain(values: Array, fragment: String) -> bool:
	for value in values:
		if String(value).contains(fragment):
			return true
	return false


func _assert_layer_alpha(layer: CanvasItem, expected_alpha: float) -> void:
	assert_true(is_equal_approx(layer.modulate.a, expected_alpha), "%s alpha must be %.2f." % [layer.name, expected_alpha])


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
