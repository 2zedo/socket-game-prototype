extends Control

const PROTOTYPE_UTILS := preload("res://scripts/prototypes/PrototypeSceneUtils.gd")
const TITLE_SCENE := "res://scenes/prototypes/TitleMenuPrototype.tscn"

var pause_overlay: Control
var settings_panel: Control


func _ready() -> void:
	_build_title_screen()
	_build_pause_overlay()
	_build_settings_panel()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if PROTOTYPE_UTILS.is_hub_back_event(event):
			_go_to_prototype_hub()
			get_viewport().set_input_as_handled()
		elif PROTOTYPE_UTILS.is_cancel_event(event):
			_toggle_pause_overlay()
			get_viewport().set_input_as_handled()


func _show_pause_overlay() -> void:
	pause_overlay.visible = true
	pause_overlay.move_to_front()


func _hide_pause_overlay() -> void:
	pause_overlay.visible = false
	if settings_panel.visible:
		_hide_settings_panel()


func _toggle_pause_overlay() -> void:
	if pause_overlay.visible:
		_hide_pause_overlay()
	else:
		_show_pause_overlay()


func _show_settings_panel() -> void:
	settings_panel.visible = true
	settings_panel.move_to_front()


func _hide_settings_panel() -> void:
	settings_panel.visible = false


func _toggle_settings_panel() -> void:
	if settings_panel.visible:
		_hide_settings_panel()
	else:
		_show_settings_panel()


func _go_to_prototype_hub() -> void:
	print("Title prototype: Prototype Hub selected")
	PROTOTYPE_UTILS.go_to_hub(self)


func _reload_title() -> void:
	print("Title prototype: Title selected")
	get_tree().change_scene_to_file(TITLE_SCENE)


func _select_new_game() -> void:
	print("Title prototype: New Game selected")


func _select_continue() -> void:
	print("Title prototype: Continue selected but save/load is not implemented")


func _select_exit() -> void:
	print("Title prototype: Exit selected, quit is not wired in this prototype")


func _build_title_screen() -> void:
	var background := ColorRect.new()
	background.name = "Background"
	background.color = Color(0.008, 0.012, 0.026, 1.0)
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var cold_band := ColorRect.new()
	cold_band.name = "ColdCityBand"
	cold_band.color = Color(0.06, 0.10, 0.18, 0.82)
	cold_band.set_anchors_preset(Control.PRESET_FULL_RECT)
	cold_band.offset_left = 620.0
	cold_band.offset_top = 0.0
	add_child(cold_band)

	var warm_glow := ColorRect.new()
	warm_glow.name = "WarmInteriorGlow"
	warm_glow.color = Color(0.74, 0.48, 0.19, 0.12)
	warm_glow.set_anchors_preset(Control.PRESET_FULL_RECT)
	warm_glow.offset_left = 0.0
	warm_glow.offset_right = -610.0
	warm_glow.offset_top = 120.0
	warm_glow.offset_bottom = -120.0
	add_child(warm_glow)

	var margin := MarginContainer.new()
	margin.name = "Margin"
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 92)
	margin.add_theme_constant_override("margin_top", 74)
	margin.add_theme_constant_override("margin_right", 92)
	margin.add_theme_constant_override("margin_bottom", 74)
	add_child(margin)

	var row := HBoxContainer.new()
	row.name = "ContentRow"
	row.add_theme_constant_override("separation", 80)
	margin.add_child(row)

	var title_column := VBoxContainer.new()
	title_column.name = "TitleColumn"
	title_column.custom_minimum_size = Vector2(520, 0)
	title_column.add_theme_constant_override("separation", 14)
	row.add_child(title_column)

	var title := _make_label("CONCENT", 64, Color(0.94, 0.90, 0.78, 1.0))
	title_column.add_child(title)
	title_column.add_child(_make_label("전력 부족의 시대", 26, Color(0.95, 0.68, 0.35, 1.0)))
	title_column.add_child(_make_label("THE GRID 하층 구역의 밤은 조용하고, 전력은 충분하지 않다.", 18, Color(0.66, 0.75, 0.82, 1.0)))

	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(1, 70)
	title_column.add_child(spacer)

	var menu_column := VBoxContainer.new()
	menu_column.name = "MenuColumn"
	menu_column.custom_minimum_size = Vector2(340, 0)
	menu_column.add_theme_constant_override("separation", 12)
	row.add_child(menu_column)

	menu_column.add_child(_make_button("[새 게임]", _select_new_game))
	var continue_button := _make_button("[이어하기]", _select_continue)
	continue_button.disabled = true
	menu_column.add_child(continue_button)
	menu_column.add_child(_make_button("[프로토타입 허브]", _go_to_prototype_hub))
	menu_column.add_child(_make_button("[설정]", _toggle_settings_panel))
	menu_column.add_child(_make_button("[종료]", _select_exit))

	var hint := _make_label("ESC: SYSTEM MENU\nB / Backspace: Prototype Hub", 16, Color(0.52, 0.72, 0.88, 0.90))
	hint.position = Vector2(92, 650)
	add_child(hint)


