extends GutTest

const QUARTERVIEW_MAIN_SCENE := preload("res://scenes/QuarterviewMain.tscn")
const PHONE_ATLAS_TEXTURE: Texture2D = preload("res://assets/art/ui/atlases/ui_phone_atlas.png")


func test_room_interaction_opens_matching_panel_and_bed_candidate_with_input_lock() -> void:
	var main = _make_main()
	var payload := _payload("bed", "manual_end_day", "Bed")

	main.quarterview_room.interaction_requested.emit("bed", "focus", payload)

	assert_true(main.interaction_panel.visible, "Room interaction should open the candidate interaction panel.")
	assert_eq(main.focused_object_key, "bed")
	assert_eq(main.interaction_title_label.text, "Bed")
	_assert_room_locked(main)

	main._on_use_pressed()

	assert_false(main.interaction_panel.visible, "Opening the matching close-up should replace the interaction panel.")
	assert_true(main.bed_closeup_open, "Bed interaction should route to the Bed candidate.")
	assert_true(main.bed_closeup_panel.visible)
	_assert_room_locked(main)


func test_primary_action_routes_each_supported_object_to_its_candidate() -> void:
	var cases := [
		{"key": "desk", "role": "work_hub", "flag": "desk_closeup_open"},
		{"key": "power", "role": "power_management", "flag": "power_closeup_open"},
		{"key": "phone", "role": "phone_status", "flag": "phone_closeup_open"},
		{"key": "fridge", "role": "living_appliance", "flag": "kitchen_closeup_open"},
		{"key": "door", "role": "background_structure", "flag": "door_closeup_open"},
		{"key": "bed", "role": "manual_end_day", "flag": "bed_closeup_open"},
	]

	for test_case in cases:
		var main = _make_main()
		var key := String(test_case["key"])
		main.quarterview_room.interaction_requested.emit(key, "focus", _payload(key, String(test_case["role"]), key))
		main._on_use_pressed()

		assert_true(main.get(String(test_case["flag"])), "%s should route to %s." % [key, test_case["flag"]])
		assert_false(main.interaction_panel.visible, "%s candidate should replace the interaction panel." % key)
		_assert_room_locked(main)


func test_laptop_requires_active_job_before_hacking_entry_opens() -> void:
	var main = _make_main()
	main.quarterview_room.interaction_requested.emit("laptop", "focus", _payload("laptop", "laptop_job", "Laptop"))

	main._on_use_pressed()

	assert_false(main.hacking_entry_open, "Laptop must not open Hacking Entry without an active candidate job.")
	assert_true(main.interaction_panel.visible, "Blocked Hacking Entry should keep the interaction panel available.")
	_assert_room_locked(main)

	main.active_job_key = "maintenance_17_fragment"
	main.active_job_title = "maintenance_17_fragment 회수"
	main.active_job_payload = {"title": main.active_job_title}
	main._on_use_pressed()

	assert_true(main.hacking_entry_open, "Laptop should route to Hacking Entry after a candidate job is active.")
	assert_false(main.interaction_panel.visible)
	_assert_room_locked(main)


func test_interaction_cancel_button_closes_panel_and_unlocks_room() -> void:
	var main = _make_main()
	main.quarterview_room.interaction_requested.emit("desk", "focus", _payload("desk", "work_hub", "Desk"))
	var cancel_button := _find_button(main.interaction_panel, "취소")

	assert_not_null(cancel_button, "Candidate interaction panel should expose its connected cancel button.")
	cancel_button.pressed.emit()

	assert_false(main.interaction_panel.visible)
	_assert_room_unlocked(main)


func test_escape_closes_interaction_panel_and_unlocks_room() -> void:
	var main = _make_main()
	main.quarterview_room.interaction_requested.emit("desk", "focus", _payload("desk", "work_hub", "Desk"))

	main._unhandled_input(_key_event(KEY_ESCAPE))

	assert_false(main.interaction_panel.visible)
	_assert_room_unlocked(main)


func test_phone_close_button_connection_unlocks_room() -> void:
	var main = _make_main()
	main._unhandled_input(_key_event(KEY_P))
	var close_button := _find_button(main.phone_closeup_panel, "닫기")

	assert_not_null(close_button, "Phone candidate should expose a close button wired through close_requested.")
	close_button.pressed.emit()

	assert_false(main.phone_closeup_open)
	assert_false(main.phone_closeup_panel.visible)
	_assert_room_unlocked(main)


