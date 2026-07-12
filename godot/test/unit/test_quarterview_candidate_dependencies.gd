extends GutTest

const CANDIDATE_ROOTS := [
	"res://scenes/QuarterviewMain.tscn",
	"res://scenes/quarterview/QuarterviewRoom.tscn",
	"res://scripts/QuarterviewMain.gd",
	"res://scripts/quarterview/QuarterviewRoom.gd",
	"res://scripts/quarterview/QuarterviewPlayer.gd",
	"res://scripts/ui/quarterview/PhoneScreenCandidate.gd",
	"res://scripts/ui/quarterview/PowerBoardCandidate.gd",
]
const FORBIDDEN_RESOURCE_PATHS := [
	"res://scenes/Main.tscn",
	"res://scripts/Main.gd",
	"res://scripts/Apartment.gd",
	"res://scripts/SurvivalState.gd",
	"res://scenes/ui/PhoneUI.tscn",
	"res://scripts/ui/PhoneUI.gd",
	"res://scenes/ui/OutletMode.tscn",
	"res://scripts/ui/OutletMode.gd",
	"res://scenes/ui/DayResultPanel.tscn",
	"res://scripts/ui/DayResultPanel.gd",
	"res://scripts/systems/GridCreditState.gd",
	"res://scenes/prototypes/HackingActionPrototype.tscn",
	"res://scenes/prototypes/HackingPerspectiveBlockout.tscn",
	"res://scripts/prototypes/HackingActionPrototype.gd",
	"res://scripts/prototypes/HackingPerspectiveBlockout.gd",
]
const FORBIDDEN_EXECUTABLE_PATTERNS := {
	"production singleton": "\\b(SurvivalState|GridCreditState|SaveManager|StoryState)\\b",
	"production UI class": "\\b(PhoneUI|OutletMode|DayResultPanel)\\b",
	"save/load API": "\\b(save_game|load_game|save_state|load_state|set_story_flag|get_story_flag)\\s*\\(",
	"scene transition": "\\b(change_scene_to_file|change_scene_to_packed)\\s*\\(",
}
const FORBIDDEN_RAW_CALL_PATTERNS := {
	"production root singleton lookup": "\\bget_node(?:_or_null)?\\s*\\(\\s*[\\\"']/root/(SurvivalState|GridCreditState|SaveManager|StoryState)[\\\"']",
	"production engine singleton lookup": "\\bEngine\\s*\\.\\s*get_singleton\\s*\\(\\s*[\\\"'](SurvivalState|GridCreditState|SaveManager|StoryState)[\\\"']",
	"deferred scene transition": "\\b(?:call|call_deferred|callv)\\s*\\(\\s*[\\\"']change_scene_to_(?:file|packed)[\\\"']",
	"resource save": "\\bResourceSaver\\s*\\.\\s*save\\s*\\(",
	"config save": "\\bConfigFile\\s*\\.\\s*save\\s*\\(",
	"user data write": "\\bFileAccess\\s*\\.\\s*open\\s*\\([^\\n]*[\\\"']user://[^\\n]*(?:WRITE|READ_WRITE|WRITE_READ)",
}


func test_candidate_dependency_graph_excludes_production_resources() -> void:
	var dependencies := _collect_dependency_graph(CANDIDATE_ROOTS)
	for forbidden_path in FORBIDDEN_RESOURCE_PATHS:
		assert_false(
			dependencies.has(forbidden_path),
			"Candidate dependency graph must not include production resource %s. Graph: %s" % [forbidden_path, dependencies]
		)


