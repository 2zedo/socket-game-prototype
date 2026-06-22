extends Control

const PROTOTYPES := [
	{
		"key": "quarterview",
		"title": "Quarterview Room Prototype",
		"path": "res://scenes/prototypes/QuarterviewRoomPrototype.tscn",
		"shortcut": ["1", "Q"],
		"description": "쿼터뷰 방 이동 / 레이어 / 오브젝트 / 상호작용 검증",
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


func _ready() -> void:
	for prototype in PROTOTYPES:
		var button := get_node_or_null(NodePath(prototype["button_path"])) as Button
		if button == null:
			continue
		button.pressed.connect(_open_prototype.bind(prototype))


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		for prototype in PROTOTYPES:
			if prototype["keycodes"].has(event.keycode):
				_open_prototype(prototype)
				get_viewport().set_input_as_handled()
				return

		if event.keycode == KEY_ESCAPE:
			print("PrototypeHub: ESC 입력, 이 허브에서는 종료 동작을 연결하지 않았습니다.")
			get_viewport().set_input_as_handled()


func _open_prototype(prototype: Dictionary) -> void:
	print("PrototypeHub: %s 실행" % prototype["title"])
	get_tree().change_scene_to_file(prototype["path"])
