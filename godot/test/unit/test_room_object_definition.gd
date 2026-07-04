extends GutTest

const ROOM_OBJECT_DEFINITION_SCRIPT := preload("res://scripts/resources/RoomObjectDefinition.gd")
const OBJECT_DIR := "res://resources/rooms/quarterview/objects"


func test_valid_definition_requires_stable_identity_fields() -> void:
	var definition = ROOM_OBJECT_DEFINITION_SCRIPT.new()
	definition.key = "laptop"
	definition.display_name = "Laptop"
	definition.zone = ROOM_OBJECT_DEFINITION_SCRIPT.ZONE_WORK
	definition.role = ROOM_OBJECT_DEFINITION_SCRIPT.ROLE_LAPTOP_JOB

	assert_true(definition.is_valid_definition(), "A definition with key/display_name/zone/role should be valid.")

	definition.key = ""
	assert_false(definition.is_valid_definition(), "A missing key should invalidate the definition.")
	definition.key = "laptop"
	definition.display_name = ""
	assert_false(definition.is_valid_definition(), "A missing display_name should invalidate the definition.")
	definition.display_name = "Laptop"
	definition.zone = ""
	assert_false(definition.is_valid_definition(), "A missing zone should invalidate the definition.")
	definition.zone = ROOM_OBJECT_DEFINITION_SCRIPT.ZONE_WORK
	definition.role = ""
	assert_false(definition.is_valid_definition(), "A missing role should invalidate the definition.")


func test_collision_size_uses_size_as_default() -> void:
	var definition = ROOM_OBJECT_DEFINITION_SCRIPT.new()
	definition.size = Vector2(80, 40)

	assert_eq(definition.get_collision_size(), Vector2(80, 40), "Zero collision_size should fall back to size.")

	definition.collision_size = Vector2(32, 24)

	assert_eq(definition.get_collision_size(), Vector2(32, 24), "Explicit collision_size should be used.")


func test_hover_visual_fields_are_optional_by_default() -> void:
	var definition = ROOM_OBJECT_DEFINITION_SCRIPT.new()

	assert_eq(definition.hover_label, "", "Hover label should default to display_name fallback.")
	assert_eq(definition.hover_priority, 0, "Hover priority should default to z/sort fallback.")
	assert_null(definition.base_visual_texture, "Base visual texture should be optional.")
	assert_null(definition.hover_overlay_texture, "Hover overlay texture should be optional.")
	assert_eq(definition.hover_overlay_offset, Vector2.ZERO, "Hover overlay offset should be neutral by default.")
	assert_eq(definition.hover_overlay_scale, Vector2.ONE, "Hover overlay scale should default to one.")
	assert_eq(definition.hover_overlay_z_index, 0, "Hover overlay z-index should be neutral by default.")
	assert_eq(definition.hover_visual_mode, "fallback_outline", "Hover visual mode should default to fallback outline.")


func test_debug_summary_includes_contract_fields() -> void:
	var definition = ROOM_OBJECT_DEFINITION_SCRIPT.new()
	definition.key = "node17"
	definition.zone = ROOM_OBJECT_DEFINITION_SCRIPT.ZONE_WORK
	definition.role = ROOM_OBJECT_DEFINITION_SCRIPT.ROLE_MYSTERY_DEVICE
	definition.future_source = "future_node17"
	definition.visual_state = ROOM_OBJECT_DEFINITION_SCRIPT.STATE_SIGNAL

	var summary := definition.get_debug_summary()

	assert_true(summary.contains("node17"), "Debug summary should include key.")
	assert_true(summary.contains("zone=work"), "Debug summary should include zone.")
	assert_true(summary.contains("role=mystery_device"), "Debug summary should include role.")
	assert_true(summary.contains("future=future_node17"), "Debug summary should include future_source.")
	assert_true(summary.contains("state=signal"), "Debug summary should include visual_state.")


