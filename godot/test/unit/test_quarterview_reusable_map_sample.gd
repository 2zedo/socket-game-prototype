extends GutTest

const ENVIRONMENT_SCENE := preload("res://scenes/quarterview/samples/QuarterviewReusableMapSampleEnvironment.tscn")
const SHELL_SCENE := preload("res://scenes/quarterview/samples/QuarterviewReusableMapSampleShell.tscn")
const PLAYABLE_SCENE := preload("res://scenes/quarterview/samples/QuarterviewReusableMapSamplePlayable.tscn")
const WALL_SEGMENT_SCENE_PATH := "res://scenes/quarterview/environment/ApartmentWallSegment.tscn"


func test_sample_environment_reuses_authored_component_contracts() -> void:
	var environment: Node2D = ENVIRONMENT_SCENE.instantiate()
	add_child_autofree(environment)
	var snapshot: Dictionary = environment.sample_contract_snapshot()
	assert_eq(snapshot.floor_layers, 2)
	assert_eq(snapshot.floor_cells, 25)
	assert_eq(snapshot.room_areas, 2)
	assert_eq(snapshot.wall_groups, 5)
	assert_eq(snapshot.wall_cells, 24)
	assert_eq(snapshot.openings, 3)
	assert_eq(snapshot.objects, 2)
	assert_eq(snapshot.interactive_ids, ["bed"])
	for wall_group: Node in environment.get_node("Walls").get_children():
		assert_true(wall_group is ApartmentWallSegment)
		assert_eq(wall_group.scene_file_path, WALL_SEGMENT_SCENE_PATH)
	var dependencies := Array(ResourceLoader.get_dependencies(
		"res://scenes/quarterview/samples/QuarterviewReusableMapSampleEnvironment.tscn"
	))
	assert_true(_dependencies_contain(dependencies, WALL_SEGMENT_SCENE_PATH))

	var room_a_floor: TileMapLayer = environment.get_node("Floor/RoomAFloor")
	var room_b_floor: TileMapLayer = environment.get_node("Floor/RoomBFloor")
	assert_eq(room_a_floor.get_used_cells().size(), 13)
	assert_true(room_a_floor.get_used_cells().has(Vector2i(-1, 2)))
	assert_eq(room_b_floor.get_used_cells().size(), 12)
	assert_eq(environment.get_node("RoomAreas/RoomAArea/Area2D/CollisionPolygon2D").polygon.size(), 4)
	assert_eq(environment.get_node("RoomAreas/RoomBArea/Area2D/CollisionPolygon2D").polygon.size(), 4)

	var internal_door: Node = environment.get_node("Openings/InternalDoorOpening")
	var external_door: Node = environment.get_node("Openings/ExternalDoorOpening")
	var window: Node = environment.get_node("Openings/WindowOpening")
	assert_true(bool(internal_door.passable))
	assert_true(bool(external_door.passable))
	assert_false(bool(window.passable))
	assert_eq(String(internal_door.owner_wall_id), "sample_shared_wall")
	assert_eq(String(external_door.owner_wall_id), "sample_left_wall")
	assert_eq(String(window.owner_wall_id), "sample_top_wall")


func test_sample_object_geometry_is_scene_node_authority() -> void:
	var environment: Node2D = ENVIRONMENT_SCENE.instantiate()
	add_child_autofree(environment)
	var bed: Node2D = environment.get_node("EditableObjectNodes/SampleBed")
	var table: Node2D = environment.get_node("EditableObjectNodes/SampleDiningTable")
	var bed_data: Dictionary = environment.playable_object_data("bed")
	var table_data: Dictionary = environment.playable_object_data("dining_table")

	assert_eq(bed_data.geometry_source, "SCENE_NODE")
	assert_eq(bed_data.node_path, String(bed.get_path()))
	assert_eq(Array(bed_data.collision_polygons).size(), 1)
	assert_eq(Array(bed_data.selection_polygons).size(), 1)
	assert_eq(Array(bed_data.interaction_polygons).size(), 1)
	assert_eq(Array(bed_data.use_points_world).size(), 1)
	assert_not_null(bed.get_node_or_null("Body/BodyPolygon"))
	assert_not_null(bed.get_node_or_null("InteractionArea/InteractionPolygon"))
	assert_not_null(bed.get_node_or_null("UsePoint"))

	assert_eq(table_data.geometry_source, "SCENE_NODE")
	assert_eq(table_data.node_path, String(table.get_path()))
	assert_eq(Array(table_data.collision_polygons).size(), 1)
	assert_eq(Array(table_data.selection_polygons).size(), 1)
	assert_eq(Array(table_data.interaction_polygons), [])
	assert_eq(Array(table_data.use_points_world), [])
	assert_null(table.get_node_or_null("InteractionArea"))
	assert_null(table.get_node_or_null("UsePoint"))
	assert_not_null(table.get_node_or_null("AttachmentSockets/AccessorySocket"))