func test_candidate_executable_sources_do_not_call_production_systems() -> void:
	var dependencies := _collect_dependency_graph(CANDIDATE_ROOTS)
	var script_paths: Array[String] = []
	for path in dependencies:
		if String(path).ends_with(".gd"):
			script_paths.append(String(path))

	for script_path in script_paths:
		var source := FileAccess.get_file_as_string(script_path)
		var executable_source := _strip_comments_and_strings(source)
		for label in FORBIDDEN_EXECUTABLE_PATTERNS:
			_assert_pattern_absent(executable_source, FORBIDDEN_EXECUTABLE_PATTERNS[label], String(label), script_path)
		var source_without_comments := _strip_comments(source)
		for label in FORBIDDEN_RAW_CALL_PATTERNS:
			_assert_pattern_absent(source_without_comments, FORBIDDEN_RAW_CALL_PATTERNS[label], String(label), script_path)


func test_project_start_scene_remains_protected_main() -> void:
	assert_eq(
		ProjectSettings.get_setting("application/run/main_scene"),
		"res://scenes/Main.tscn",
		"QuarterviewMain must remain a direct-run candidate, not the project start scene."
	)


func _assert_pattern_absent(source: String, pattern: String, label: String, script_path: String) -> void:
	var regex := RegEx.new()
	var compile_error := regex.compile(pattern)
	assert_eq(compile_error, OK, "Boundary regex should compile: %s" % label)
	var match := regex.search(source)
	assert_null(
		match,
		"Candidate executable source uses forbidden %s in %s near offset %d." % [
			label,
			script_path,
			match.get_start() if match != null else -1,
		]
	)


func _collect_dependency_graph(root_paths: Array) -> Array[String]:
	var pending: Array[String] = []
	var visited: Dictionary = {}
	for root_path in root_paths:
		pending.append(String(root_path))

	while not pending.is_empty():
		var path: String = String(pending.pop_front())
		if visited.has(path):
			continue
		visited[path] = true
		if path.ends_with(".gd"):
			for source_reference in _extract_resource_paths(FileAccess.get_file_as_string(path)):
				if not visited.has(source_reference):
					pending.append(source_reference)
		for raw_dependency in ResourceLoader.get_dependencies(path):
			var dependency := _dependency_path(String(raw_dependency))
			if dependency.begins_with("res://") and not visited.has(dependency):
				pending.append(dependency)

	var result: Array[String] = []
	result.assign(visited.keys())
	result.sort()
	return result


func _extract_resource_paths(source: String) -> Array[String]:
	var paths: Array[String] = []
	var regex := RegEx.new()
	regex.compile("[\\\"'](res://[^\\\"']+)[\\\"']")
	for match in regex.search_all(source):
		var path := match.get_string(1)
		if not paths.has(path):
			paths.append(path)
	return paths


func _dependency_path(raw_dependency: String) -> String:
	var separator_index := raw_dependency.find("::")
	return raw_dependency.left(separator_index) if separator_index >= 0 else raw_dependency


func _strip_comments_and_strings(source: String) -> String:
	var output := ""
	var in_string := false
	var quote := ""
	var escaped := false
	var in_comment := false

	for index in source.length():
		var character := source[index]
		if in_comment:
			if character == "\n":
				in_comment = false
				output += character
			else:
				output += " "
			continue
		if in_string:
			if escaped:
				escaped = false
			elif character == "\\":
				escaped = true
			elif character == quote:
				in_string = false
			output += " " if character != "\n" else "\n"
			continue
		if character == "#":
			in_comment = true
			output += " "
		elif character == "\"" or character == "'":
			in_string = true
			quote = character
			output += " "
		else:
			output += character
	return output


func _strip_comments(source: String) -> String:
	var output := ""
	var in_string := false
	var quote := ""
	var escaped := false
	var in_comment := false

	for index in source.length():
		var character := source[index]
		if in_comment:
			if character == "\n":
				in_comment = false
				output += character
			else:
				output += " "
			continue
		if in_string:
			output += character
			if escaped:
				escaped = false
			elif character == "\\":
				escaped = true
			elif character == quote:
				in_string = false
			continue
		if character == "#":
			in_comment = true
			output += " "
		elif character == "\"" or character == "'":
			in_string = true
			quote = character
			output += character
		else:
			output += character
	return output
