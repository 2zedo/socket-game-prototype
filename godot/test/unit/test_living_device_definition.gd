extends GutTest

const LIVING_DEVICE_DEFINITION_SCRIPT := preload("res://scripts/resources/LivingDeviceDefinition.gd")


func test_valid_definition_requires_identity_and_power_policy() -> void:
	var definition = _make_valid_definition()

	assert_true(definition.is_valid_definition(), "A complete living device definition should be valid.")

	definition.device_key = ""
	assert_false(definition.is_valid_definition(), "A missing device_key should invalidate the definition.")

	definition = _make_valid_definition()
	definition.display_name = ""
	assert_false(definition.is_valid_definition(), "A missing display_name should invalidate the definition.")

	definition = _make_valid_definition()
	definition.room_object_key = ""
	assert_false(definition.is_valid_definition(), "A missing room_object_key should invalidate the definition.")

	definition = _make_valid_definition()
	definition.device_type = ""
	assert_false(definition.is_valid_definition(), "A missing device_type should invalidate the definition.")

	definition = _make_valid_definition()
	definition.power_model = LIVING_DEVICE_DEFINITION_SCRIPT.POWER_DEDICATED_CIRCUIT
	definition.uses_dedicated_circuit = false
	assert_false(definition.is_valid_definition(), "A dedicated-circuit model should declare dedicated circuit usage.")


func test_type_helpers_follow_type_and_power_model() -> void:
	var continuous = _make_valid_definition()
	assert_true(continuous.is_continuous(), "Continuous devices should report continuous behavior.")
	assert_false(continuous.is_instant(), "Continuous devices should not report instant behavior by default.")

	var instant = _make_valid_definition()
	instant.device_type = LIVING_DEVICE_DEFINITION_SCRIPT.TYPE_INSTANT
	instant.power_model = LIVING_DEVICE_DEFINITION_SCRIPT.POWER_INSTANT
	assert_true(instant.is_instant(), "Instant devices should report instant behavior.")

	var storage = _make_valid_definition()
	storage.device_type = LIVING_DEVICE_DEFINITION_SCRIPT.TYPE_STORAGE
	storage.power_model = LIVING_DEVICE_DEFINITION_SCRIPT.POWER_STORAGE
	assert_true(storage.is_storage(), "Storage devices should report storage behavior.")

	var fixture = _make_valid_definition()
	fixture.device_type = LIVING_DEVICE_DEFINITION_SCRIPT.TYPE_BACKGROUND_FIXTURE
	fixture.power_model = LIVING_DEVICE_DEFINITION_SCRIPT.POWER_PASSIVE
	assert_true(fixture.is_background_fixture(), "Background fixtures should report fixture behavior.")


func test_power_helpers_return_candidate_costs() -> void:
	var definition = _make_valid_definition()
	definition.uses_outlet_slot = true
	definition.drain_per_game_hour = 0.5
	definition.instant_power_cost = 0.7

	assert_true(definition.uses_direct_outlet(), "uses_direct_outlet should reflect outlet slot policy.")
	assert_false(definition.uses_room_circuit(), "Outlet-slot devices should not imply dedicated circuit use.")
	assert_almost_eq(definition.get_drain_per_game_hour(), 0.5, 0.001, "Drain helper should return hourly drain.")
	assert_almost_eq(definition.get_power_cost_for_use(), 0.7, 0.001, "Use-cost helper should return instant power cost.")

	definition.uses_dedicated_circuit = true
	assert_true(definition.uses_room_circuit(), "Dedicated circuit flag should mark room circuit use.")


func test_effect_summary_uses_stable_effect_keys() -> void:
	var definition = _make_valid_definition()
	definition.comfort_delta = 1.0
	definition.fatigue_delta = -0.5
	definition.focus_delta = 0.25
	definition.food_preservation_delta = 2.0

	var summary: Dictionary = definition.get_effect_summary()

	assert_almost_eq(summary[LIVING_DEVICE_DEFINITION_SCRIPT.EFFECT_COMFORT], 1.0, 0.001, "Comfort effect should be included.")
	assert_almost_eq(summary[LIVING_DEVICE_DEFINITION_SCRIPT.EFFECT_FATIGUE], -0.5, 0.001, "Fatigue effect should be included.")
	assert_almost_eq(summary[LIVING_DEVICE_DEFINITION_SCRIPT.EFFECT_FOCUS], 0.25, 0.001, "Focus effect should be included.")
	assert_almost_eq(summary[LIVING_DEVICE_DEFINITION_SCRIPT.EFFECT_FOOD_PRESERVATION], 2.0, 0.001, "Food preservation effect should be included.")


func test_result_text_uses_custom_text_or_fallback() -> void:
	var definition = _make_valid_definition()

	assert_eq(definition.get_result_text(true), "Device was active.", "Active fallback text should be stable.")
	assert_eq(definition.get_result_text(false), "Device was inactive.", "Inactive fallback text should be stable.")

	definition.active_result_text = "The fridge stayed cold."
	definition.inactive_result_text = "The fridge was left off."

	assert_eq(definition.get_result_text(true), "The fridge stayed cold.", "Custom active text should be returned.")
	assert_eq(definition.get_result_text(false), "The fridge was left off.", "Custom inactive text should be returned.")


func test_debug_summary_includes_living_device_contract_fields() -> void:
	var definition = _make_valid_definition()
	definition.device_key = "fridge"
	definition.room_object_key = "fridge"
	definition.device_type = LIVING_DEVICE_DEFINITION_SCRIPT.TYPE_CONTINUOUS
	definition.power_model = LIVING_DEVICE_DEFINITION_SCRIPT.POWER_CONTINUOUS
	definition.drain_per_game_hour = 0.5
	definition.instant_power_cost = 0.0

	var summary: String = definition.get_debug_summary()

	assert_true(summary.contains("fridge"), "Debug summary should include device_key.")
	assert_true(summary.contains("room=fridge"), "Debug summary should include room_object_key.")
	assert_true(summary.contains("type=continuous"), "Debug summary should include device_type.")
	assert_true(summary.contains("power=continuous"), "Debug summary should include power_model.")
	assert_true(summary.contains("drain=0.50"), "Debug summary should include formatted drain.")


func _make_valid_definition() -> Resource:
	var definition = LIVING_DEVICE_DEFINITION_SCRIPT.new()
	definition.device_key = "fridge"
	definition.display_name = "Fridge"
	definition.room_object_key = "fridge"
	definition.device_type = LIVING_DEVICE_DEFINITION_SCRIPT.TYPE_CONTINUOUS
	definition.power_model = LIVING_DEVICE_DEFINITION_SCRIPT.POWER_CONTINUOUS
	definition.drain_per_game_hour = 0.5
	return definition
