extends Control

const INPUT_PROMPTS_SCRIPT := preload("res://scripts/prototypes/PrototypeInputPrompts.gd")
const PROTOTYPE_SFX_SCRIPT := preload("res://scripts/prototypes/PrototypeSfx.gd")
const PROTOTYPE_UTILS := preload("res://scripts/prototypes/PrototypeSceneUtils.gd")
const SFX_SCENE_CHANGE_DELAY := 0.05

const PROTOTYPES := [
	{
		"key": "quarterview",
		"title": "Room Object Contract Prototype",
		"scene_path": "res://scenes/prototypes/QuarterviewRoomPrototype.tscn",
		"status": "active",
		"shortcut": ["1", "Q"],
		"description": "Object registry, interaction prompt, and panel contract test. Not final quarterview visual blockout.",
		"button_path": "Margin/Panel/VBox/QuarterviewButton",
		"keycodes": [KEY_1, KEY_Q],
	},
	{
		"key": "quarterview_perspective_blockout",
		"title": "Quarterview Perspective Blockout",
		"scene_path": "res://scenes/prototypes/QuarterviewPerspectiveBlockout.tscn",
		"status": "active",
		"shortcut": ["2", "V"],
		"description": "Visual perspective blockout for the future quarterview cutaway room. Tests angled floor, walls, pseudo-3D furniture, and depth. Not gameplay integration.",
		"button_path": "Margin/Panel/VBox/QuarterviewPerspectiveButton",
		"keycodes": [KEY_2, KEY_V],
	},
	{
		"key": "hacking_action",
		"title": "Hacking Action Prototype",
		"scene_path": "res://scenes/prototypes/HackingActionPrototype.tscn",
		"status": "active",
		"shortcut": ["3", "H"],
		"description": "탑뷰 해커모드 액션 / 이동 / 공격 / 회피 / 목표 / 탈출 검증",
		"button_path": "Margin/Panel/VBox/HackingButton",
		"keycodes": [KEY_3, KEY_H],
	},
	{
		"key": "hacking_perspective_blockout",
		"title": "Hacking Perspective Blockout",
		"scene_path": "res://scenes/prototypes/HackingPerspectiveBlockout.tscn",
		"status": "active",
		"shortcut": ["4", "C"],
		"description": "Visual perspective blockout for future 3/4 top-down cyber action view. Tests cyber arena depth, angled platforms, barriers, and non-topdown camera feel. Not gameplay integration.",
		"button_path": "Margin/Panel/VBox/HackingPerspectiveButton",
		"keycodes": [KEY_4, KEY_C],
	},
	{
		"key": "title_menu",
		"title": "Title / Pause Menu Prototype",
		"scene_path": "res://scenes/prototypes/TitleMenuPrototype.tscn",
		"status": "active",
		"shortcut": ["5", "T"],
		"description": "시작화면 / ESC 메뉴 / 설정 placeholder 검증",
		"button_path": "Margin/Panel/VBox/TitleMenuButton",
		"keycodes": [KEY_5, KEY_T],
	},
	{
		"key": "quarterview_gameplay_sandbox",
		"title": "Quarterview Gameplay Sandbox",
		"scene_path": "res://scenes/prototypes/QuarterviewGameplaySandbox.tscn",
		"status": "active",
		"shortcut": ["6", "G"],
		"description": "Sandbox for future Main/DAY1 quarterview migration. Tests RoomSceneContract signal flow only. No Phone/Outlet/Result wiring yet.",
		"button_path": "Margin/Panel/VBox/QuarterviewGameplaySandboxButton",
		"keycodes": [KEY_6, KEY_G],
	},
]

var sfx
var is_changing_scene := false
var focused_prototype_index := 0
@onready var prompt_vbox: VBoxContainer = $Margin/Panel/VBox
@onready var keys_label: Label = $Margin/Panel/VBox/Keys


func _ready() -> void:
	_configure_sfx()
	_configure_input_prompt_icons()
	for index in range(PROTOTYPES.size()):
		var prototype: Dictionary = PROTOTYPES[index]
		var button := get_node_or_null(NodePath(prototype["button_path"])) as Button
		if button == null:
			continue
		button.disabled = prototype.get("status", "active") != "active"
		button.pressed.connect(_open_prototype.bind(prototype))
		button.mouse_entered.connect(sfx.play_select)
		button.focus_entered.connect(sfx.play_select)
		button.focus_entered.connect(_set_focused_prototype.bind(index))
		if index == 0:
			button.grab_focus()


func _configure_sfx() -> void:
	sfx = PROTOTYPE_SFX_SCRIPT.new()
	sfx.name = "PrototypeSfx"
	add_child(sfx)


func _configure_input_prompt_icons() -> void:
	var prompt_box := INPUT_PROMPTS_SCRIPT.create_prompt_box(
		[
			{"keys": ["arrows"], "text": "Select prototype"},
			{"keys": ["e", "enter"], "text": "Open selected prototype"},
			{"keys": ["b", "backspace"], "text": "Back from prototype to hub"},
		],
		Vector2(26, 26),
		Color(0.82, 0.80, 0.72, 1.0)
	)
	prompt_vbox.add_child(prompt_box)
	prompt_vbox.move_child(prompt_box, keys_label.get_index())


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if PROTOTYPE_UTILS.is_confirm_event(event):
			_open_prototype(PROTOTYPES[focused_prototype_index])
			get_viewport().set_input_as_handled()
			return

		for prototype in PROTOTYPES:
			if prototype["keycodes"].has(event.keycode):
				_open_prototype(prototype)
				get_viewport().set_input_as_handled()
				return

		if PROTOTYPE_UTILS.is_cancel_event(event):
			sfx.play_error()
			print("PrototypeHub: ESC 입력, 이 허브에서는 종료 동작을 연결하지 않았습니다.")
			get_viewport().set_input_as_handled()


func _set_focused_prototype(index: int) -> void:
	focused_prototype_index = clampi(index, 0, PROTOTYPES.size() - 1)


func _open_prototype(prototype: Dictionary) -> void:
	if is_changing_scene:
		return
	if prototype.get("status", "active") != "active":
		sfx.play_error()
		print("PrototypeHub: %s is not active." % prototype["title"])
		return
	is_changing_scene = true
	sfx.play_confirm()
	print("PrototypeHub: %s 실행" % prototype["title"])
	await get_tree().create_timer(SFX_SCENE_CHANGE_DELAY).timeout
	get_tree().change_scene_to_file(prototype["scene_path"])