func test_primary_label_defaults_follow_role_contract() -> void:
	var cases := {
		ROOM_OBJECT_DEFINITION_SCRIPT.ROLE_MANUAL_END_DAY: "Rest / End Day",
		ROOM_OBJECT_DEFINITION_SCRIPT.ROLE_LAPTOP_JOB: "Open Work",
		ROOM_OBJECT_DEFINITION_SCRIPT.ROLE_POWER_MANAGEMENT: "Open Power",
		ROOM_OBJECT_DEFINITION_SCRIPT.ROLE_COMMUNICATION: "Check Signal",
		ROOM_OBJECT_DEFINITION_SCRIPT.ROLE_MYSTERY_DEVICE: "Inspect NODE",
		ROOM_OBJECT_DEFINITION_SCRIPT.ROLE_PHONE_STATUS: "Open Phone",
		ROOM_OBJECT_DEFINITION_SCRIPT.ROLE_PHONE_CHARGE: "Check Charge",
		ROOM_OBJECT_DEFINITION_SCRIPT.ROLE_AUDIO_HACKING_DEVICE: "Check Audio",
		ROOM_OBJECT_DEFINITION_SCRIPT.ROLE_LIVING_APPLIANCE: "Inspect Appliance",
		ROOM_OBJECT_DEFINITION_SCRIPT.ROLE_SUPPORT_DEVICE: "Inspect Device",
		ROOM_OBJECT_DEFINITION_SCRIPT.ROLE_BACKGROUND_STRUCTURE: "Inspect",
		"unknown": "Interact",
	}

	for role in cases.keys():
		var definition = ROOM_OBJECT_DEFINITION_SCRIPT.new()
		definition.role = role

		assert_eq(definition.get_primary_label(), cases[role], "%s should map to its expected primary label." % role)


func test_room_object_resources_are_valid_and_unique() -> void:
	var paths := _get_room_object_resource_paths()
	var seen_keys := {}

	assert_true(paths.size() > 0, "Quarterview room object Resource files should exist.")

	for path in paths:
		var definition = load(path)
		var file_stem := path.get_file().get_basename()

		assert_not_null(definition, "%s should load." % path)
		assert_eq(definition.get_script(), ROOM_OBJECT_DEFINITION_SCRIPT, "%s should use RoomObjectDefinition.gd." % path)
		assert_true(definition.is_valid_definition(), "%s should be a valid RoomObjectDefinition." % path)
		assert_eq(definition.key, file_stem, "%s key should match its file name." % path)
		assert_false(seen_keys.has(definition.key), "Duplicate room object key found: %s" % definition.key)
		seen_keys[definition.key] = true


func test_key_room_object_roles_match_contract() -> void:
	var bed = load("res://resources/rooms/quarterview/objects/bed.tres")
	var laptop = load("res://resources/rooms/quarterview/objects/laptop.tres")
	var power = load("res://resources/rooms/quarterview/objects/power.tres")
	var speaker = load("res://resources/rooms/quarterview/objects/speaker.tres")
	var bathroom_door = load("res://resources/rooms/quarterview/objects/bathroom_door.tres")

	assert_eq(bed.role, ROOM_OBJECT_DEFINITION_SCRIPT.ROLE_MANUAL_END_DAY, "Bed should remain the manual end-day object.")
	assert_eq(laptop.role, ROOM_OBJECT_DEFINITION_SCRIPT.ROLE_LAPTOP_JOB, "Laptop should remain the work/job entry object.")
	assert_eq(power.role, ROOM_OBJECT_DEFINITION_SCRIPT.ROLE_POWER_MANAGEMENT, "Power should remain the power management object.")
	assert_eq(speaker.role, ROOM_OBJECT_DEFINITION_SCRIPT.ROLE_AUDIO_HACKING_DEVICE, "Speaker should remain an audio hacking device, not decoration.")
	assert_true(
		bathroom_door.role in [
			ROOM_OBJECT_DEFINITION_SCRIPT.ROLE_BACKGROUND_STRUCTURE,
			ROOM_OBJECT_DEFINITION_SCRIPT.ROLE_BACKGROUND_LIFE_HINT,
		],
		"Bathroom door should remain a background structure/life hint."
	)


func _get_room_object_resource_paths() -> Array[String]:
	var paths: Array[String] = []
	var dir := DirAccess.open(OBJECT_DIR)
	if dir == null:
		return paths

	for file_name in dir.get_files():
		if file_name.ends_with(".tres"):
			paths.append("%s/%s" % [OBJECT_DIR, file_name])

	paths.sort()
	return paths
