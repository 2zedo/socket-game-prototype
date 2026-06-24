extends GutTest

const DEVICE_DEFINITION_SCRIPT := preload("res://scripts/resources/DeviceDefinition.gd")
const DEVICE_DIR := "res://resources/devices"


func test_device_resources_exist() -> void:
	var paths := _get_device_resource_paths()

	assert_true(paths.size() > 0, "DeviceDefinition Resource files should exist.")


func test_all_device_resources_are_valid_device_definitions() -> void:
	var seen_keys := {}

	for path in _get_device_resource_paths():
		var definition = load(path)

		assert_not_null(definition, "%s should load." % path)
		assert_eq(definition.get_script(), DEVICE_DEFINITION_SCRIPT, "%s should use DeviceDefinition.gd." % path)
		assert_false(definition.device_key.is_empty(), "%s device_key should not be empty." % path)
		assert_false(definition.display_name.is_empty(), "%s display_name should not be empty." % path)
		assert_true(definition.outlet_slots >= 1, "%s outlet_slots should be at least 1." % path)
		assert_true(definition.drain_per_game_hour >= 0.0, "%s drain_per_game_hour should be non-negative." % path)
		assert_false(definition.result_flag.is_empty(), "%s result_flag should not be empty." % path)
		assert_false(seen_keys.has(definition.device_key), "Duplicate device_key found: %s" % definition.device_key)
		seen_keys[definition.device_key] = true


func test_day1_core_device_values_match_current_resources() -> void:
	var laptop = load("res://resources/devices/laptop.tres")
	var communication = load("res://resources/devices/communication_device.tres")
	var charger = load("res://resources/devices/charger.tres")

	assert_not_null(laptop, "Laptop Resource should load.")
	assert_not_null(communication, "Communication Device Resource should load.")
	assert_not_null(charger, "Charger Resource should load.")
	assert_eq(laptop.outlet_slots, 2, "Laptop should keep the current 2-slot pressure.")
	assert_almost_eq(laptop.drain_per_game_hour, 3.0, 0.001, "Laptop hourly drain should stay at the current value.")
	assert_almost_eq(communication.drain_per_game_hour, 2.0, 0.001, "Communication Device hourly drain should stay at the current value.")
	assert_almost_eq(charger.drain_per_game_hour, 1.0, 0.001, "Charger hourly drain should stay at the current value.")


func _get_device_resource_paths() -> Array[String]:
	var paths: Array[String] = []
	var dir := DirAccess.open(DEVICE_DIR)
	if dir == null:
		return paths

	for file_name in dir.get_files():
		if file_name.ends_with(".tres"):
			paths.append("%s/%s" % [DEVICE_DIR, file_name])

	paths.sort()
	return paths
