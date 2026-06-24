extends GutTest

const PROTOTYPE_SCENE_UTILS := preload("res://scripts/prototypes/PrototypeSceneUtils.gd")


func test_hub_back_events_use_b_or_backspace() -> void:
	assert_true(PROTOTYPE_SCENE_UTILS.is_hub_back_event(_make_key_event(KEY_B)))
	assert_true(PROTOTYPE_SCENE_UTILS.is_hub_back_event(_make_key_event(KEY_BACKSPACE)))
	assert_false(PROTOTYPE_SCENE_UTILS.is_hub_back_event(_make_key_event(KEY_X)))


func test_restart_event_uses_r() -> void:
	assert_true(PROTOTYPE_SCENE_UTILS.is_restart_event(_make_key_event(KEY_R)))
	assert_false(PROTOTYPE_SCENE_UTILS.is_restart_event(_make_key_event(KEY_E)))


func test_debug_toggle_event_uses_d() -> void:
	assert_true(PROTOTYPE_SCENE_UTILS.is_debug_toggle_event(_make_key_event(KEY_D)))
	assert_false(PROTOTYPE_SCENE_UTILS.is_debug_toggle_event(_make_key_event(KEY_R)))


func test_confirm_event_uses_e_or_enter() -> void:
	assert_true(PROTOTYPE_SCENE_UTILS.is_confirm_event(_make_key_event(KEY_E)))
	assert_true(PROTOTYPE_SCENE_UTILS.is_confirm_event(_make_key_event(KEY_ENTER)))
	assert_true(PROTOTYPE_SCENE_UTILS.is_confirm_event(_make_key_event(KEY_KP_ENTER)))
	assert_false(PROTOTYPE_SCENE_UTILS.is_confirm_event(_make_key_event(KEY_ESCAPE)))


func test_cancel_event_uses_escape() -> void:
	assert_true(PROTOTYPE_SCENE_UTILS.is_cancel_event(_make_key_event(KEY_ESCAPE)))
	assert_false(PROTOTYPE_SCENE_UTILS.is_cancel_event(_make_key_event(KEY_BACKSPACE)))


func test_echo_and_release_events_are_ignored() -> void:
	assert_false(PROTOTYPE_SCENE_UTILS.is_hub_back_event(_make_key_event(KEY_B, true, true)))
	assert_false(PROTOTYPE_SCENE_UTILS.is_hub_back_event(_make_key_event(KEY_B, false)))
	assert_false(PROTOTYPE_SCENE_UTILS.is_restart_event(_make_key_event(KEY_R, true, true)))
	assert_false(PROTOTYPE_SCENE_UTILS.is_debug_toggle_event(_make_key_event(KEY_D, false)))


func test_hub_scene_path_points_to_prototype_hub() -> void:
	assert_eq(PROTOTYPE_SCENE_UTILS.HUB_SCENE_PATH, "res://scenes/prototypes/PrototypeHub.tscn")


func _make_key_event(keycode: Key, pressed: bool = true, echo: bool = false) -> InputEventKey:
	var event := InputEventKey.new()
	event.keycode = keycode
	event.pressed = pressed
	event.echo = echo
	return event
