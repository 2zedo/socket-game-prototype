extends GutTest

const QUARTERVIEW_JOB_DEFINITION_SCRIPT := preload("res://scripts/resources/QuarterviewJobDefinition.gd")
const QUARTERVIEW_JOB_DIR := "res://resources/rooms/quarterview/jobs"


func test_valid_definition_requires_identity_and_related_object() -> void:
	var definition = QUARTERVIEW_JOB_DEFINITION_SCRIPT.new()
	definition.key = "maintenance_17_fragment"
	definition.title = "maintenance_17_fragment 회수"
	definition.sender_label = "익명 의뢰"
	definition.related_object_key = "laptop"

	assert_true(definition.is_valid_definition(), "A job with key/title/sender/related object should be valid.")

	definition.key = ""
	assert_false(definition.is_valid_definition(), "A missing key should invalidate the definition.")

	definition.key = "maintenance_17_fragment"
	definition.title = ""
	assert_false(definition.is_valid_definition(), "A missing title should invalidate the definition.")

	definition.title = "maintenance_17_fragment 회수"
	definition.sender_label = ""
	assert_false(definition.is_valid_definition(), "A missing sender should invalidate the definition.")

	definition.sender_label = "익명 의뢰"
	definition.related_object_key = ""
	assert_false(definition.is_valid_definition(), "A missing related object should invalidate the definition.")


func test_status_and_payload_use_candidate_values() -> void:
	var definition = QUARTERVIEW_JOB_DEFINITION_SCRIPT.new()
	definition.key = "maintenance_17_fragment"
	definition.title = "maintenance_17_fragment 회수"
	definition.sender_label = "익명 의뢰"
	definition.summary = "폐쇄 유지보수 로그 조각 회수 후보."
	definition.reward_label = "45 GC"
	definition.risk_label = "낮음"
	definition.related_object_key = "laptop"

	var pending_payload: Dictionary = definition.to_candidate_payload(false)
	assert_eq(pending_payload["status_label"], "미수락", "Pending payload should use the default pending label.")
	assert_eq(pending_payload["reward_label"], "45 GC", "Payload should preserve the reward candidate label.")

	var accepted_payload: Dictionary = definition.to_candidate_payload(true)
	assert_eq(accepted_payload["status_label"], "수락됨", "Accepted payload should use the accepted label.")


func test_quarterview_job_resources_are_valid_and_unique() -> void:
	var paths := _get_quarterview_job_resource_paths()
	var seen_keys := {}

	assert_true(paths.size() > 0, "Quarterview job Resource files should exist.")

	for path in paths:
		var definition = load(path)
		var file_stem := path.get_file().get_basename()

		assert_not_null(definition, "%s should load." % path)
		assert_eq(definition.get_script(), QUARTERVIEW_JOB_DEFINITION_SCRIPT, "%s should use QuarterviewJobDefinition.gd." % path)
		assert_true(definition.is_valid_definition(), "%s should be a valid QuarterviewJobDefinition." % path)
		assert_eq(definition.key, file_stem, "%s key should match its file name." % path)
		assert_false(seen_keys.has(definition.key), "Duplicate quarterview job key found: %s" % definition.key)
		seen_keys[definition.key] = true


func test_maintenance_17_fragment_contract() -> void:
	var definition = load("%s/maintenance_17_fragment.tres" % QUARTERVIEW_JOB_DIR)

	assert_not_null(definition, "maintenance_17_fragment should load.")
	assert_eq(definition.title, "maintenance_17_fragment 회수", "First job title should match the Act 1 candidate.")
	assert_eq(definition.sender_label, "익명 의뢰", "First job should come from an anonymous sender.")
	assert_eq(definition.reward_label, "45 GC", "First job should show the mock GC reward candidate.")
	assert_eq(definition.risk_label, "낮음", "First job should show low risk.")
	assert_eq(definition.related_object_key, "laptop", "First job should route back to the laptop/desk candidate.")
	assert_true(definition.detail_text.contains("공공망 업로드 금지"), "First job should include the no-public-upload constraint.")
	assert_true(definition.detail_text.contains("NAVI"), "First job should mention NAVI proxy preparation.")


func _get_quarterview_job_resource_paths() -> Array[String]:
	var paths: Array[String] = []
	var dir := DirAccess.open(QUARTERVIEW_JOB_DIR)
	if dir == null:
		return paths

	for file_name in dir.get_files():
		if file_name.ends_with(".tres"):
			paths.append("%s/%s" % [QUARTERVIEW_JOB_DIR, file_name])

	paths.sort()
	return paths
