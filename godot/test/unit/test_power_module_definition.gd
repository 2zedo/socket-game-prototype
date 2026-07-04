extends GutTest

const POWER_MODULE_DEFINITION_SCRIPT := preload("res://scripts/resources/PowerModuleDefinition.gd")
const POWER_MODULE_DIR := "res://resources/rooms/quarterview/power_modules"


func test_valid_definition_requires_identity_and_shape() -> void:
	var definition = POWER_MODULE_DEFINITION_SCRIPT.new()
	definition.key = "small_core"
	definition.display_name = "Small Core"
	definition.role = POWER_MODULE_DEFINITION_SCRIPT.ROLE_POWER_MODULE
	var single_cell_shape: Array[Vector2i] = [Vector2i.ZERO]
	definition.shape_cells = single_cell_shape

	assert_true(definition.is_valid_definition(), "A module with key/display_name/role/shape should be valid.")

	definition.key = ""
	assert_false(definition.is_valid_definition(), "A missing key should invalidate the definition.")

	definition.key = "small_core"
	definition.display_name = ""
	assert_false(definition.is_valid_definition(), "A missing display_name should invalidate the definition.")

	definition.display_name = "Small Core"
	definition.role = ""
	assert_false(definition.is_valid_definition(), "A missing role should invalidate the definition.")

	definition.role = POWER_MODULE_DEFINITION_SCRIPT.ROLE_POWER_MODULE
	var empty_shape: Array[Vector2i] = []
	definition.shape_cells = empty_shape
	assert_false(definition.is_valid_definition(), "An empty shape should invalidate the definition.")


func test_shape_helpers_use_cell_bounds() -> void:
	var definition = POWER_MODULE_DEFINITION_SCRIPT.new()
	var shape_cells: Array[Vector2i] = [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1)]
	definition.shape_cells = shape_cells

	assert_eq(definition.get_size_cells(), Vector2i(2, 2), "Shape bounds should produce a 2x2 size.")
	assert_eq(definition.get_shape_label(), "L-shape 3 cells", "Non-rectangular 2x2/3-cell shapes should read as L-shape.")


func test_shape_rotation_normalizes_l_shape() -> void:
	var shape_cells: Array[Vector2i] = [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1)]
	var rotated_cells := POWER_MODULE_DEFINITION_SCRIPT.rotate_shape_cells_clockwise(shape_cells)
	var expected_rotated: Array[Vector2i] = [Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 1)]

	assert_eq(rotated_cells, expected_rotated, "A clockwise L-shape rotation should normalize to positive cells.")


func test_shape_rotation_returns_to_original_after_four_turns() -> void:
	var shape_cells: Array[Vector2i] = [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1)]
	var rotated_cells := POWER_MODULE_DEFINITION_SCRIPT.normalize_shape_cells(shape_cells)

	for _index in range(4):
		rotated_cells = POWER_MODULE_DEFINITION_SCRIPT.rotate_shape_cells_clockwise(rotated_cells)

	assert_eq(
		rotated_cells,
		POWER_MODULE_DEFINITION_SCRIPT.normalize_shape_cells(shape_cells),
		"Four normalized rotations should return to the original shape."
	)


func test_candidate_action_and_effect_label_have_fallbacks() -> void:
	var definition = POWER_MODULE_DEFINITION_SCRIPT.new()
	definition.key = "comm_module"

	assert_eq(definition.get_candidate_action(), "place_comm_module_noop", "Candidate action should default from key.")
	assert_eq(definition.get_effect_label(), "효과 후보 없음", "Empty labels should use an effect fallback.")

	definition.mock_power_label = "통신 유지"
	definition.mock_heat_label = "과부하 낮음"
	definition.bonus_label = "신호 보정 후보"

	assert_eq(
		definition.get_effect_label(),
		"통신 유지 / 과부하 낮음 / 신호 보정 후보",
		"Effect label should combine mock labels in a stable order."
	)


func test_power_module_resources_are_valid_and_unique() -> void:
	var paths := _get_power_module_resource_paths()
	var seen_keys := {}

	assert_true(paths.size() > 0, "Quarterview power module Resource files should exist.")

	for path in paths:
		var definition = load(path)
		var file_stem := path.get_file().get_basename()

		assert_not_null(definition, "%s should load." % path)
		assert_eq(definition.get_script(), POWER_MODULE_DEFINITION_SCRIPT, "%s should use PowerModuleDefinition.gd." % path)
		assert_true(definition.is_valid_definition(), "%s should be a valid PowerModuleDefinition." % path)
		assert_eq(definition.key, file_stem, "%s key should match its file name." % path)
		assert_false(seen_keys.has(definition.key), "Duplicate power module key found: %s" % definition.key)
		seen_keys[definition.key] = true


func test_odd_efficiency_module_is_l_shape_candidate() -> void:
	var definition = load("%s/odd_efficiency_module.tres" % POWER_MODULE_DIR)

	assert_not_null(definition, "odd_efficiency_module should load.")
	assert_eq(definition.get_shape_cells().size(), 3, "Odd efficiency module should use three occupied cells.")
	assert_eq(definition.get_size_cells(), Vector2i(2, 2), "Odd efficiency module should occupy a 2x2 bounding area.")
	assert_eq(definition.get_shape_label(), "L-shape 3 cells", "Odd efficiency module should be presented as an L-shape.")
	assert_true(definition.description.contains("L-shape"), "Odd efficiency description should mention the L-shape candidate.")


func _get_power_module_resource_paths() -> Array[String]:
	var paths: Array[String] = []
	var dir := DirAccess.open(POWER_MODULE_DIR)
	if dir == null:
		return paths

	for file_name in dir.get_files():
		if file_name.ends_with(".tres"):
			paths.append("%s/%s" % [POWER_MODULE_DIR, file_name])

	paths.sort()
	return paths
