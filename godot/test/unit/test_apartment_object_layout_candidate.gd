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
const EDITABLE_ENVIRONMENT_NODE_IDS := [
	"sink_counter", "dining_table", "ups_unit", "bathroom_fixture", "shoes_slippers",
]
const ALL_EDITABLE_NODE_IDS := EDITABLE_NODE_IDS + EDITABLE_ENVIRONMENT_NODE_IDS
const RESOURCE_BACKED_ENVIRONMENT_IDS := [
	"signal_booster", "sea_horizon_poster", "fluorescent_light",
	"cable_bundle", "wall_conduit", "power_housing",
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
	for id in ALL_EDITABLE_NODE_IDS:
		_assert_pixels(objects[id], Vector2i.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO)
		assert_eq(objects[id].size_cells, Vector2i.ZERO, "%s Resource must not duplicate Scene occupancy size." % id)
		assert_eq(objects[id].collision_shape_type, FOOTPRINT_CONFIG_SCRIPT.CollisionShapeType.NONE)
		assert_eq(objects[id].interaction_cells, [], "%s Resource must not duplicate Scene use points." % id)
		assert_eq(objects[id].interaction_cell, Vector2i(-1, -1))


func test_editable_object_scene_nodes_are_the_rotated_view_geometry_authority() -> void:
	var shell = _make_shell()
	var expected_paths := {
		"entrance_door": "EditableObjectNodes/EntranceDoor",
		"bed": "EditableObjectNodes/Bed",
		"fridge": "EditableObjectNodes/Fridge",
		"navi_link": "EditableObjectNodes/NaviLink",
		"microwave": "EditableObjectNodes/SinkCounter/AttachmentSockets/MicrowaveSocket/Microwave",
		"power_module_board": "EditableObjectNodes/PowerModuleBoard",
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
		"fridge": Vector2(1136, 190), "navi_link": Vector2(1264, 94),
		"microwave": Vector2(996, 114), "power_module_board": Vector2(1476, 96),
		"node_17": Vector2(996, 38),
	}
	var expected_base_points := {
		"entrance_door": Vector2(516, 190), "bed": Vector2(1262, 514),
		"fridge": Vector2(1136, 263), "navi_link": Vector2(1264, 214),
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
		if ALL_EDITABLE_NODE_IDS.has(id):
			continue
		assert_false(bool(objects[id].get("node_backed", false)), "%s must keep the Resource fallback path." % id)
		assert_eq(objects[id].source, "resource")


func test_floor_environment_scene_nodes_preserve_geometry_without_interaction_nodes() -> void:
	var shell = _make_shell()
	var expected := {
		"sink_counter": {
			"path": "EditableObjectNodes/SinkCounter", "position": Vector2(996, 174),
			"visual": PackedVector2Array([Vector2(-110, -75), Vector2(110, -75), Vector2(110, 75), Vector2(-110, 75)]),
			"body": PackedVector2Array([Vector2(-40.249224, -19.429563), Vector2(102.859127, 52.124612), Vector2(40.249224, 83.429563), Vector2(-102.859127, 11.875388)]),
			"top": Vector2(0, -75), "cells": [Vector2i(3, 4), Vector2i(4, 4)],
		},
		"dining_table": {
			"path": "EditableObjectNodes/DiningTable", "position": Vector2(868, 302),
			"visual": PackedVector2Array([Vector2(-85, -60), Vector2(85, -60), Vector2(85, 60), Vector2(-85, 60)]),
			"body": PackedVector2Array([Vector2(-26.832816, -20.72136), Vector2(89.442719, 37.416408), Vector2(26.832816, 68.72136), Vector2(-89.442719, 10.583592)]),
			"top": Vector2(0, -60), "cells": [Vector2i(4, 7)],
		},
		"ups_unit": {
			"path": "EditableObjectNodes/UpsUnit", "position": Vector2(1444, 270),
			"visual": PackedVector2Array([Vector2(-70, -55), Vector2(70, -55), Vector2(70, 55), Vector2(-70, 55)]),
			"body": PackedVector2Array([Vector2(-17.888544, -13.777088), Vector2(71.554175, 30.944272), Vector2(17.888544, 57.777088), Vector2(-71.554175, 13.055728)]),
			"top": Vector2(0, -55), "cells": [Vector2i(8, 2)],
		},
		"bathroom_fixture": {
			"path": "EditableObjectNodes/BathroomFixture", "position": Vector2(804, 78),
			"visual": PackedVector2Array([Vector2(-100, -70), Vector2(100, -70), Vector2(100, 70), Vector2(-100, 70)]),
			"body": PackedVector2Array([Vector2(-31.304952, -23.429563), Vector2(102.859127, 43.652476), Vector2(31.304952, 79.429563), Vector2(-102.859127, 12.347524)]),
			"top": Vector2(0, -70), "cells": [Vector2i(0, 4)],
		},
		"shoes_slippers": {
			"path": "EditableObjectNodes/ShoesSlippers", "position": Vector2(548, 270),
			"visual": PackedVector2Array([Vector2(-50, -30), Vector2(50, -30), Vector2(50, 30), Vector2(-50, 30)]),
			"body": PackedVector2Array(), "top": Vector2(0, -30), "cells": [],
		},
	}
	var objects := _dictionary_map(shell._object_footprints())
	for id in EDITABLE_ENVIRONMENT_NODE_IDS:
		var spec: Dictionary = expected[id]
		var object_node: Node2D = shell.get_node(spec.path)
		assert_eq(object_node.position, spec.position)
		assert_true(object_node.is_in_group("apartment_editable_environment_object"))
		assert_eq(object_node.get_node("Visual/VisualPreview").polygon, spec.visual)
		assert_eq(object_node.get_node("SelectionArea/SelectionPolygon").polygon, spec.visual)
		assert_eq(object_node.get_node("BasePoint").position, Vector2.ZERO)
		assert_eq(object_node.get_node("TopPoint").position, spec.top)
		assert_eq(object_node.get_node_or_null("Body/BodyPolygon").polygon if object_node.has_node("Body/BodyPolygon") else PackedVector2Array(), spec.body)
		assert_true(object_node.get_node("Visual/VisualPreview").editor_description.contains("실제 이미지가 없을 때만"))
		assert_true(object_node.get_node("BasePoint").editor_description.contains("바닥 또는 설치 기준점"))
		assert_true(object_node.get_node("TopPoint").editor_description.contains("화면상 높이 확인 기준점"))
		assert_true(object_node.get_node("SelectionArea/SelectionPolygon").editor_description.contains("P 디버그"))
		assert_null(object_node.get_node_or_null("InteractionArea"))
		assert_null(object_node.get_node_or_null("InteractionPolygon"))
		assert_null(object_node.get_node_or_null("UsePoint"))
		assert_null(object_node.get_node_or_null("PlacementFootprint"))
		assert_eq(object_node.get_node("Visual/VisualPreview").scale, Vector2.ONE)
		assert_eq(object_node.get_node("SelectionArea/SelectionPolygon").scale, Vector2.ONE)
		if object_node.has_node("Body/BodyPolygon"):
			assert_eq(object_node.get_node("Body/BodyPolygon").scale, Vector2.ONE)
			assert_true(object_node.get_node("Body/BodyPolygon").editor_description.contains("플레이어 이동을 막는 바닥 충돌 범위"))
			var world_body: PackedVector2Array = objects[id].collision_polygons[0]
			for point_index in range(spec.body.size()):
				assert_eq(world_body[point_index], spec.position + spec.body[point_index])
		assert_eq(object_node.geometry_warnings(), [])
		assert_true(objects[id].node_backed)
		assert_eq(objects[id].source, "scene_node")
		assert_eq(objects[id].interaction_polygons, [])
		assert_eq(objects[id].interaction_cells, [])
		assert_eq(objects[id].use_points_world, [])
		assert_eq(objects[id].occupied_cells, spec.cells)
	assert_eq(shell.get_node("EditableObjectNodes/SinkCounter/AttachmentSockets/MicrowaveSocket").position, Vector2.ZERO)
	assert_true(shell.get_node("EditableObjectNodes/SinkCounter/AttachmentSockets/MicrowaveSocket").editor_description.contains("전자레인지 부착 기준점"))
	assert_eq(shell.get_node("EditableObjectNodes/UpsUnit/AttachmentSockets/PowerCableSocket").position, Vector2.ZERO)
	assert_false(objects["shoes_slippers"].blocks_movement)
	assert_false(objects["shoes_slippers"].uses_floor_occupancy)
	assert_eq(objects["shoes_slippers"].collision_polygons, [])


func test_environment_body_vertex_extension_updates_derived_floor_cells() -> void:
	var shell = _make_shell()
	var body: CollisionPolygon2D = shell.get_node("EditableObjectNodes/SinkCounter/Body/BodyPolygon")
	var original := body.polygon
	var extended := body.polygon
	extended[1] += Vector2(64, 32)
	extended[2] += Vector2(64, 32)
	body.polygon = extended
	var occupied: Array = _dictionary_map(shell._object_footprints())["sink_counter"].occupied_cells
	assert_eq(occupied, [Vector2i(3, 4), Vector2i(4, 4), Vector2i(5, 4)])
	body.polygon = original
	assert_eq(_dictionary_map(shell._object_footprints())["sink_counter"].occupied_cells, [Vector2i(3, 4), Vector2i(4, 4)])
	body.position += Vector2(128, 64)
	var moved_cells: Array = _dictionary_map(shell._object_footprints())["sink_counter"].occupied_cells
	assert_false(moved_cells.has(Vector2i(3, 4)), "A moved BodyPolygon must not leave a hidden blocker at BasePoint.")
	assert_eq(moved_cells, [Vector2i(5, 4), Vector2i(6, 4)])
	body.position += Vector2(5000, 5000)
	assert_eq(
		_dictionary_map(shell._object_footprints())["sink_counter"].occupied_cells,
		[],
		"A BodyPolygon with zero floor overlap must not block the entire BasePoint row."
	)


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
		["EditableObjectNodes/SinkCounter", "microwave"],
		["Walls/WorkBackWall/WallCells/Cell05/AttachmentSocket", "power_module_board"],
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

	assert_null(shell.get_node_or_null("EditableObjectNodes/SinkCounterParentAnchor"))
	var sink_node: Node2D = shell.get_node("EditableObjectNodes/SinkCounter")
	var microwave_socket: Marker2D = shell.get_node("EditableObjectNodes/SinkCounter/AttachmentSockets/MicrowaveSocket")
	var microwave_node: Node2D = microwave_socket.get_node("Microwave")
	assert_eq(microwave_node.get_parent(), microwave_socket)
	var sink_before: Vector2 = _dictionary_map(shell._object_footprints())["sink_counter"].visual_center_world
	var microwave_before: Dictionary = _dictionary_map(shell._object_footprints())["microwave"]
	var microwave_center_before: Vector2 = shell._object_pixel_center(microwave_before)
	var microwave_selection_before: Vector2 = shell._object_selection_polygons(microwave_before)[0][0]
	var microwave_interaction_before: Vector2 = shell._object_interaction_polygons(microwave_before)[0][0]
	var microwave_use_before: Vector2 = microwave_before.use_points_world[0]
	microwave_socket.position += Vector2(12, 6)
	var microwave_after: Dictionary = _dictionary_map(shell._object_footprints())["microwave"]
	assert_eq(shell._object_pixel_center(microwave_after), microwave_center_before + Vector2(12, 6))
	assert_eq(shell._object_selection_polygons(microwave_after)[0][0], microwave_selection_before + Vector2(12, 6))
	assert_eq(shell._object_interaction_polygons(microwave_after)[0][0], microwave_interaction_before + Vector2(12, 6))
	assert_eq(microwave_after.use_points_world[0], microwave_use_before + Vector2(12, 6))
	assert_eq(_dictionary_map(shell._object_footprints())["sink_counter"].visual_center_world, sink_before)
	assert_eq(sink_node.position, Vector2(1012, 182), "Earlier root movement remains independent from MicrowaveSocket movement.")

	var board_socket: Node2D = shell.get_node("EditableObjectNodes/PowerModuleBoard/AttachmentSocket")
	var housing_before: Vector2 = shell._object_pixel_center(_dictionary_map(shell._object_footprints())["power_housing"])
	board_socket.position += Vector2(8, 4)
	var housing_after: Vector2 = shell._object_pixel_center(_dictionary_map(shell._object_footprints())["power_housing"])
	assert_eq(housing_after, housing_before + Vector2(8, 4), "Resource child attachments must follow AttachmentSocket.")


func test_new_interaction_nodes_keep_selection_interaction_and_use_independent() -> void:
	var shell = _make_shell()
	for path_and_id in [
		["EditableObjectNodes/Bed", "bed"],
		["EditableObjectNodes/Node17", "node_17"],
		["EditableObjectNodes/EntranceDoor", "entrance_door"],
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
	var door_node: Node2D = shell.get_node("EditableObjectNodes/EntranceDoor")
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
	_assert_pixels(objects["signal_booster"], Vector2i(1, 2), Vector2(-68, -58), Vector2(112, 96), Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO)
	_assert_pixels(objects["sea_horizon_poster"], Vector2i(11, 7), Vector2(0, -20), Vector2(160, 80), Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO)
	_assert_pixels(objects["fluorescent_light"], Vector2i(6, 6), Vector2.ZERO, Vector2(240, 40), Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO)
	_assert_pixels(objects["cable_bundle"], Vector2i(2, 2), Vector2(36, 42), Vector2(80, 40), Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO)
	_assert_pixels(objects["wall_conduit"], Vector2i(3, 0), Vector2.ZERO, Vector2(128, 64), Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO)
	_assert_pixels(objects["power_housing"], Vector2i(6, 0), Vector2.ZERO, Vector2(240, 210), Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO)
	for id in EDITABLE_ENVIRONMENT_NODE_IDS:
		_assert_pixels(objects[id], Vector2i.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO)


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
	assert_true(String(shell.get_node("EditableObjectNodes/PowerModuleBoard").mount_socket_path).contains("Cell05/AttachmentSocket"))
	assert_true(String(objects["microwave"].node_path).contains("SinkCounter/AttachmentSockets/MicrowaveSocket"))
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
	var resource_backed_ids: Array[String] = []
	for id in NON_INTERACTION_IDS:
		assert_ne(String(objects[id].category), "interaction", "%s must remain P-debug-only, not directly usable." % id)
		if EDITABLE_ENVIRONMENT_NODE_IDS.has(id):
			assert_true(objects[id].node_backed)
			assert_eq(objects[id].source, "scene_node")
			var object_node: Node = objects[id].object_node
			assert_null(object_node.get_node_or_null("InteractionArea"))
			assert_null(object_node.get_node_or_null("InteractionPolygon"))
			assert_null(object_node.get_node_or_null("UsePoint"))
		else:
			assert_false(bool(objects[id].get("node_backed", false)), "%s must keep the Resource fallback path." % id)
			assert_eq(objects[id].source, "resource")
			resource_backed_ids.append(id)
		assert_eq(Vector2(objects[id].interaction_size_px), Vector2.ZERO)
		assert_eq(shell._object_raw_interaction_cells(objects[id]), [])
		assert_eq(shell._object_interaction_cells(objects[id]), [])
		assert_false(shell._object_has_valid_interaction_area(objects[id]))
	assert_eq(_sorted_strings(resource_backed_ids), _sorted_strings(RESOURCE_BACKED_ENVIRONMENT_IDS))


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
	for id in ALL_EDITABLE_NODE_IDS:
		assert_eq(objects[id].anchor_cell, Vector2i.ZERO)
		assert_eq(objects[id].size_cells, Vector2i.ZERO)
	assert_eq(objects["microwave"].parent_object_id, &"sink_counter")
	assert_eq(objects["entrance_door"].wall_segment_id, &"entrance_wall")
	assert_eq(objects["power_module_board"].wall_segment_id, &"work_back_wall")
	assert_eq(objects["wall_conduit"].wall_segment_id, &"work_back_wall")
	assert_eq(objects["wall_conduit"].wall_position_ratio, 0.31)
	assert_eq(objects["sea_horizon_poster"].anchor_cell, Vector2i(11, 7))


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
	for rotation in [0, 1, 2, 3]:
		var shell = SHELL_SCENE.instantiate()
		shell.map_rotation = rotation
		add_child_autoqfree(shell)
		assert_eq(shell._object_footprints().size(), 18, "ROTATE_%d should instantiate all objects." % [rotation * 90])
		var objects := _dictionary_map(shell._object_footprints())
		for id in ALL_EDITABLE_NODE_IDS:
			assert_eq(bool(objects[id].get("node_backed", false)), rotation == 1, "%s Scene geometry is authored only for ROTATE_90." % id)
		if rotation == 1:
			assert_eq(shell._object_pixel_center(objects["microwave"]), Vector2(996, 114))
			assert_eq(shell._object_pixel_center(objects["bed"]), Vector2(1262, 424))
			assert_eq(shell._object_pixel_center(objects["node_17"]), Vector2(996, 38))
			assert_eq(shell._object_pixel_center(objects["entrance_door"]), Vector2(516, 184))
		else:
			for id in ALL_EDITABLE_NODE_IDS:
				assert_eq(shell._object_occupied_cells(objects[id]), [], "%s must not become a fallback blocker outside ROTATE_90." % id)
				assert_false(shell._object_blocker_ids_for_cell(Vector2i.ZERO).has(id), "%s must not block fallback cell (0, 0)." % id)
		var entrance_wall: Dictionary = shell._wall_segment_by_id("entrance_wall")
		assert_true(shell._object_wall_attachment_is_doorway(objects["entrance_door"], entrance_wall), "ROTATE_%d entrance door must stay on its doorway unit." % [rotation * 90])
		assert_eq(shell._object_placement_warnings(), [], "ROTATE_%d should preserve placement invariants." % [rotation * 90])


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
	var microwave: Node2D = shell.get_node("EditableObjectNodes/SinkCounter/AttachmentSockets/MicrowaveSocket/Microwave")
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
	assert_true(shell._debug_detail_label.text.contains("선택 1/3"))
	assert_true(shell._select_hovered_object(overlap_world_position))
	assert_eq(shell._selected_object_id, "microwave")
	assert_true(shell._debug_detail_label.text.contains("선택 2/3"))
	assert_true(shell._select_hovered_object(overlap_world_position))
	assert_eq(shell._selected_object_id, "navi_link")
	assert_true(shell._debug_detail_label.text.contains("선택 3/3"))
	assert_true(shell._select_hovered_object(overlap_world_position))
	assert_eq(shell._selected_object_id, "fridge", "Fourth click must wrap to the first ranked candidate.")


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
	assert_true(shell._object_legend_label.text.contains("기본→반투명→숨김"))
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
	assert_true(shell._debug_detail_label.text.contains("AttachmentSockets:"))
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
	assert_eq(shell.wall_inspection_mode, shell.WallInspectionMode.TRANSPARENT)
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
	assert_eq(shell.wall_inspection_mode, shell.WallInspectionMode.HIDDEN)
	assert_false(shell.get_node("WallLayer").visible)
	assert_false(shell.get_node("Walls/WorkBackWall/WallCells/Cell00/Visual").visible)
	assert_false(shell.get_node("Walls/WorkBackWall/WallCells/Cell00/CollisionBody/CollisionPolygon2D").disabled)
	assert_false(shell.get_node("EditableObjectNodes/EntranceDoor/Body/BodyPolygon").disabled, "HIDDEN must keep the closed door collision active.")
	assert_eq(shell._navigation_edge_sets()["blocked"].keys().size(), edges_before["blocked"].keys().size())
	assert_true(shell._compact_help_label.text.contains("전체벽=숨김"))
	assert_true(shell._debug_help_body_label.text.contains("현재: 숨김"))
	shell._redraw_reveal_sensitive_layers()
	assert_false(shell.get_node("Walls/LivingRightWall/WallCells/Cell00/Visual").visible, "Reveal refresh must not escape HIDDEN inspection mode.")
	shell._unhandled_input(_key_event(KEY_V))
	assert_eq(shell.wall_inspection_mode, shell.WallInspectionMode.NORMAL)
	_assert_layer_alpha(shell.get_node("WallLayer"), 1.0)
	_assert_layer_alpha(shell.get_node("OcclusionStubLayer"), 1.0)
	_assert_layer_alpha(shell.get_node("DoorAndWindowLayer"), 1.0)
	assert_true(shell.get_node("WallLayer").visible)


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
	assert_true(help_text.contains("V  전체 벽 표시 순환: 기본 → 반투명 → 숨김"))
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


func test_environment_floor_room_wall_and_opening_nodes_are_scene_authority() -> void:
	var shell = _make_shell()
	assert_true(shell._environment_node_authority_active())
	var expected_floor_counts := {
		"EntranceFloor": 6,
		"BathroomFloor": 7,
		"LivingFloor": 54,
		"WorkFloor": 32,
	}
	for floor_name in expected_floor_counts:
		var floor_layer: TileMapLayer = shell.get_node("Floor/%s" % floor_name)
		assert_eq(floor_layer.get_used_cells().size(), expected_floor_counts[floor_name])
		assert_true(floor_layer.editor_description.contains("TileMap"))
	assert_eq(shell._visible_floor_cells().size(), 99)
	assert_eq(shell.get_node("FloorTileLayer").get_child_count(), 0, "Environment must not rebuild floor diamonds at runtime.")

	var expected_room_points := {
		"EntranceArea": 4,
		"BathroomArea": 4,
		"LivingArea": 4,
		"WorkArea": 4,
	}
	for room_name in expected_room_points:
		var room_node = shell.get_node("RoomAreas/%s" % room_name)
		assert_eq(room_node.world_polygon().size(), expected_room_points[room_name])
		assert_true(room_node.get_node("Area2D/CollisionPolygon2D").editor_description.contains("논리 구역"))
	assert_eq(shell._room_measurement_data("bathroom").source, "SCENE_NODE")
	assert_eq(shell._room_area_for_cell(Vector2i(0, 4), false), "bathroom")
	assert_eq(shell._room_area_for_cell(Vector2i(0, 8), false), "entrance_area")

	assert_eq(shell.get_node("Walls").get_child_count(), 10)
	var total_wall_cells := 0
	for wall_group in shell.get_node("Walls").get_children():
		total_wall_cells += wall_group.wall_cells().size()
		for cell in wall_group.wall_cells():
			assert_true(cell.editor_description.contains("Cell"))
	assert_eq(total_wall_cells, 58)
	assert_eq(shell.get_node("Openings").get_child_count(), 5)
	for segment in shell._wall_segments():
		assert_eq(segment.source, "SCENE_NODE")
		assert_true(String(segment.node_path).contains("/Walls/"))
	assert_eq(shell.get_node("WallLayer").get_child_count(), 0, "Environment must not rebuild wall visuals at runtime.")
	assert_eq(shell.get_node("DoorAndWindowLayer").get_child_count(), 0, "Environment openings must remain Scene nodes.")
	assert_eq(shell.get_node("Openings/EntranceDoorOpening/StartPoint").position, Vector2(548, 174))
	assert_eq(shell.get_node("Openings/WorkRoomOpening/EndPoint").position, Vector2(1252, 270))
	assert_eq(shell.get_node("Walls/WorkBackWall/StartPoint").position, Vector2(1124, -50))
	assert_eq(shell.get_node("Walls/WorkBackWall/EndPoint").position, Vector2(1636, 206))
	assert_eq(shell.get_node("Walls/WorkBackWall/TopPoint").position, Vector2(1380, -98))

	var board = shell.get_node("EditableObjectNodes/PowerModuleBoard")
	var door = shell.get_node("EditableObjectNodes/EntranceDoor")
	assert_true(String(board.mount_socket_path).contains("Cell05/AttachmentSocket"))
	assert_true(String(door.mount_socket_path).contains("Cell04/AttachmentSocket"))
	assert_eq(board.attachment_anchor_world(), shell.get_node("Walls/WorkBackWall/WallCells/Cell05/AttachmentSocket").global_position)
	assert_eq(door.attachment_anchor_world(), shell.get_node("Walls/EntranceWall/WallCells/Cell04/AttachmentSocket").global_position)
	assert_false(shell.get_node("EditorGuides").visible, "Editor floor labels and legend must stay hidden at runtime.")


func test_non_rotated_fallback_disables_authored_rotated_visuals_and_collisions() -> void:
	var shell = SHELL_SCENE.instantiate()
	shell.map_rotation = 0
	add_child_autoqfree(shell)
	assert_false(shell._environment_node_authority_active())
	assert_false(shell.get_node("Floor").visible)
	assert_false(shell.get_node("Walls").visible)
	assert_false(shell.get_node("EditableObjectNodes").visible)
	assert_gt(shell.get_node("FloorTileLayer").get_child_count(), 0)
	assert_gt(shell.get_node("WallLayer").get_child_count(), 0)
	for wall_node in shell.get_node("Walls").get_children():
		assert_true(wall_node.all_collisions_disabled())


func test_custom_wall_override_disables_authored_wall_nodes_and_uses_legacy_renderer() -> void:
	var shell = SHELL_SCENE.instantiate()
	var custom_segments: Array[Resource] = shell._default_wall_segment_configs()
	shell.custom_wall_segments = custom_segments
	add_child_autoqfree(shell)
	assert_true(shell._environment_node_authority_active())
	assert_false(shell._wall_node_authority_active())
	assert_true(shell.get_node("Floor").visible)
	assert_false(shell.get_node("Walls").visible)
	assert_gt(shell.get_node("WallLayer").get_child_count(), 0)
	assert_eq(shell._wall_segments().size(), custom_segments.size())
	for segment in shell._wall_segments():
		assert_eq(segment.source, "custom_wall_segments")
	for wall_node in shell.get_node("Walls").get_children():
		assert_true(wall_node.all_collisions_disabled())


func test_wall_node_collision_keeps_non_passable_window_solid_and_honors_enabled_state() -> void:
	var shell = _make_shell()
	var wall = shell.get_node("Walls/LivingRightWall")
	var opening = shell.get_node("Openings/LivingWindowOpening")
	var window_cell = wall.get_node("WallCells/Cell05")
	var collision: CollisionPolygon2D = window_cell.get_node("CollisionBody/CollisionPolygon2D")
	assert_false(opening.passable)
	assert_eq(window_cell.opening_kind, 2)
	assert_false(collision.disabled)
	wall.enabled = false
	wall._sync_group_from_cells()
	assert_true(collision.disabled)
	wall.enabled = true
	wall._sync_group_from_cells()
	assert_false(collision.disabled)


func test_wall_cell_move_visibility_openings_and_socket_tracking_use_cell_authority() -> void:
	var shell = _make_shell()
	var wall = shell.get_node("Walls/WorkBackWall")
	var cell: Node2D = wall.get_node("WallCells/Cell05")
	var collision: CollisionPolygon2D = cell.get_node("CollisionBody/CollisionPolygon2D")
	var board: Node2D = shell.get_node("EditableObjectNodes/PowerModuleBoard")
	var edge_before: Dictionary = shell._wall_segment_unit_edge(shell._wall_segment_by_id("work_back_wall"), 5)
	var board_before := board.global_position
	var cell_before := cell.position
	cell.position += Vector2(64, -32)
	wall._sync_group_from_cells()
	board._sync_mount_socket()
	var edge_after: Dictionary = shell._wall_segment_unit_edge(shell._wall_segment_by_id("work_back_wall"), 5)
	assert_ne(edge_after.key, edge_before.key, "M/N wall edge data must follow the authored WallCell position.")
	assert_eq(board.global_position, board_before + Vector2(64, -32), "Wall-attached equipment must follow its WallCell Socket.")
	cell.visible = false
	assert_false(collision.disabled, "Hiding one Cell visual must not silently remove its collision.")
	cell.visible = true
	cell.position = cell_before
	wall._sync_group_from_cells()
	board._sync_mount_socket()
	assert_eq(board.global_position, board_before)

	var disabled_cell: Node2D = wall.get_node("WallCells/Cell00")
	var disabled_collision: CollisionPolygon2D = disabled_cell.get_node("CollisionBody/CollisionPolygon2D")
	var disabled_edge: Dictionary = shell._wall_segment_unit_edge(shell._wall_segment_by_id("work_back_wall"), 0)
	assert_true(shell._navigation_edge_sets().blocked.has(disabled_edge.key))
	disabled_cell.enabled = false
	wall._sync_group_from_cells()
	var disabled_navigation: Dictionary = shell._navigation_edge_sets()
	assert_true(disabled_collision.disabled)
	assert_false(disabled_navigation.blocked.has(disabled_edge.key), "A disabled WallCell must not remain blocked in N/Playable navigation.")
	assert_false(disabled_navigation.passable.has(disabled_edge.key))
	disabled_cell.enabled = true
	wall._sync_group_from_cells()
	assert_false(disabled_collision.disabled)

	var opening_wall = shell.get_node("Walls/WorkFrontSharedWall")
	var work_opening_cell: Node2D = opening_wall.get_node("WallCells/Cell06")
	var opening_marker = shell.get_node("Openings/WorkRoomOpening")
	var opening_cell_before := work_opening_cell.position
	var opening_start_before: Vector2 = opening_marker.world_start()
	var opening_end_before: Vector2 = opening_marker.world_end()
	var opening_delta := Vector2(16, 8)
	work_opening_cell.position += opening_delta
	opening_wall._sync_group_from_cells()
	assert_eq(opening_marker.world_start(), opening_start_before + opening_delta)
	assert_eq(opening_marker.world_end(), opening_end_before + opening_delta)
	var moved_opening_segment: Dictionary = shell._wall_segment_by_id("work_front_shared_wall")
	assert_eq(moved_opening_segment.doorway_offset, 6, "Doorway indexing must come from Cell opening metadata, not marker coordinates.")
	var moved_opening_edge: Dictionary = shell._wall_segment_unit_edge(moved_opening_segment, 6)
	assert_true(shell._navigation_edge_sets().passable.has(moved_opening_edge.key))
	work_opening_cell.opening_passable = false
	opening_wall._sync_group_from_cells()
	var closed_static_navigation: Dictionary = shell._navigation_edge_sets()
	assert_true(closed_static_navigation.blocked.has(moved_opening_edge.key))
	assert_false(closed_static_navigation.passable.has(moved_opening_edge.key))
	work_opening_cell.opening_passable = true
	work_opening_cell.position = opening_cell_before
	opening_wall._sync_group_from_cells()
	assert_eq(opening_marker.world_start(), opening_start_before)
	assert_eq(opening_marker.world_end(), opening_end_before)

	for socket_case in [
		{
			"object_id": "wall_conduit",
			"wall_path": "Walls/WorkBackWall",
			"cell_path": "WallCells/Cell02",
		},
		{
			"object_id": "sea_horizon_poster",
			"wall_path": "Walls/LivingRightWall",
			"cell_path": "WallCells/Cell03",
		},
	]:
		var socket_wall = shell.get_node(socket_case.wall_path)
		var socket_cell: Node2D = socket_wall.get_node(socket_case.cell_path)
		var object_data: Dictionary = shell._object_data_by_id(socket_case.object_id)
		var anchor_before: Vector2 = shell._object_anchor_world_position(object_data)
		var socket_before: Vector2 = socket_cell.get_node("AttachmentSocket").global_position
		var socket_cell_before := socket_cell.position
		var test_delta := Vector2(16, 8)
		socket_cell.position += test_delta
		socket_wall._sync_group_from_cells()
		assert_eq(socket_cell.get_node("AttachmentSocket").global_position, socket_before + test_delta)
		assert_eq(shell._object_anchor_world_position(object_data), anchor_before + test_delta, "%s must read its WallCell Socket directly." % socket_case.object_id)
		socket_cell.position = socket_cell_before
		socket_wall._sync_group_from_cells()
		assert_eq(shell._object_anchor_world_position(object_data), anchor_before)

	for opening_path in [
		"Walls/EntranceWall/WallCells/Cell04",
		"Walls/EntranceInnerWall/WallCells/Cell01",
		"Walls/WorkFrontSharedWall/WallCells/Cell06",
		"Walls/BathroomRightWall/WallCells/Cell02",
	]:
		var opening_cell = shell.get_node(opening_path)
		assert_eq(opening_cell.opening_kind, 1)
		assert_true(opening_cell.get_node("CollisionBody/CollisionPolygon2D").disabled)
	var window_cell = shell.get_node("Walls/LivingRightWall/WallCells/Cell05")
	assert_eq(window_cell.opening_kind, 2)
	assert_false(window_cell.opening_passable)
	assert_false(window_cell.get_node("CollisionBody/CollisionPolygon2D").disabled)


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
