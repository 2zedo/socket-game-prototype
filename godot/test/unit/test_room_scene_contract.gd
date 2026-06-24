extends GutTest

const ROOM_SCENE_CONTRACT_SCRIPT := preload("res://scripts/contracts/RoomSceneContract.gd")


func test_contract_can_be_instantiated() -> void:
	var contract = ROOM_SCENE_CONTRACT_SCRIPT.new()
	autofree(contract)

	assert_not_null(contract, "RoomSceneContract should instantiate as a lightweight skeleton.")


func test_contract_exposes_expected_signals() -> void:
	var contract = ROOM_SCENE_CONTRACT_SCRIPT.new()
	autofree(contract)
	var signal_names := _get_signal_names(contract)

	assert_true(signal_names.has("interaction_requested"), "Contract should expose interaction_requested.")
	assert_true(signal_names.has("nearest_interactable_changed"), "Contract should expose nearest_interactable_changed.")
	assert_true(signal_names.has("room_back_requested"), "Contract should expose room_back_requested.")
	assert_true(signal_names.has("debug_overlay_toggled"), "Contract should expose debug_overlay_toggled.")
	assert_true(signal_names.has("player_position_changed"), "Contract should expose player_position_changed.")
	assert_true(signal_names.has("room_ready"), "Contract should expose room_ready.")


func test_action_constants_match_contract_keys() -> void:
	var contract = ROOM_SCENE_CONTRACT_SCRIPT.new()
	autofree(contract)

	assert_eq(contract.ACTION_PRIMARY, "primary")
	assert_eq(contract.ACTION_INSPECT, "inspect")
	assert_eq(contract.ACTION_CLOSE, "close")
	assert_eq(contract.ACTION_DEBUG, "debug")


func test_noop_methods_are_safe_to_call() -> void:
	var contract = ROOM_SCENE_CONTRACT_SCRIPT.new()
	autofree(contract)

	contract.set_player_input_enabled(false)
	contract.set_player_input_enabled(true)
	contract.set_debug_overlay_enabled(true)
	contract.set_debug_overlay_enabled(false)
	contract.set_connected_devices(["laptop"])
	contract.set_active_devices(["laptop"])
	contract.set_device_visual_state("laptop", "on")
	contract.set_room_object_definitions([])
	contract.request_nearest_interaction()
	contract.set_player_position(Vector2(12, 34))
	contract.set_time_of_day_label("20:40")
	contract.show_room_message("message")
	contract.clear_room_message()

	assert_eq(typeof(contract.is_debug_overlay_enabled()), TYPE_BOOL)
	assert_eq(typeof(contract.get_nearest_interactable_key()), TYPE_STRING)
	assert_eq(typeof(contract.get_player_position()), TYPE_VECTOR2)


func test_make_interaction_payload_contains_contract_fields() -> void:
	var payload := ROOM_SCENE_CONTRACT_SCRIPT.make_interaction_payload("work", "laptop_job", "apartment_laptop", "on")

	assert_eq(payload.get("zone"), "work")
	assert_eq(payload.get("role"), "laptop_job")
	assert_eq(payload.get("future_source"), "apartment_laptop")
	assert_eq(payload.get("visual_state"), "on")


func _get_signal_names(node: Object) -> Array[String]:
	var names: Array[String] = []
	for signal_data in node.get_signal_list():
		names.append(str(signal_data.get("name", "")))
	return names
