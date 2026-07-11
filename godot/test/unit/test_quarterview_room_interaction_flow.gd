extends GutTest

const QUARTERVIEW_ROOM_SCENE := preload("res://scenes/quarterview/QuarterviewRoom.tscn")


func test_click_sets_pending_focus_and_emits_focus_only_after_arrival() -> void:
	var room = _make_room()
	var definition: Resource = room._get_definition("desk")
	watch_signals(room)

	room._handle_left_click(room._get_object_position(definition))

	assert_eq(room.pending_focus_key, "desk", "Clicking Desk should set it as the pending interaction focus.")
	assert_true(room.player.has_active_target(), "Clicking Desk should start a deterministic movement path.")
	assert_signal_emit_count(room, "interaction_requested", 0, "Interaction must not emit before the player arrives.")

	room.player.clear_move_target()
	room.player.global_position = room._get_object_approach_position(definition)
	room._update_pending_focus()

	assert_signal_emit_count(room, "interaction_requested", 1, "Arrival should emit exactly one interaction request.")
	var parameters: Array = get_signal_parameters(room, "interaction_requested")
	assert_eq(parameters[0], "desk")
	assert_eq(parameters[1], room.ACTION_FOCUS)
	var payload: Dictionary = parameters[2]
	assert_eq(payload.get("key"), "desk")
	assert_eq(payload.get("role"), definition.role)
	assert_eq(payload.get("approach_position"), room._get_object_approach_position(definition))
	assert_eq(room.pending_focus_key, "", "Emitting the interaction should consume pending focus.")


func test_disabling_room_input_cancels_pending_interaction_without_stale_emit() -> void:
	var room = _make_room()
	var definition: Resource = room._get_definition("desk")
	watch_signals(room)

	room._handle_left_click(room._get_object_position(definition))
	assert_eq(room.pending_focus_key, "desk")

	room.set_room_input_enabled(false)
	room.player.global_position = room._get_object_approach_position(definition)
	room.set_room_input_enabled(true)
	room._update_pending_focus()

	assert_eq(room.pending_focus_key, "", "Input cancellation should clear pending focus.")
	assert_false(room.player.has_active_target(), "Input cancellation should clear the active movement path.")
	assert_signal_emit_count(room, "interaction_requested", 0, "Cancelled focus must never emit after a later arrival.")


func test_floor_click_cancels_pending_interaction_without_stale_emit() -> void:
	var room = _make_room()
	var definition: Resource = room._get_definition("desk")
	watch_signals(room)

	room._handle_left_click(room._get_object_position(definition))
	assert_eq(room.pending_focus_key, "desk")

	room._handle_left_click(Vector2(-10000, -10000))
	room.player.clear_move_target()
	room.player.global_position = room._get_object_approach_position(definition)
	room._update_pending_focus()

	assert_eq(room.pending_focus_key, "", "A floor or non-object click should cancel the previous pending focus.")
	assert_signal_emit_count(room, "interaction_requested", 0, "A cancelled object must not emit after reaching its old approach point.")


func test_selecting_another_object_replaces_pending_focus_without_stale_emit() -> void:
	var room = _make_room()
	var desk: Resource = room._get_definition("desk")
	var power: Resource = room._get_definition("power")
	watch_signals(room)

	room._handle_left_click(room._get_object_position(desk))
	assert_eq(room.pending_focus_key, "desk")

	room._handle_left_click(room._get_object_position(power))
	assert_eq(room.pending_focus_key, "power", "A new object selection should replace the old pending focus.")
	assert_signal_emit_count(room, "interaction_requested", 0, "Replacing a target must not emit the previous interaction.")

	room.player.clear_move_target()
	room.player.global_position = room._get_object_approach_position(power)
	room._update_pending_focus()

	assert_signal_emit_count(room, "interaction_requested", 1)
	var parameters: Array = get_signal_parameters(room, "interaction_requested")
	assert_eq(parameters[0], "power", "Only the most recently selected object may emit.")
	assert_eq(parameters[2].get("key"), "power")


func _make_room():
	var room = QUARTERVIEW_ROOM_SCENE.instantiate()
	add_child_autofree(room)
	return room
