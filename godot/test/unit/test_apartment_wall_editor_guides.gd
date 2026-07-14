extends GutTest

const SHELL_SCENE := preload("res://scenes/quarterview/QuarterviewApartmentShellCandidate.tscn")


func test_wall_junctions_merge_endpoints_and_ignore_straight_cell_seams() -> void:
	var shell = _make_shell()
	var segments: Array[Dictionary] = shell._wall_segments_from_scene_nodes()
	var active_edges: Array[Dictionary] = shell._active_wall_wire_edges(segments)
	var clusters: Array[Dictionary] = shell._wall_wire_endpoint_clusters(active_edges)
	var junctions: Array[Dictionary] = shell._wall_junctions_from_segments(segments)
	assert_eq(junctions.size(), 12, "Only cross-wall, non-collinear endpoints are junctions in the current authored apartment.")
	var expected_junction_positions := PackedVector2Array([
		Vector2(1124, -50), Vector2(1636, 206), Vector2(1508, 398), Vector2(1124, 590),
		Vector2(420, 238), Vector2(804, 46), Vector2(1380, 334), Vector2(548, 302),
		Vector2(612, 142), Vector2(740, 206), Vector2(868, 78), Vector2(932, 110),
	])
	for expected_position in expected_junction_positions:
		assert_true(_junctions_contain_position(junctions, expected_position, shell.WALL_JUNCTION_MERGE_TOLERANCE))
	var outer_count := 0
	var inner_count := 0
	var shared_three_count := 0
	for junction in junctions:
		assert_gte(int(junction.get("direction_count", 0)), 2)
		if String(junction.get("kind", "")) == "outer":
			outer_count += 1
		else:
			inner_count += 1
		if Array(junction.get("incidents", [])).size() >= 3:
			shared_three_count += 1
	assert_gt(outer_count, 0)
	assert_gt(inner_count, 0)
	assert_gt(shared_three_count, 0)

	var straight_seam: Vector2 = shell.get_node("Walls/WorkBackWall/WallCells/Cell00").world_end()
	for junction in junctions:
		assert_gt(Vector2(junction.get("position", Vector2.ZERO)).distance_to(straight_seam), shell.WALL_JUNCTION_MERGE_TOLERANCE)

	var wireframe = shell.get_node("WallWireframeLayer")
	var unique_vertical_count := (
		int(wireframe.call("command_count_with_prefix", "wall_endpoint_"))
		+ int(wireframe.call("command_count_with_prefix", "wall_junction_outer_"))
		+ int(wireframe.call("command_count_with_prefix", "wall_junction_inner_"))
	)
	assert_eq(unique_vertical_count, clusters.size(), "Every merged endpoint must draw one vertical boundary, never one per incident Cell.")
	assert_gt(int(wireframe.call("command_count_with_prefix", "wall_junction_marker_")), 0)

	var tall_segments: Array[Dictionary] = shell._wall_segments_from_scene_nodes()
	var tall_height: float = float(shell.wall_height) + 96.0
	var tall_endpoint := Vector2.ZERO
	for segment_index in range(tall_segments.size()):
		if String(tall_segments[segment_index].get("id", "")) != "work_back_wall":
			continue
		var tall_segment: Dictionary = tall_segments[segment_index]
		tall_segment["height"] = tall_height
		var first_edge: Dictionary = tall_segment.get("unit_edges", {}).get(0, {})
		tall_endpoint = Vector2(first_edge.get("from_world", Vector2.ZERO))
		tall_segments[segment_index] = tall_segment
		break
	var canvas_transform: Transform2D = shell.get_viewport().get_canvas_transform()
	var tall_screen_segments: Array[PackedVector2Array] = shell._wall_wire_screen_segments(tall_segments, canvas_transform)
	assert_true(_screen_segments_contain(
		tall_screen_segments,
		canvas_transform * tall_endpoint,
		canvas_transform * (tall_endpoint - Vector2(0.0, tall_height))
	), "Label collision wires must use the edited junction max_height, not the default wall height.")