func _build_pause_overlay() -> void:
	pause_overlay = ColorRect.new()
	pause_overlay.name = "PauseOverlay"
	pause_overlay.color = Color(0.0, 0.0, 0.0, 0.68)
	pause_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	pause_overlay.visible = false
	add_child(pause_overlay)

	var panel := PanelContainer.new()
	panel.name = "PausePanel"
	panel.custom_minimum_size = Vector2(430, 410)
	panel.position = Vector2(425, 145)
	panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.018, 0.021, 0.032, 0.96), Color(0.45, 0.78, 0.92, 0.55), 2))
	pause_overlay.add_child(panel)

	var box := VBoxContainer.new()
	box.name = "PauseMenu"
	box.add_theme_constant_override("separation", 12)
	panel.add_child(box)

	box.add_child(_make_label("PAUSED / SYSTEM MENU", 28, Color(0.92, 0.88, 0.76, 1.0)))
	box.add_child(_make_button("[계속]", _hide_pause_overlay))
	box.add_child(_make_button("[설정]", _toggle_settings_panel))
	box.add_child(_make_button("[프로토타입 허브로]", _go_to_prototype_hub))
	box.add_child(_make_button("[타이틀로]", _reload_title))
	box.add_child(_make_button("[종료]", _select_exit))
	box.add_child(_make_label("B / Backspace: Prototype Hub", 14, Color(0.52, 0.72, 0.88, 0.90)))


func _build_settings_panel() -> void:
	settings_panel = PanelContainer.new()
	settings_panel.name = "SettingsPanel"
	settings_panel.custom_minimum_size = Vector2(380, 290)
	settings_panel.position = Vector2(450, 205)
	settings_panel.visible = false
	settings_panel.add_theme_stylebox_override("panel", _make_panel_style(Color(0.026, 0.030, 0.044, 0.98), Color(0.93, 0.64, 0.33, 0.65), 2))
	add_child(settings_panel)

	var box := VBoxContainer.new()
	box.name = "SettingsBox"
	box.add_theme_constant_override("separation", 10)
	settings_panel.add_child(box)

	box.add_child(_make_label("SETTINGS", 26, Color(0.95, 0.89, 0.75, 1.0)))
	box.add_child(_make_label("BGM Volume: placeholder", 17, Color(0.76, 0.78, 0.82, 1.0)))
	box.add_child(_make_label("SE Volume: placeholder", 17, Color(0.76, 0.78, 0.82, 1.0)))
	box.add_child(_make_label("Text Speed: placeholder", 17, Color(0.76, 0.78, 0.82, 1.0)))
	box.add_child(_make_label("Fullscreen: placeholder", 17, Color(0.76, 0.78, 0.82, 1.0)))
	box.add_child(_make_button("[닫기]", _hide_settings_panel))


func _make_label(text: String, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.85))
	label.add_theme_constant_override("shadow_offset_x", 2)
	label.add_theme_constant_override("shadow_offset_y", 2)
	return label


func _make_button(text: String, callback: Callable) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(320, 44)
	button.add_theme_font_size_override("font_size", 18)
	button.add_theme_stylebox_override("normal", _make_panel_style(Color(0.030, 0.036, 0.052, 0.94), Color(0.34, 0.58, 0.70, 0.65), 1))
	button.add_theme_stylebox_override("hover", _make_panel_style(Color(0.050, 0.064, 0.092, 0.98), Color(0.74, 0.92, 1.0, 0.95), 2))
	button.add_theme_stylebox_override("pressed", _make_panel_style(Color(0.090, 0.072, 0.045, 0.98), Color(1.0, 0.70, 0.34, 0.95), 2))
	button.pressed.connect(callback)
	return button


func _make_panel_style(bg_color: Color, border_color: Color, border_width: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = bg_color
	style.border_color = border_color
	style.set_border_width_all(border_width)
	style.set_corner_radius_all(2)
	style.content_margin_left = 18.0
	style.content_margin_top = 14.0
	style.content_margin_right = 18.0
	style.content_margin_bottom = 14.0
	return style