func test_sample_path_crosses_only_passable_door_cells() -> void:
	var environment: Node2D = ENVIRONMENT_SCENE.instantiate()
	add_child_autofree(environment)
	var room_a_start: Vector2 = environment._cell_center(Vector2i(0, 2))
	var room_b_target: Vector2 = environment._cell_center(Vector2i(3, 2))
	var threshold_target: Vector2 = environment._cell_center(Vector2i(-1, 2))
	assert_gt(environment.playable_find_path(room_a_start, room_b_target).size(), 0)
	assert_gt(environment.playable_find_path(room_a_start, threshold_target).size(), 0)

	var solid_shared_from: Vector2 = environment._cell_center(Vector2i(2, 0))
	var solid_shared_to: Vector2 = environment._cell_center(Vector2i(3, 0))
	var door_from: Vector2 = environment._cell_center(Vector2i(2, 1))
	var door_to: Vector2 = environment._cell_center(Vector2i(3, 1))
	var window_inside: Vector2 = environment._cell_center(Vector2i(4, 0))
	var window_outside: Vector2 = environment._cell_center(Vector2i(4, -1))
	assert_true(environment._segment_crosses_blocking_wall(solid_shared_from, solid_shared_to))
	assert_false(environment._segment_crosses_blocking_wall(door_from, door_to))
	assert_true(environment._segment_crosses_blocking_wall(window_inside, window_outside))


func test_sample_body_blocking_uses_active_scene_collision_state() -> void:
	var environment: Node2D = ENVIRONMENT_SCENE.instantiate()
	add_child_autofree(environment)
	var table: Node2D = environment.get_node("EditableObjectNodes/SampleDiningTable")
	var table_body: CollisionPolygon2D = table.get_node("Body/BodyPolygon")
	var table_cell: Vector2i = environment._world_to_floor_cell(table.global_position)
	assert_true(table.body_collision_active())
	assert_true(environment._body_blocks_cell(table_cell))
	assert_true(bool(environment.playable_object_data("dining_table").blocks_movement))

	table_body.disabled = true
	assert_false(table.body_collision_active())
	assert_false(environment._body_blocks_cell(table_cell))
	var disabled_data: Dictionary = environment.playable_object_data("dining_table")
	assert_false(bool(disabled_data.blocks_movement))
	assert_eq(Array(disabled_data.collision_polygons), [])
	assert_eq(Array(disabled_data.floor_polygons), [])


func test_wall_segment_instance_synchronizes_opening_from_edited_cell() -> void:
	var environment: Node2D = ENVIRONMENT_SCENE.instantiate()
	add_child_autofree(environment)
	var wall: ApartmentWallSegment = environment.get_node("Walls/SharedWall")
	var cell: Node2D = wall.get_node("WallCells/Cell01")
	var opening: Node2D = environment.get_node("Openings/InternalDoorOpening")
	var original_position := cell.position
	var original_passable := bool(cell.opening_passable)

	cell.position += Vector2(8, -4)
	cell.opening_passable = false
	wall._sync_group_from_cells()
	assert_eq(opening.start_point.global_position, cell.world_start())
	assert_eq(opening.end_point.global_position, cell.world_end())
	assert_false(bool(opening.passable))

	cell.position = original_position
	cell.opening_passable = original_passable
	wall._sync_group_from_cells()
	assert_eq(opening.start_point.global_position, cell.world_start())
	assert_true(bool(opening.passable))


func test_sample_shell_and_playable_inherit_environment_without_geometry_overrides() -> void:
	var environment: Node2D = ENVIRONMENT_SCENE.instantiate()
	var shell: Node2D = SHELL_SCENE.instantiate()
	var playable: Node2D = PLAYABLE_SCENE.instantiate()
	add_child_autofree(environment)
	add_child_autofree(shell)
	add_child_autofree(playable)

	for floor_name in ["RoomAFloor", "RoomBFloor"]:
		var expected: Array[String] = _tile_snapshot(environment.get_node("Floor/%s" % floor_name))
		assert_eq(_tile_snapshot(shell.get_node("Floor/%s" % floor_name)), expected)
		assert_eq(_tile_snapshot(playable.get_node("Floor/%s" % floor_name)), expected)
	for wrapper in [shell, playable]:
		assert_eq(wrapper.get_node("Walls/SharedWall/WallCells/Cell01").position, environment.get_node("Walls/SharedWall/WallCells/Cell01").position)
		assert_eq(wrapper.get_node("EditableObjectNodes/SampleBed").position, environment.get_node("EditableObjectNodes/SampleBed").position)
		assert_eq(wrapper.get_node("EditableObjectNodes/SampleDiningTable").position, environment.get_node("EditableObjectNodes/SampleDiningTable").position)

	var shell_source := FileAccess.get_file_as_string("res://scenes/quarterview/samples/QuarterviewReusableMapSampleShell.tscn")
	var playable_source := FileAccess.get_file_as_string("res://scenes/quarterview/samples/QuarterviewReusableMapSamplePlayable.tscn")
	for forbidden_parent in ["parent=\"Floor", "parent=\"RoomAreas", "parent=\"Walls", "parent=\"Openings", "parent=\"EditableObjectNodes"]:
		assert_false(shell_source.contains(forbidden_parent))
		assert_false(playable_source.contains(forbidden_parent))
	var shell_dependencies := Array(ResourceLoader.get_dependencies("res://scenes/quarterview/samples/QuarterviewReusableMapSampleShell.tscn"))
	var playable_dependencies := Array(ResourceLoader.get_dependencies("res://scenes/quarterview/samples/QuarterviewReusableMapSamplePlayable.tscn"))
	assert_true(_dependencies_contain(shell_dependencies, "res://scenes/quarterview/samples/QuarterviewReusableMapSampleEnvironment.tscn"))
	assert_true(_dependencies_contain(playable_dependencies, "res://scenes/quarterview/samples/QuarterviewReusableMapSampleEnvironment.tscn"))
	assert_true(_dependencies_contain(playable_dependencies, "res://scenes/quarterview/QuarterviewRoom.tscn"))


