extends GutTest

const ENVIRONMENT_SCENE := preload("res://scenes/quarterview/QuarterviewApartmentEnvironment.tscn")
const CANDIDATE_SCENE := preload("res://scenes/quarterview/QuarterviewApartmentShellCandidate.tscn")
const PLAYABLE_SCENE := preload("res://scenes/quarterview/QuarterviewApartmentPlayable.tscn")


func test_design_and_playable_scenes_reuse_the_environment_authority() -> void:
	var candidate = CANDIDATE_SCENE.instantiate()
	add_child_autofree(candidate)
	assert_true(candidate.has_method("playable_object_data"))
	assert_not_null(candidate.get_node("EditableObjectNodes/Fridge"))

	var playable = PLAYABLE_SCENE.instantiate()
	add_child_autofree(playable)
	var gameplay = playable.get_node("Gameplay")
	assert_true(gameplay.external_environment_mode)
	assert_eq(gameplay.external_environment, playable)
	assert_eq(gameplay.object_definitions.size(), 7)
	assert_eq(gameplay.get_node("FloorLayer").get_child_count(), 0)
	assert_eq(gameplay.get_node("WallBackLayer").get_child_count(), 0)
	assert_eq(gameplay.get_node("WallSideLayer").get_child_count(), 0)
	assert_eq(gameplay.get_node("ObjectLayer").get_child_count(), 0)
	assert_eq(gameplay.get_node("ObjectBackLayer").get_child_count(), 0)

	var dependencies := Array(ResourceLoader.get_dependencies("res://scenes/quarterview/QuarterviewApartmentPlayable.tscn"))
	assert_true(_dependencies_contain(dependencies, "res://scenes/quarterview/QuarterviewApartmentEnvironment.tscn"))
	assert_true(_dependencies_contain(dependencies, "res://scenes/quarterview/QuarterviewRoom.tscn"))
	var shell_source := FileAccess.get_file_as_string("res://scenes/quarterview/QuarterviewApartmentShellCandidate.tscn")
	var playable_source := FileAccess.get_file_as_string("res://scenes/quarterview/QuarterviewApartmentPlayable.tscn")
	for forbidden_parent in ["parent=\"Floor\"", "parent=\"Walls", "parent=\"EditableObjectNodes"]:
		assert_false(shell_source.contains(forbidden_parent), "Shell must not store Environment child overrides: %s" % forbidden_parent)
		assert_false(playable_source.contains(forbidden_parent), "Playable must not store Environment child overrides: %s" % forbidden_parent)


func test_environment_manual_floor_fridge_and_wall_cells_propagate_to_both_wrappers() -> void:
	var environment = ENVIRONMENT_SCENE.instantiate()
	var candidate = CANDIDATE_SCENE.instantiate()
	var playable = PLAYABLE_SCENE.instantiate()
	add_child_autofree(environment)
	add_child_autofree(candidate)
	add_child_autofree(playable)
	for floor_name in ["EntranceFloor", "BathroomFloor", "LivingFloor", "WorkFloor"]:
		var expected := _tile_snapshot(environment.get_node("Floor/%s" % floor_name))
		assert_eq(_tile_snapshot(candidate.get_node("Floor/%s" % floor_name)), expected)
		assert_eq(_tile_snapshot(playable.get_node("Floor/%s" % floor_name)), expected)
	assert_true(environment.get_node("Floor/EntranceFloor").get_used_cells().has(Vector2i(-1, 7)))
	assert_true(environment.get_node("Floor/BathroomFloor").get_used_cells().has(Vector2i(-1, 3)))
	assert_true(environment.get_node("Floor/LivingFloor").get_used_cells().has(Vector2i(1, 4)))
	assert_true(environment.get_node("Floor/WorkFloor").get_used_cells().has(Vector2i(0, 0)))
	var expected_fridge: Node2D = environment.get_node("EditableObjectNodes/Fridge")
	assert_eq(expected_fridge.position, Vector2(1128, 186), "Preserve the user's Environment fridge root position.")
	assert_eq(expected_fridge.get_node("SelectionArea/SelectionPolygon").polygon.size(), 5)
	assert_eq(expected_fridge.get_node("InteractionArea/InteractionPolygon").position, Vector2(30, 25))
	for wrapper in [candidate, playable]:
		var fridge: Node2D = wrapper.get_node("EditableObjectNodes/Fridge")
		assert_eq(fridge.position, expected_fridge.position)
		assert_eq(fridge.get_node("SelectionArea/SelectionPolygon").polygon, expected_fridge.get_node("SelectionArea/SelectionPolygon").polygon)
		assert_eq(fridge.get_node("InteractionArea/InteractionPolygon").position, Vector2(30, 25))
		assert_eq(wrapper.get_node("Walls/WorkBackWall/WallCells/Cell05").position, environment.get_node("Walls/WorkBackWall/WallCells/Cell05").position)
	for object_path in ["SinkCounter", "DiningTable", "UpsUnit", "BathroomFixture", "ShoesSlippers"]:
		var expected_object: Node2D = environment.get_node("EditableObjectNodes/%s" % object_path)
		for wrapper in [candidate, playable]:
			var inherited_object: Node2D = wrapper.get_node("EditableObjectNodes/%s" % object_path)
			assert_eq(inherited_object.position, expected_object.position)
			assert_eq(inherited_object.get_node("Visual/VisualPreview").polygon, expected_object.get_node("Visual/VisualPreview").polygon)
			assert_eq(inherited_object.get_node("SelectionArea/SelectionPolygon").polygon, expected_object.get_node("SelectionArea/SelectionPolygon").polygon)
			assert_null(inherited_object.get_node_or_null("InteractionArea"))
			assert_null(inherited_object.get_node_or_null("UsePoint"))
	assert_null(environment.get_node_or_null("EditableObjectNodes/SinkCounterParentAnchor"))
	var microwave_path := "EditableObjectNodes/SinkCounter/AttachmentSockets/MicrowaveSocket/Microwave"
	for wrapper in [environment, candidate, playable]:
		var microwave: Node2D = wrapper.get_node(microwave_path)
		assert_eq(microwave.global_position, Vector2(996, 114))
		assert_eq(microwave.get_node("BasePoint").global_position, Vector2(996, 174))
		assert_eq(microwave.get_node("UsePoint").global_position, Vector2(996, 238))
	assert_false(playable._object_blocker_ids_for_cell(Vector2i(1, 9)).has("shoes_slippers"), "Shoes/slippers selection must not add an N/Playable blocker.")
	for blocker_point in [Vector2(996, 174), Vector2(868, 302), Vector2(804, 78)]:
		assert_false(playable.playable_is_walkable_world_point(blocker_point), "Environment BodyPolygon must block N/Playable movement.")


