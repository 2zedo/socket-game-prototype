extends Control

const INPUT_PROMPTS_SCRIPT := preload("res://scripts/prototypes/PrototypeInputPrompts.gd")
const PROTOTYPE_SFX_SCRIPT := preload("res://scripts/prototypes/PrototypeSfx.gd")
const SFX_SCENE_CHANGE_DELAY := 0.05

const PROTOTYPES := [
	{
		"key": "quarterview",
		"title": "Room Object Contract Prototype",
		"path": "res://scenes/prototypes/QuarterviewRoomPrototype.tscn",
		"shortcut": ["1", "Q"],
		"description": "Object registry, interaction prompt, and panel contract test. Not final quarterview visual blockout.",
		"button_path": "Margin/Panel/VBox/QuarterviewButton",
		"keycodes": [KEY_1, KEY_Q],
	},
	{
		"key": "hacking_action",
		"title": "Hacking Action Prototype",
		"path": "res://scenes/prototypes/HackingActionPrototype.tscn",
		"shortcut": ["2", "H"],
		"description": "탑뷰 해커모드 액션 / 이동 / 공격 / 회피 / 목표 / 탈출 검증",
		"button_path": "Margin/Panel/VBox/HackingButton",
		"keycodes": [KEY_2, KEY_H],
	},
	{
		"key": "title_menu",
		"title": "Title / Pause Menu Prototype",
		"path": "res://scenes/prototypes/TitleMenuPrototype.tscn",
		"shortcut": ["3", "T"],
		"description": "시작화면 / ESC 메뉴 / 설정 placeholder 검증",
		"button_path": "Margin/Panel/VBox/TitleMenuButton",
		"keycodes": [KEY_3, KEY_T],
	},
]

var sfx
var is_changing_scene := false
@onready var prompt_vbox: VBoxContainer = $Margin/Panel/VBox
@onready var keys_label: Label = $Margin/Panel/VBox/Keys


func _ready() -> void:
	_configure_sfx()
	_configure_input_prompt_icons()
	for prototype in PROTOTYPES:
		var button := get_node_or_null(NodePath(prototype["button_path"])) as Button
		if button == null:
			continue
		button.pressed.connect(_open_prototype.bind(prototype))
		button.mouse_entered.connect(sfx.play_select)
		button.focus_entered.connect(sfx.play_select)


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
		for prototype in PROTOTYPES:
			if prototype["keycodes"].has(event.keycode):
				_open_prototype(prototype)
				get_viewport().set_input_as_handled()
				return

		if event.keycode == KEY_ESCAPE:
			sfx.play_error()
			print("PrototypeHub: ESC 입력, 이 허브에서는 종료 동작을 연결하지 않았습니다.")
			get_viewport().set_input_as_handled()


func _open_prototype(prototype: Dictionary) -> void:
	if is_changing_scene:
		return
	is_changing_scene = true
	sfx.play_confirm()
	print("PrototypeHub: %s 실행" % prototype["title"])
	await get_tree().create_timer(SFX_SCENE_CHANGE_DELAY).timeout
	get_tree().change_scene_to_file(prototype["path"])
