extends GutTest

const HACKING_SCENE := preload("res://scenes/prototypes/HackingActionPrototype.tscn")
const HACKING_SCRIPT := preload("res://scripts/prototypes/HackingActionPrototype.gd")


func test_scene_instantiates_with_hacking_script() -> void:
	var scene = await _make_scene()

	assert_not_null(scene, "HackingActionPrototype scene should instantiate.")
	assert_eq(scene.get_script(), HACKING_SCRIPT, "Scene root should use HackingActionPrototype.gd.")
	assert_not_null(scene.player, "Prototype should spawn a player avatar during ready/reset.")


func test_initial_mission_state_is_running_after_ready() -> void:
	var scene = await _make_scene()

	assert_eq(scene.mission_state, scene.MissionState.RUNNING)
	assert_eq(scene.trace, 0)
	assert_false(scene._is_objective_extracted())
	assert_false(scene._is_exit_active())


func test_objective_extraction_sets_state_and_opens_exit() -> void:
	var scene = await _make_scene()
	scene.player.global_position = scene.OBJECTIVE_POSITION

	scene._try_extract_objective()

	assert_eq(scene.mission_state, scene.MissionState.OBJECTIVE_EXTRACTED)
	assert_true(scene._is_objective_extracted(), "Objective should be marked extracted.")
	assert_true(scene._is_exit_active(), "Exit should become active after objective extraction.")


func test_exit_after_objective_sets_success() -> void:
	var scene = await _make_scene()
	scene._set_mission_state(scene.MissionState.OBJECTIVE_EXTRACTED, "test objective")
	scene.player.global_position = scene.EXIT_RECT.position + scene.EXIT_RECT.size * 0.5

	scene._check_exit()

	assert_eq(scene.mission_state, scene.MissionState.SUCCESS)
	assert_true(scene._is_objective_extracted())
	assert_true(scene._is_exit_active())


func test_trace_reaching_max_sets_failed() -> void:
	var scene = await _make_scene()

	scene.add_trace(scene.TRACE_MAX, "test_trace")

	assert_eq(scene.trace, scene.TRACE_MAX)
	assert_eq(scene.mission_state, scene.MissionState.FAILED)


func test_player_hp_zero_sets_failed() -> void:
	var scene = await _make_scene()

	scene.damage_player(scene.player.max_hp, "test_damage")

	assert_eq(scene.player.hp, 0)
	assert_eq(scene.mission_state, scene.MissionState.FAILED)


func test_reset_prototype_restores_initial_state() -> void:
	var scene = await _make_scene()
	scene.add_trace(scene.TRACE_MAX, "test_trace")
	assert_eq(scene.mission_state, scene.MissionState.FAILED)

	scene.reset_prototype()
	await get_tree().process_frame
	_disable_enemy_physics(scene)

	assert_eq(scene.mission_state, scene.MissionState.RUNNING)
	assert_eq(scene.trace, 0)
	assert_not_null(scene.player)
	assert_eq(scene.player.hp, scene.player.max_hp)
	assert_false(scene._is_objective_extracted())
	assert_false(scene._is_exit_active())


func test_failed_state_does_not_succeed_by_exit_check() -> void:
	var scene = await _make_scene()
	scene._set_mission_state(scene.MissionState.FAILED, "test failed")
	scene.player.global_position = scene.EXIT_RECT.position + scene.EXIT_RECT.size * 0.5

	scene._check_exit()

	assert_eq(scene.mission_state, scene.MissionState.FAILED)


func _make_scene():
	var scene = HACKING_SCENE.instantiate()
	add_child_autofree(scene)
	await get_tree().process_frame
	_disable_enemy_physics(scene)
	return scene


func _disable_enemy_physics(scene: Node) -> void:
	var enemy_layer = scene.get("enemy_layer")
	if enemy_layer == null:
		return
	for enemy in enemy_layer.get_children():
		enemy.set_physics_process(false)
