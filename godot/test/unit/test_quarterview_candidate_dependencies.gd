extends GutTest

const PRODUCTION_MAIN_SCENE := preload("res://scenes/Main.tscn")
const PRODUCTION_APARTMENT_SCENE := preload("res://scenes/Apartment.tscn")
const QUARTERVIEW_APARTMENT_PLAYABLE_SCENE := preload("res://scenes/quarterview/QuarterviewApartmentPlayable.tscn")

const CANDIDATE_ROOTS := [
	"res://scenes/QuarterviewMain.tscn",
	"res://scenes/quarterview/QuarterviewRoom.tscn",
	"res://scenes/quarterview/QuarterviewApartmentEnvironment.tscn",
	"res://scenes/quarterview/QuarterviewApartmentShellCandidate.tscn",
	"res://scenes/quarterview/QuarterviewApartmentPlayable.tscn",
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


func test_current_production_main_composition_and_signal_wiring_are_characterized() -> void:
	var main: Node = PRODUCTION_MAIN_SCENE.instantiate()
	add_child_autofree(main)

	for required_path in [
		"SurvivalState",
		"Apartment",
		"UI/SurvivalHUD",
		"UI/PhoneUI",
		"UI/InteractionPanel",
		"UI/OutletMode",
		"UI/DayResultPanel",
	]:
		assert_not_null(main.get_node_or_null(required_path), "Production Main must keep its current DAY1 child: %s" % required_path)

	var apartment: Node = main.get_node("Apartment")
	var survival_state: Node = main.get_node("SurvivalState")
	assert_true(apartment.is_connected("nearest_interactable_changed", Callable(main, "_on_nearest_interactable_changed")))
	assert_true(apartment.is_connected("interaction_requested", Callable(main, "_on_interaction_requested")))
	assert_true(survival_state.is_connected("changed", Callable(main, "_refresh_survival_ui")))
	assert_true(survival_state.is_connected("day_ended", Callable(main, "_on_day_ended")))
	assert_eq(_connection_count_to(apartment, "nearest_interactable_changed", main, "_on_nearest_interactable_changed"), 1, "Main startup must not duplicate nearest-object wiring.")
	assert_eq(_connection_count_to(apartment, "interaction_requested", main, "_on_interaction_requested"), 1, "Main startup must not duplicate interaction wiring.")
	assert_eq(_connection_count_to(survival_state, "changed", main, "_refresh_survival_ui"), 1, "Main startup must not duplicate state refresh wiring.")
	assert_eq(_connection_count_to(survival_state, "day_ended", main, "_on_day_ended"), 1, "Main startup must not duplicate day-end wiring.")

	assert_eq(_project_autoload_names(), ["_mcp_game_helper"], "No production state or save singleton is configured; the editor helper is the only Autoload.")
	for absent_autoload in ["SurvivalState", "SaveManager", "StoryState", "GridCreditState"]:
		assert_false(
			ProjectSettings.has_setting("autoload/%s" % absent_autoload),
			"%s is not a production autoload yet; integration must not assume persistent lifetime." % absent_autoload
		)
	assert_null(main.get_node_or_null("SaveManager"), "Current Main must remain safe to start without a save service or save data.")


func test_current_production_phone_input_and_state_seams_are_characterized() -> void:
	var main: Node = PRODUCTION_MAIN_SCENE.instantiate()
	add_child_autofree(main)
	var phone_ui: Control = main.get_node("UI/PhoneUI") as Control
	var survival_state: Node = main.get_node("SurvivalState")
	var apartment: Node = main.get_node("Apartment")

	assert_true(_action_has_key("toggle_test_mode", KEY_P), "Production currently owns P as test mode, not Phone.")
	assert_true(
		_action_has_key("open_phone", KEY_BACKSPACE),
		"Characterize the current mismatch: open_phone is mapped to Backspace in project settings."
	)
	assert_true(
		FileAccess.get_file_as_string("res://scripts/Main.gd").contains("Input.is_key_pressed(KEY_TAB)"),
		"Production Main also owns a raw Tab fallback that a future input adapter must replace."
	)
	assert_true(_action_has_key("cancel_or_menu", KEY_ESCAPE), "Production modal close currently uses ESC.")

	main.call("_unhandled_input", _action_event("toggle_test_mode"))
	assert_true(bool(main.get("test_mode_enabled")), "P must retain the current production test-mode behavior.")
	assert_false(phone_ui.visible, "P must not open the production Phone.")

	main.call("_toggle_phone_ui")
	assert_true(phone_ui.visible)
	assert_true(bool(survival_state.get("is_clock_paused_by_modal")), "Phone must pause the scene-local DAY1 clock.")
	var player: Node = apartment.get("player") as Node
	assert_false(bool(player.get("can_move")), "Phone must disable production player movement.")
	main.call("_unhandled_input", _action_event("cancel_or_menu"))
	assert_false(phone_ui.visible, "ESC must close the production Phone.")
	assert_false(bool(survival_state.get("is_clock_paused_by_modal")))
	assert_true(bool(player.get("can_move")))

	var initial_clock: String = String(survival_state.call("get_current_clock_text"))
	survival_state.call("debug_set_time_before_limit", 30)
	assert_ne(String(survival_state.call("get_current_clock_text")), initial_clock, "A characterization-only time injection seam exists.")
	survival_state.call("debug_set_current_power", 4.5)
	survival_state.call("debug_set_phone_battery", 55.0)
	assert_almost_eq(float(survival_state.get("current_power_units")), 4.5, 0.001)
	assert_almost_eq(float(survival_state.get("battery")), 55.0, 0.001)
	assert_true(String(survival_state.call("get_phone_text")).contains("55%"), "Phone reads the same scene-local state.")


func test_current_quarterview_playable_requires_an_explicit_production_adapter() -> void:
	var production_apartment: Node = PRODUCTION_APARTMENT_SCENE.instantiate()
	var playable: Node = QUARTERVIEW_APARTMENT_PLAYABLE_SCENE.instantiate()
	add_child_autofree(production_apartment)
	add_child_autofree(playable)
	var gameplay: Node = playable.get_node("Gameplay")

	assert_null(playable.get_node_or_null("SurvivalState"), "Quarterview Playable is still independent from production state.")
	assert_null(playable.get_node_or_null("UI/PhoneUI"), "Quarterview Playable does not yet compose production UI.")
	assert_true(gameplay.has_method("set_room_input_enabled"))
	assert_true(gameplay.has_signal("interaction_requested"))
	assert_eq(_signal_argument_count(production_apartment, "interaction_requested"), 1)
	assert_eq(_signal_argument_count(gameplay, "interaction_requested"), 3, "Signal shapes differ and must not be wired directly.")

	var production_ids: Array[String] = []
	for raw_id in production_apartment.get("interactables_by_id").keys():
		production_ids.append(String(raw_id))
	production_ids.sort()
	var quarterview_ids: Array[String] = []
	quarterview_ids.assign(playable.call("playable_direct_object_ids"))
	quarterview_ids.sort()
	assert_eq(production_ids, ["bed", "charger", "communication_device", "fan", "laptop", "light", "power_strip"])
	assert_eq(quarterview_ids, ["bed", "entrance_door", "fridge", "microwave", "navi_link", "node_17", "power_module_board"])
	assert_ne(production_ids, quarterview_ids, "Production action IDs and Quarterview object IDs require an explicit mapping contract.")


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


func _action_has_key(action_name: StringName, keycode: Key) -> bool:
	for raw_event in InputMap.action_get_events(action_name):
		var key_event: InputEventKey = raw_event as InputEventKey
		if key_event != null and key_event.keycode == keycode:
			return true
	return false


func _action_event(action_name: StringName) -> InputEventAction:
	var event := InputEventAction.new()
	event.action = action_name
	event.pressed = true
	return event


func _signal_argument_count(source: Object, signal_name: StringName) -> int:
	for raw_signal in source.get_signal_list():
		var signal_data: Dictionary = raw_signal
		if StringName(signal_data.get("name", "")) == signal_name:
			var arguments: Array = signal_data.get("args", [])
			return arguments.size()
	return -1


func _connection_count_to(source: Object, signal_name: StringName, target: Object, method_name: StringName) -> int:
	var expected := Callable(target, method_name)
	var count := 0
	for raw_connection in source.get_signal_connection_list(signal_name):
		var connection_data: Dictionary = raw_connection
		if connection_data.get("callable") == expected:
			count += 1
	return count


func _project_autoload_names() -> Array[String]:
	var names: Array[String] = []
	for raw_property in ProjectSettings.get_property_list():
		var property_data: Dictionary = raw_property
		var property_name: String = String(property_data.get("name", ""))
		if property_name.begins_with("autoload/"):
			names.append(property_name.trim_prefix("autoload/"))
	names.sort()
	return names


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