func test_fridge_sprite_uses_texture_bounds_without_changing_gameplay_geometry() -> void:
	var environment = ENVIRONMENT_SCENE.instantiate()
	add_child_autofree(environment)
	var fridge: Node2D = environment.get_node("EditableObjectNodes/Fridge")
	var sprite: Sprite2D = fridge.get_node("Visual/Sprite2D")
	var preview: Polygon2D = fridge.get_node("Visual/VisualPreview")
	var data: Dictionary = environment.playable_object_data("fridge")

	assert_not_null(sprite.texture)
	assert_eq(sprite.texture.get_size(), Vector2(1070, 1470))
	assert_eq(sprite.texture_filter, CanvasItem.TEXTURE_FILTER_NEAREST)
	assert_false(preview.visible, "VisualPreview must hide when the runtime Sprite2D texture is active.")
	assert_eq(data.visual_source, "SPRITE2D")
	assert_almost_eq(data.visual_size_px.x, 90.0, 0.01)
	assert_almost_eq(data.visual_size_px.y, 146.0, 0.01)
	assert_almost_eq(data.visual_center_world.x, 1136.0, 0.01)
	assert_almost_eq(data.visual_center_world.y, 190.0, 0.01)
	assert_almost_eq(sprite.global_position.y + sprite.get_rect().end.y * sprite.global_scale.y, data.base_point_world.y, 0.02)

	assert_eq(fridge.get_node("Body/BodyPolygon").position, Vector2(0, 38))
	assert_eq(fridge.get_node("SelectionArea").position, Vector2(8, 4))
	assert_eq(fridge.get_node("InteractionArea").position, Vector2(-56, 44))
	assert_eq(fridge.get_node("InteractionArea/InteractionPolygon").position, Vector2(30, 25))
	assert_eq(fridge.get_node("UsePoint").position, Vector2(-68, 84))


func test_playable_fridge_click_reuses_room_movement_and_focus_flow() -> void:
	var playable = PLAYABLE_SCENE.instantiate()
	add_child_autofree(playable)
	var gameplay = playable.get_node("Gameplay")
	var fridge: Resource = gameplay._get_definition("fridge")
	watch_signals(gameplay)

	var click_position: Vector2 = gameplay._get_object_position(fridge)
	assert_true(gameplay._external_selection_contains(fridge, click_position))
	gameplay._handle_left_click(click_position)
	assert_eq(gameplay.pending_focus_key, "fridge")
	assert_true(gameplay.player.has_active_target())

	gameplay.player.clear_move_target()
	gameplay.player.global_position = gameplay._get_object_approach_position(fridge)
	gameplay._update_pending_focus()
	assert_signal_emit_count(gameplay, "interaction_requested", 1)
	var parameters: Array = get_signal_parameters(gameplay, "interaction_requested")
	assert_eq(parameters[0], "fridge")
	assert_eq(parameters[2].get("key"), "fridge")


func test_fridge_y_sort_threshold_uses_base_point() -> void:
	var playable = PLAYABLE_SCENE.instantiate()
	add_child_autofree(playable)
	var fridge: Node2D = playable.get_node("EditableObjectNodes/Fridge")
	var player: CharacterBody2D = playable.get_node("Gameplay/PlayerLayer/Player")
	assert_eq(fridge.z_index, int(fridge.get_node("BasePoint").global_position.y))

	player.global_position.y = fridge.get_node("BasePoint").global_position.y - 16.0
	player._physics_process(0.0)
	assert_lt(player.z_index, fridge.z_index)
	player.global_position.y = fridge.get_node("BasePoint").global_position.y + 16.0
	player._physics_process(0.0)
	assert_gt(player.z_index, fridge.z_index)


func _dependencies_contain(dependencies: Array, expected_path: String) -> bool:
	for raw_dependency in dependencies:
		if String(raw_dependency).ends_with("::%s" % expected_path) or String(raw_dependency) == expected_path:
			return true
	return false


func _tile_snapshot(layer: TileMapLayer) -> Array[String]:
	var rows: Array[String] = []
	for cell in layer.get_used_cells():
		var atlas := layer.get_cell_atlas_coords(cell)
		rows.append("%d,%d:%d:%d,%d" % [cell.x, cell.y, layer.get_cell_source_id(cell), atlas.x, atlas.y])
	rows.sort()
	return rows