func test_w_labels_stay_in_view_avoid_overlap_and_show_cell_detail_only_after_selection() -> void:
	var shell = _make_shell()
	shell._unhandled_input(_key_event(KEY_W))
	var group_rects: Array[Rect2] = shell.wall_screen_label_rects()
	assert_eq(group_rects.size(), 10, "Default W mode must show one label per active WallGroup.")
	_assert_label_rects_fit_without_overlap(shell, group_rects)
	_assert_label_rects_clear_wall_lines(shell, group_rects)
	_assert_label_text_is_clipped_to_measured_background(shell)
	assert_null(shell.get_node_or_null("DebugOverlayLayer/WallScreenLabels/wall_cell_detailBackground"))

	var selected_cell = shell.get_node("Walls/WorkBackWall/WallCells/Cell05")
	var click_world: Vector2 = (
		Vector2(selected_cell.call("world_start"))
		+ Vector2(selected_cell.call("world_end"))
	) * 0.5
	assert_true(shell._select_wall_cell_at(click_world))
	assert_eq(String(shell.debug_focus_wall_cell_path), String(selected_cell.get_path()))
	var detail_background = shell.get_node("DebugOverlayLayer/WallScreenLabels/wall_cell_detailBackground")
	var detail_label: Label = detail_background.get_node("wall_cell_detail")
	assert_true(detail_label.text.contains("WorkBackWall / Cell05"))
	assert_true(detail_label.text.contains("enabled=true"))
	assert_true(detail_label.text.contains("Opening=NONE"))
	assert_true(detail_label.text.contains("AttachmentSocket=Cell05/AttachmentSocket"))
	var focused_rects: Array[Rect2] = shell.wall_screen_label_rects()
	_assert_label_rects_fit_without_overlap(shell, focused_rects)
	_assert_label_rects_clear_wall_lines(shell, focused_rects)
	var focused_label_count: int = shell.get_node("DebugOverlayLayer/WallScreenLabels").get_child_count()
	shell._redraw_reveal_sensitive_layers()
	shell._redraw_reveal_sensitive_layers()
	assert_eq(shell.get_node("DebugOverlayLayer/WallScreenLabels").get_child_count(), focused_label_count, "Reveal refresh must replace W labels instead of appending duplicate Controls.")
	_assert_label_rects_fit_without_overlap(shell, shell.wall_screen_label_rects())

	var occupied: Array[Rect2] = [Rect2(Vector2.ZERO, Vector2(100.0, 100.0))]
	var no_segments: Array[PackedVector2Array] = []
	var impossible: Rect2 = shell._resolve_wall_label_rect(
		Rect2(Vector2.ZERO, Vector2(90.0, 90.0)),
		Rect2(Vector2(10.0, 10.0), Vector2(90.0, 90.0)),
		Rect2(Vector2.ZERO, Vector2(100.0, 100.0)),
		occupied,
		no_segments
	)
	assert_true(impossible.size.is_zero_approx(), "An impossible viewport must omit the label instead of knowingly drawing an overlap.")


func test_editor_guide_modes_have_distinct_policies_and_preserve_scene_geometry() -> void:
	var shell = _make_shell()
	var guides = shell.get_node("EditorGuides")
	var expected := {
		shell.EditorGuideMode.CLEAN: {"room": false, "wall": false, "object": true, "object_geometry": false, "height_socket": false},
		shell.EditorGuideMode.STRUCTURE: {"room": true, "wall": true, "object": true, "object_geometry": false, "height_socket": false},
		shell.EditorGuideMode.OBJECT: {"room": false, "wall": false, "object": true, "object_geometry": true, "height_socket": true},
		shell.EditorGuideMode.ALL: {"room": true, "wall": true, "object": true, "object_geometry": true, "height_socket": true},
	}
	for guide_mode in expected:
		assert_eq(guides.guide_visibility_for_mode(guide_mode), expected[guide_mode])

	var fridge: Node2D = shell.get_node("EditableObjectNodes/Fridge")
	var wall_cell: Node2D = shell.get_node("Walls/WorkBackWall/WallCells/Cell05")
	var fridge_position_before := fridge.position
	var fridge_body_before: PackedVector2Array = fridge.get_node("Body/BodyPolygon").polygon.duplicate()
	var wall_position_before := wall_cell.position
	var wall_end_before: Vector2 = wall_cell.end_offset
	var selected_nodes: Array[Node] = [fridge]
	var clean_signature: String = guides._guide_signature(shell, selected_nodes, shell.EditorGuideMode.CLEAN, "")
	var object_signature: String = guides._guide_signature(shell, selected_nodes, shell.EditorGuideMode.OBJECT, "fridge")
	assert_ne(clean_signature, object_signature, "Mode/focus changes must invalidate generated guides immediately.")

	for guide_mode in [shell.EditorGuideMode.CLEAN, shell.EditorGuideMode.STRUCTURE, shell.EditorGuideMode.OBJECT, shell.EditorGuideMode.ALL]:
		guides._apply_guide_visibility(shell, guide_mode)
	assert_false(guides.visible, "Runtime instances must keep the entire EditorGuides root hidden regardless of Inspector mode.")
	assert_eq(fridge.position, fridge_position_before)
	assert_eq(fridge.get_node("Body/BodyPolygon").polygon, fridge_body_before)
	assert_eq(wall_cell.position, wall_position_before)
	assert_eq(wall_cell.end_offset, wall_end_before)

	guides._rebuild_object_guides(shell, selected_nodes, shell.EditorGuideMode.OBJECT, "fridge")
	assert_not_null(guides.get_node_or_null("ObjectGuides/Object_Fridge"))
	assert_not_null(guides.get_node_or_null("ObjectGuides/Body_Fridge"))
	assert_not_null(guides.get_node_or_null("ObjectGuides/Selection_FridgeDash000"))
	assert_not_null(guides.get_node_or_null("ObjectGuides/Interaction_FridgeDash000"))
	assert_null(guides.get_node_or_null("ObjectGuides/Object_Bed"), "OBJECT focus must suppress unrelated custom object guides.")
	var no_selection: Array[Node] = []
	guides._rebuild_wall_guides(shell, no_selection, shell.EditorGuideMode.STRUCTURE)
	assert_not_null(guides.get_node_or_null("WallGuides/WorkBackWall_Cell05SocketHorizontal"))
	guides._rebuild_height_and_socket_guides(shell, no_selection, shell.EditorGuideMode.OBJECT, "fridge")
	assert_not_null(guides.get_node_or_null("HeightAndSocketGuides/SelectedBaseHorizontal"))
	assert_not_null(guides.get_node_or_null("HeightAndSocketGuides/SelectedTopVertical"))
	guides._rebuild_height_and_socket_guides(shell, no_selection, shell.EditorGuideMode.ALL, "fridge")
	assert_not_null(guides.get_node_or_null("HeightAndSocketGuides/FridgeBaseHorizontal"))
	assert_not_null(guides.get_node_or_null("HeightAndSocketGuides/BedTopVertical"), "ALL must show height guides for every editable object, not only the focus id.")


