extends Control

const QUARTERVIEW_SCENE := "res://scenes/prototypes/QuarterviewRoomPrototype.tscn"
const HACKING_ACTION_SCENE := "res://scenes/prototypes/HackingActionPrototype.tscn"
const TITLE_MENU_SCENE := "res://scenes/prototypes/TitleMenuPrototype.tscn"

@onready var quarterview_button: Button = $Margin/Panel/VBox/QuarterviewButton
@onready var hacking_button: Button = $Margin/Panel/VBox/HackingButton
@onready var title_button: Button = $Margin/Panel/VBox/TitleMenuButton


func _ready() -> void:
	quarterview_button.pressed.connect(_open_quarterview)
	hacking_button.pressed.connect(_open_hacking_action)
	title_button.pressed.connect(_open_title_menu)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_1, KEY_Q:
				_open_quarterview()
				get_viewport().set_input_as_handled()
			KEY_2, KEY_H:
				_open_hacking_action()
				get_viewport().set_input_as_handled()
			KEY_3, KEY_T:
				_open_title_menu()
				get_viewport().set_input_as_handled()
			KEY_ESCAPE:
				print("PrototypeHub: ESC 입력, 이 허브에서는 종료 동작을 연결하지 않았습니다.")
				get_viewport().set_input_as_handled()


func _open_quarterview() -> void:
	print("PrototypeHub: QuarterviewRoomPrototype 실행")
	get_tree().change_scene_to_file(QUARTERVIEW_SCENE)


func _open_hacking_action() -> void:
	print("PrototypeHub: HackingActionPrototype 실행")
	get_tree().change_scene_to_file(HACKING_ACTION_SCENE)


func _open_title_menu() -> void:
	print("PrototypeHub: TitleMenuPrototype 실행")
	get_tree().change_scene_to_file(TITLE_MENU_SCENE)
