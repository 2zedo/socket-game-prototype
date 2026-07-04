extends GutTest

const POWER_BOARD_CANDIDATE_SCRIPT := preload("res://scripts/ui/quarterview/PowerBoardCandidate.gd")


func test_inventory_order_removes_placed_module_and_appends_returned_module() -> void:
	var board = _make_board()

	assert_eq(
		board.inventory_order,
		["small_core", "laptop_adapter", "comm_module", "odd_efficiency_module"],
		"Initial inventory order should follow loaded module order."
	)

	board._set_module_placed_on_board("small_core", Vector2i(0, 0), 2)
	board._rebuild_module_views()

	assert_false(board.inventory_order.has("small_core"), "A placed module should disappear from inventory order.")

	board._return_module_to_inventory("small_core", false)

	assert_eq(board.inventory_order[-1], "small_core", "A returned module should be appended to the bottom of inventory.")
	assert_false(board._is_module_placed("small_core"), "Returned module should no longer be placed.")
	assert_eq(board._get_module_rotation("small_core"), 0, "Returning to inventory should reset runtime rotation.")


func test_inventory_rows_follow_inventory_order_without_placed_modules() -> void:
	var board = _make_board()

	board._rebuild_module_views()
	assert_eq(
		board._get_visible_inventory_module_keys(),
		["small_core", "laptop_adapter", "comm_module", "odd_efficiency_module"],
		"Initial visible inventory rows should follow inventory order."
	)

	board._set_module_placed_on_board("laptop_adapter", Vector2i(2, 0), 0)
	board._rebuild_module_views()
	assert_eq(
		board._get_visible_inventory_module_keys(),
		["small_core", "comm_module", "odd_efficiency_module"],
		"Placed modules should disappear from visible inventory rows."
	)

	board._return_module_to_inventory("laptop_adapter", false)
	assert_eq(
		board._get_visible_inventory_module_keys(),
		["small_core", "comm_module", "odd_efficiency_module", "laptop_adapter"],
		"Returned modules should appear at the bottom of visible inventory rows."
	)


func test_click_candidate_only_selects_without_starting_drag_or_placing() -> void:
	var board = _make_board()
	var button: Button = board.module_buttons["small_core"]
	var mouse_global := button.global_position + Vector2(8, 8)

	board._begin_drag_candidate("small_core", mouse_global)
	assert_eq(board.pending_drag_module_key, "small_core", "Mouse down should create only a pending drag candidate.")
	assert_eq(board.dragging_module_key, "", "Mouse down alone should not start an active drag.")

	board._finish_pending_click("small_core")
	assert_eq(board.pending_drag_module_key, "", "Click release should clear the pending drag.")
	assert_false(board._is_module_placed("small_core"), "Click-only selection should not place the module.")
	assert_eq(
		board.inventory_order,
		["small_core", "laptop_adapter", "comm_module", "odd_efficiency_module"],
		"Click-only selection should not mutate inventory order."
	)


func test_drop_anchor_uses_grabbed_shape_cell_for_l_shape() -> void:
	var board = _make_board()
	board.drag_grabbed_shape_cell = Vector2i(1, 0)
	var grid_origin: Vector2 = board._get_grid_global_rect().position
	var mouse_global: Vector2 = grid_origin + Vector2(4.2 * 50.0, 3.2 * 40.0)

	assert_eq(
		board._get_drop_anchor_for_mouse(mouse_global),
		Vector2i(3, 3),
		"Hover anchor should be mouse grid cell minus the grabbed occupied shape cell."
	)


func test_can_place_module_ignores_self_but_blocks_other_modules() -> void:
	var board = _make_board()

	board._set_module_placed_on_board("odd_efficiency_module", Vector2i(0, 0), 0)

	assert_true(
		board.can_place_module("odd_efficiency_module", Vector2i(0, 0), 1, "odd_efficiency_module"),
		"A placed module rotation should ignore its own previous occupied cells."
	)

	board._set_module_placed_on_board("small_core", Vector2i(1, 1), 0)

	assert_false(
		board.can_place_module("odd_efficiency_module", Vector2i(0, 0), 1, "odd_efficiency_module"),
		"The same rotation should become invalid when a different module occupies the rotated shape."
	)


func test_invalid_rotation_preserves_previous_rotation_index() -> void:
	var board = _make_board()

	board._set_module_placed_on_board("odd_efficiency_module", Vector2i(0, 0), 0)
	board._set_module_placed_on_board("small_core", Vector2i(1, 1), 0)
	board._select_module("odd_efficiency_module", false)

	board._rotate_module("odd_efficiency_module")

	assert_eq(board._get_module_rotation("odd_efficiency_module"), 0, "Invalid rotation should roll back to previous rotation.")
	assert_eq(board._get_module_grid_anchor("odd_efficiency_module"), Vector2i(0, 0), "Invalid rotation should keep the original grid anchor.")


func test_invalid_drop_restores_drag_snapshot_and_inventory_order() -> void:
	var board = _make_board()

	board._set_module_placed_on_board("laptop_adapter", Vector2i(2, 0), 0)
	var snapshot_order: Array[String] = board.inventory_order.duplicate()

	board._capture_drag_start_state("laptop_adapter")
	var state: Dictionary = board._get_module_state("laptop_adapter")
	state["is_placed"] = false
	state["grid_anchor"] = Vector2i(-1, -1)
	state["rotation_index"] = 2
	board._set_module_state("laptop_adapter", state)
	board.inventory_order.append("laptop_adapter")
	board.drag_grabbed_shape_cell = Vector2i(1, 0)

	board._restore_module_to_drag_origin("laptop_adapter")

	assert_true(board._is_module_placed("laptop_adapter"), "Invalid drop should restore placed state.")
	assert_eq(board._get_module_grid_anchor("laptop_adapter"), Vector2i(2, 0), "Invalid drop should restore grid anchor.")
	assert_eq(board._get_module_rotation("laptop_adapter"), 0, "Invalid drop should restore rotation.")
	assert_eq(board.inventory_order, snapshot_order, "Invalid drop should restore inventory order exactly.")
	assert_eq(board.drag_grabbed_shape_cell, Vector2i.ZERO, "Invalid drop should restore the grabbed shape cell from the snapshot.")


func _make_board():
	var board = POWER_BOARD_CANDIDATE_SCRIPT.new()
	add_child_autofree(board)
	return board