func _assert_label_rects_fit_without_overlap(shell, rects: Array[Rect2]) -> void:
	var bounds: Rect2 = shell._wall_label_viewport_bounds()
	for rect_index in range(rects.size()):
		assert_true(bounds.encloses(rects[rect_index]), "W label %d must remain inside the viewport safe bounds." % rect_index)
		for other_index in range(rect_index + 1, rects.size()):
				assert_false(rects[rect_index].intersects(rects[other_index], true), "W labels %d and %d must not overlap." % [rect_index, other_index])


func _assert_label_rects_clear_wall_lines(shell, rects: Array[Rect2]) -> void:
	var screen_segments: Array[PackedVector2Array] = shell._wall_wire_screen_segments(
		shell._wall_segments_from_scene_nodes(),
		shell.get_viewport().get_canvas_transform()
	)
	for rect_index in range(rects.size()):
		assert_false(
			shell._wall_screen_rect_intersects_segments(rects[rect_index].grow(2.0), screen_segments),
			"W label %d must not cover a wall base, top, or endpoint wire." % rect_index
		)


func _assert_label_text_is_clipped_to_measured_background(shell) -> void:
	for background_value in shell.get_node("DebugOverlayLayer/WallScreenLabels").get_children():
		var background := background_value as ColorRect
		if background == null or background.get_child_count() == 0:
			continue
		var label := background.get_child(0) as Label
		assert_not_null(label)
		assert_true(label.clip_text)
		var font_size := label.get_theme_font_size("font_size")
		var measured := ThemeDB.fallback_font.get_multiline_string_size(label.text, HORIZONTAL_ALIGNMENT_LEFT, -1.0, font_size)
		assert_gte(background.size.x + 0.01, measured.x + 20.0)
		assert_gte(background.size.y + 0.01, measured.y + 12.0)


func _junctions_contain_position(junctions: Array[Dictionary], expected: Vector2, tolerance: float) -> bool:
	for junction in junctions:
		if Vector2(junction.get("position", Vector2.ZERO)).distance_to(expected) <= tolerance:
			return true
	return false


func _screen_segments_contain(segments: Array[PackedVector2Array], expected_from: Vector2, expected_to: Vector2) -> bool:
	for segment in segments:
		if segment.size() >= 2 and segment[0].is_equal_approx(expected_from) and segment[1].is_equal_approx(expected_to):
			return true
	return false


func _make_shell():
	var shell = SHELL_SCENE.instantiate()
	add_child_autoqfree(shell)
	return shell


func _key_event(keycode: Key) -> InputEventKey:
	var event := InputEventKey.new()
	event.keycode = keycode
	event.pressed = true
	return event