func test_phone_backdrop_closes_overlay_and_unlocks_room() -> void:
	var main = _make_main()
	main._unhandled_input(_key_event(KEY_P))

	main.phone_closeup_backdrop.gui_input.emit(_left_click_event())

	assert_false(main.phone_closeup_open)
	assert_false(main.phone_closeup_backdrop.visible)
	_assert_room_unlocked(main)


func test_phone_escape_closes_overlay_and_unlocks_room() -> void:
	var main = _make_main()
	main._unhandled_input(_key_event(KEY_P))

	main._unhandled_input(_key_event(KEY_ESCAPE))

	assert_false(main.phone_closeup_open)
	assert_false(main.phone_closeup_panel.visible)
	_assert_room_unlocked(main)


func test_each_candidate_close_button_unlocks_room() -> void:
	var cases := [
		{"open": "_open_desk_closeup", "source": "desk", "flag": "desk_closeup_open", "panel": "desk_closeup_panel"},
		{"open": "_open_power_closeup", "source": "power", "flag": "power_closeup_open", "panel": "power_closeup_panel"},
		{"open": "_open_phone_closeup", "source": "portable_phone", "flag": "phone_closeup_open", "panel": "phone_closeup_panel"},
		{"open": "_open_bed_closeup", "source": "bed", "flag": "bed_closeup_open", "panel": "bed_closeup_panel"},
		{"open": "_open_kitchen_closeup", "source": "fridge", "flag": "kitchen_closeup_open", "panel": "kitchen_closeup_panel"},
		{"open": "_open_door_closeup", "source": "apartment_exit", "flag": "door_closeup_open", "panel": "door_closeup_panel"},
		{"open": "_open_hacking_entry_candidate", "source": "laptop", "flag": "hacking_entry_open", "panel": "hacking_entry_panel"},
		{"open": "_open_day_result_candidate", "source": "", "flag": "day_result_open", "panel": "day_result_panel"},
	]

	for test_case in cases:
		var main = _make_main()
		if String(test_case["flag"]) == "hacking_entry_open":
			main.active_job_key = "maintenance_17_fragment"
			main.active_job_title = "maintenance_17_fragment 회수"
		if String(test_case["flag"]) == "day_result_open":
			main.call(String(test_case["open"]))
		else:
			main.call(String(test_case["open"]), String(test_case["source"]))
		var panel: Node = main.get(String(test_case["panel"]))
		var close_button := _find_button(panel, "닫기")

		assert_not_null(close_button, "%s should expose a connected close button." % test_case["flag"])
		close_button.pressed.emit()

		assert_false(main.get(String(test_case["flag"])), "%s close button should close its modal." % test_case["flag"])
		_assert_room_unlocked(main)


func test_desk_to_hacking_transition_keeps_room_locked_until_final_close() -> void:
	var main = _make_main()
	main._open_desk_closeup("desk")
	main.active_job_key = "maintenance_17_fragment"
	main.active_job_title = "maintenance_17_fragment 회수"

	main._open_hacking_entry_candidate("laptop")

	assert_false(main.desk_closeup_open)
	assert_true(main.hacking_entry_open)
	_assert_room_locked(main)

	main._hide_hacking_entry_candidate()
	_assert_room_unlocked(main)


func test_phone_key_is_gated_by_interaction_panel_and_does_not_duplicate_overlay() -> void:
	var main = _make_main()
	main.quarterview_room.interaction_requested.emit("desk", "focus", _payload("desk", "work_hub", "Desk"))

	main._unhandled_input(_key_event(KEY_P))

	assert_false(main.phone_closeup_open, "P must not open Phone while an interaction panel is active.")
	assert_true(main.interaction_panel.visible)

	main._hide_interaction_panel()
	main._unhandled_input(_key_event(KEY_P))
	var phone_instance_id: int = main.phone_closeup_panel.get_instance_id()
	main._unhandled_input(_key_event(KEY_P))

	assert_true(main.phone_closeup_open)
	assert_eq(main.phone_closeup_panel.get_instance_id(), phone_instance_id, "Repeated P must reuse the one Phone overlay.")
	assert_eq(
		_count_nodes_with_script(main, main.phone_closeup_panel.get_script()),
		1,
		"Repeated P must not create a second Phone candidate."
	)
	_assert_room_locked(main)


