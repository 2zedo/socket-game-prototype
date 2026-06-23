extends GutTest

const DEVICE_DEFINITION_SCRIPT := preload("res://scripts/resources/DeviceDefinition.gd")
const SURVIVAL_STATE_SCRIPT := preload("res://scripts/SurvivalState.gd")


func _make_state():
	var state = SURVIVAL_STATE_SCRIPT.new()
	autofree(state)
	state._ready()
	return state


func test_device_resource_values_match_day1_mvp() -> void:
	var laptop = SURVIVAL_STATE_SCRIPT.get_day1_device_definition("laptop")
	var communication = SURVIVAL_STATE_SCRIPT.get_day1_device_definition("communication_device")

	assert_not_null(laptop, "Laptop definition should load from Resource.")
	assert_not_null(communication, "Communication device definition should load from Resource.")
	assert_eq(laptop.outlet_slots, 2, "Laptop should occupy two outlet slots.")
	assert_almost_eq(laptop.drain_per_game_hour, 3.0, 0.001, "Laptop hourly drain should stay at the MVP value.")
	assert_almost_eq(communication.drain_per_game_hour, 2.0, 0.001, "Communication device hourly drain should stay at the MVP value.")


func test_connected_device_does_not_become_active_until_toggled() -> void:
	var state = _make_state()

	state.set_powered_devices(["laptop"])

	assert_true(state.is_day1_action_connected("laptop"), "Laptop should be connected after outlet placement.")
	assert_false(state.is_day1_action_active("laptop"), "Connecting a laptop should not automatically activate it.")

	var result = state.toggle_day1_action_active("laptop")

	assert_true(bool(result.get("success", false)), "Connected laptop should toggle on.")
	assert_true(state.is_day1_action_active("laptop"), "Laptop should be active only after the toggle.")

	state.set_powered_devices([])

	assert_false(state.is_day1_action_connected("laptop"), "Laptop should disconnect when outlet state is cleared.")
	assert_false(state.is_day1_action_active("laptop"), "Disconnecting a device should clear its active state.")


func test_active_drain_uses_sum_of_active_device_resources() -> void:
	var state = _make_state()

	state.set_powered_devices(["laptop", "communication_device"])
	state.toggle_day1_action_active("laptop")

	assert_almost_eq(state.get_active_power_drain_per_game_hour(), 3.0, 0.001, "Laptop-only active drain should be 3.0 per game hour.")

	state.toggle_day1_action_active("communication_device")

	assert_almost_eq(state.get_active_power_drain_per_game_hour(), 5.0, 0.001, "Laptop and communication drain should add together.")


func test_modal_pause_stops_active_power_drain() -> void:
	var state = _make_state()

	state.set_powered_devices(["laptop"])
	state.toggle_day1_action_active("laptop")
	var power_before_pause = state.current_power_units

	state.set_clock_paused_by_modal(true)
	state._process(10.0)

	assert_almost_eq(state.current_power_units, power_before_pause, 0.001, "Modal pause should stop active power drain.")

	state.set_clock_paused_by_modal(false)
	state._process(10.0)

	assert_true(state.current_power_units < power_before_pause, "Power should drain again after modal pause ends.")


func test_phone_battery_warning_rearms_after_recovery() -> void:
	var state = _make_state()
	var warnings: Array[String] = []
	state.phone_battery_warning.connect(func(message: String) -> void:
		warnings.append(message)
	)

	state.debug_set_phone_battery(21.0)
	state.debug_adjust_phone_battery(-5.0)

	assert_eq(warnings.size(), 1, "Crossing below 20% should warn once.")
	assert_eq(warnings[0], SURVIVAL_STATE_SCRIPT.PHONE_BATTERY_WARNING_MESSAGES[20], "The 20% warning message should be emitted.")

	state.debug_adjust_phone_battery(-1.0)

	assert_eq(warnings.size(), 1, "Staying below the same threshold should not repeat the warning.")

	state.debug_adjust_phone_battery(10.0)
	state.debug_adjust_phone_battery(-6.0)

	assert_eq(warnings.size(), 2, "Recovering above 20% and crossing downward again should rearm the warning.")