func test_sample_playable_filters_ghost_apartment_interactions_and_reuses_click_flow() -> void:
	var playable: Node2D = PLAYABLE_SCENE.instantiate()
	add_child_autofree(playable)
	var gameplay: Node = playable.get_node("Gameplay")
	assert_true(bool(gameplay.external_environment_mode))
	assert_eq(gameplay.external_environment, playable)
	assert_eq(gameplay.object_definitions.size(), 1)
	assert_eq(String(gameplay.object_definitions[0].key), "bed")
	watch_signals(gameplay)

	var bed_definition: Resource = gameplay._get_definition("bed")
	var bed_data: Dictionary = playable.playable_object_data("bed")
	var click_position: Vector2 = Vector2(bed_data.visual_center_world)
	assert_true(gameplay._external_selection_contains(bed_definition, click_position))
	gameplay._handle_left_click(click_position)
	assert_eq(gameplay.pending_focus_key, "bed")
	assert_true(gameplay.player.has_active_target())

	gameplay.player.clear_move_target()
	gameplay.player.global_position = Vector2(Array(bed_data.use_points_world)[0])
	gameplay._update_pending_focus()
	assert_signal_emit_count(gameplay, "interaction_requested", 1)
	var parameters: Array = get_signal_parameters(gameplay, "interaction_requested")
	assert_eq(parameters[0], "bed")


func test_sample_debug_modes_and_wall_visibility_cycle_do_not_disable_collision() -> void:
	var shell: Node2D = SHELL_SCENE.instantiate()
	add_child_autofree(shell)
	for key in [&"P", &"M", &"N", &"W"]:
		shell.set_debug_overlay(key, true)
	var state: Dictionary = shell.debug_overlay_state()
	assert_true(bool(state.P))
	assert_true(bool(state.M))
	assert_true(bool(state.N))
	assert_true(bool(state.W))

	var cell: Node = shell.get_node("Walls/OuterTopWall/WallCells/Cell00")
	var collision: CollisionPolygon2D = cell.get_node("CollisionBody/CollisionPolygon2D")
	assert_false(collision.disabled)
	shell.cycle_wall_inspection_mode()
	assert_eq(shell.wall_inspection_mode_name(), "TRANSPARENT")
	assert_almost_eq(float(cell.get_node("Visual").modulate.a), 0.18, 0.01)
	assert_false(collision.disabled)
	shell.cycle_wall_inspection_mode()
	assert_eq(shell.wall_inspection_mode_name(), "HIDDEN")
	assert_false(cell.get_node("Visual").visible)
	assert_false(collision.disabled)
	shell.cycle_wall_inspection_mode()
	assert_eq(shell.wall_inspection_mode_name(), "NORMAL")
	assert_true(cell.get_node("Visual").visible)

	var guides: Node = shell.get_node("EditorGuides")
	assert_eq(guides.guide_visibility_for_mode(0), {"room": false, "wall": false, "object": true, "object_geometry": false, "height_socket": false})
	assert_true(bool(guides.guide_visibility_for_mode(1).wall))
	assert_true(bool(guides.guide_visibility_for_mode(2).object_geometry))
	assert_true(bool(guides.guide_visibility_for_mode(3).height_socket))


func _tile_snapshot(layer: TileMapLayer) -> Array[String]:
	var result: Array[String] = []
	for cell in layer.get_used_cells():
		var atlas := layer.get_cell_atlas_coords(cell)
		result.append("%d,%d:%d:%d,%d" % [cell.x, cell.y, layer.get_cell_source_id(cell), atlas.x, atlas.y])
	result.sort()
	return result


func _dependencies_contain(dependencies: Array, expected_path: String) -> bool:
	for raw_dependency: Variant in dependencies:
		var dependency := String(raw_dependency)
		if dependency == expected_path or dependency.ends_with("::%s" % expected_path):
			return true
	return false