func test_phone_atlas_regions_share_the_imported_texture() -> void:
	var main = _make_main()
	var phone: PhoneScreenCandidate = main.phone_closeup_panel
	var region_names := [
		"PhoneScreenRegion",
		"PhoneFrameRegion",
		"PhoneBatteryRegion",
		"PhoneSignalRegion",
		"PhoneMessageRegion",
		"PhonePowerRegion",
	]

	assert_same(phone.atlas_texture, PHONE_ATLAS_TEXTURE)
	assert_null(phone.find_child("MissingPhoneAtlasPreview", true, false))
	for region_name in region_names:
		var texture_rect := phone.find_child(String(region_name), true, false) as TextureRect
		assert_not_null(texture_rect, "%s should remain in the composed Phone preview." % region_name)
		if texture_rect == null:
			continue
		var atlas_region := texture_rect.texture as AtlasTexture
		assert_not_null(atlas_region, "%s should keep using an AtlasTexture region." % region_name)
		if atlas_region != null:
			assert_same(atlas_region.atlas, PHONE_ATLAS_TEXTURE)


func test_phone_key_is_gated_by_each_other_candidate_modal() -> void:
	var cases := [
		{"open": "_open_desk_closeup", "source": "desk", "flag": "desk_closeup_open"},
		{"open": "_open_power_closeup", "source": "power", "flag": "power_closeup_open"},
		{"open": "_open_bed_closeup", "source": "bed", "flag": "bed_closeup_open"},
		{"open": "_open_kitchen_closeup", "source": "fridge", "flag": "kitchen_closeup_open"},
		{"open": "_open_door_closeup", "source": "door", "flag": "door_closeup_open"},
		{"open": "_open_hacking_entry_candidate", "source": "laptop", "flag": "hacking_entry_open"},
		{"open": "_open_day_result_candidate", "source": "", "flag": "day_result_open"},
	]

	for test_case in cases:
		var main = _make_main()
		if String(test_case["flag"]) == "hacking_entry_open":
			main.active_job_key = "maintenance_17_fragment"
			main.active_job_title = "maintenance_17_fragment 회수"
		if String(test_case["flag"]) == "day_result_open":
			main.call(String(test_case["open"]))
		else:
			main.call(String(test_case["open"]), String(test_case["source"]))

		main._unhandled_input(_key_event(KEY_P))

		assert_true(main.get(String(test_case["flag"])), "P must not close or replace %s." % test_case["flag"])
		assert_false(main.phone_closeup_open, "P must not stack Phone over %s." % test_case["flag"])
		_assert_room_locked(main)


func test_open_modal_blocks_other_room_interactions() -> void:
	var main = _make_main()
	main._unhandled_input(_key_event(KEY_P))
	var before_focus: String = main.focused_object_key

	main.quarterview_room.interaction_requested.emit("bed", "focus", _payload("bed", "manual_end_day", "Bed"))

	assert_true(main.phone_closeup_open)
	assert_false(main.interaction_panel.visible, "A room interaction must not stack a panel over an open modal.")
	assert_eq(main.focused_object_key, before_focus, "Blocked interaction must not replace modal focus state.")
	_assert_room_locked(main)


func _make_main():
	var main = QUARTERVIEW_MAIN_SCENE.instantiate()
	add_child_autofree(main)
	return main


func _payload(key: String, role: String, display_name: String) -> Dictionary:
	return {
		"key": key,
		"role": role,
		"display_name": display_name,
		"interaction_position": Vector2(640, 360),
		"approach_position": Vector2(640, 400),
		"click_area": Rect2(Vector2(600, 320), Vector2(80, 80)),
	}


func _key_event(keycode: Key) -> InputEventKey:
	var event := InputEventKey.new()
	event.keycode = keycode
	event.pressed = true
	return event


func _left_click_event() -> InputEventMouseButton:
	var event := InputEventMouseButton.new()
	event.button_index = MOUSE_BUTTON_LEFT
	event.pressed = true
	return event


func _find_button(root: Node, text: String) -> Button:
	if root is Button and root.text == text:
		return root
	for child in root.get_children():
		var result := _find_button(child, text)
		if result != null:
			return result
	return null


func _count_nodes_with_script(root: Node, target_script: Script) -> int:
	var count := 1 if root.get_script() == target_script else 0
	for child in root.get_children():
		count += _count_nodes_with_script(child, target_script)
	return count


func _assert_room_locked(main) -> void:
	assert_true(main.room_input_locked)
	assert_false(main.quarterview_room.is_room_input_enabled())


func _assert_room_unlocked(main) -> void:
	assert_false(main.room_input_locked)
	assert_true(main.quarterview_room.is_room_input_enabled())
