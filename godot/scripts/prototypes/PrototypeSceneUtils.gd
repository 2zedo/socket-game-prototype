class_name PrototypeSceneUtils
extends RefCounted

const HUB_SCENE_PATH := "res://scenes/prototypes/PrototypeHub.tscn"


static func is_hub_back_event(event: InputEvent) -> bool:
	return _is_key_press(event) and event.keycode in [KEY_B, KEY_BACKSPACE]


static func is_restart_event(event: InputEvent) -> bool:
	return _is_key_press(event) and event.keycode == KEY_R


static func is_debug_toggle_event(event: InputEvent) -> bool:
	return _is_key_press(event) and event.keycode == KEY_D


static func is_confirm_event(event: InputEvent) -> bool:
	if event.is_action_pressed("interact"):
		return true
	return _is_key_press(event) and event.keycode in [KEY_E, KEY_ENTER, KEY_KP_ENTER]


static func is_cancel_event(event: InputEvent) -> bool:
	return _is_key_press(event) and event.keycode == KEY_ESCAPE


static func go_to_hub(owner: Node) -> void:
	if owner == null or owner.get_tree() == null:
		return
	owner.get_tree().change_scene_to_file(HUB_SCENE_PATH)


static func restart_current_scene(owner: Node) -> void:
	if owner == null or owner.get_tree() == null:
		return

	var tree := owner.get_tree()
	if tree.current_scene != null and tree.current_scene.scene_file_path != "":
		tree.change_scene_to_file(tree.current_scene.scene_file_path)
		return

	tree.reload_current_scene()


static func _is_key_press(event: InputEvent) -> bool:
	return event is InputEventKey and event.pressed and not event.echo
