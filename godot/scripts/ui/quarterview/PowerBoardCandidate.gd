extends PanelContainer
class_name PowerBoardCandidate

const POWER_MODULE_DEFINITION_SCRIPT := preload("res://scripts/resources/PowerModuleDefinition.gd")

signal close_requested
signal module_action_requested(module_key: String, action_key: String, module: Dictionary)
signal module_dropped(module_key: String, cell: Vector2i, module: Dictionary)
signal selection_changed(module_key: String, module: Dictionary)

const PANEL_SIZE := Vector2(860, 520)
const WORK_AREA_SIZE := Vector2(610, 334)
const INVENTORY_RECT := Rect2(Vector2.ZERO, Vector2(230, 334))
const BOARD_RECT := Rect2(Vector2(244, 0), Vector2(366, 334))
const GRID_ORIGIN := Vector2(276, 84)
const GRID_CELLS := Vector2i(6, 5)
const CELL_SIZE := Vector2(50, 40)
const INVALID_GRID_CELL := Vector2i(-1, -1)
const INVENTORY_SLOT_START := Vector2(18, 52)
const INVENTORY_SLOT_GAP := 56.0
const UI_POWER_BOARD_ATLAS_PATH := "res://assets/art/ui/atlases/ui_power_board_atlas.png"
const ATLAS_SOURCE_SIZE := Vector2(1254, 1254)

const MODULE_ATLAS_REGIONS := {
	"small_core": Rect2(Vector2(715, 318), Vector2(106, 120)),
	"laptop_adapter": Rect2(Vector2(718, 548), Vector2(294, 198)),
	"comm_module": Rect2(Vector2(1080, 585), Vector2(122, 290)),
	"odd_efficiency_module": Rect2(Vector2(882, 876), Vector2(342, 330)),
}

const MODULE_RESOURCE_PATHS := [
	"res://resources/rooms/quarterview/power_modules/small_core.tres",
	"res://resources/rooms/quarterview/power_modules/laptop_adapter.tres",
	"res://resources/rooms/quarterview/power_modules/comm_module.tres",
	"res://resources/rooms/quarterview/power_modules/odd_efficiency_module.tres",
]

const FALLBACK_MODULES := [
	{
		"key": "small_core",
		"display_name": "Small Core",
		"role": "power_module",
		"description": "작고 단순한 1x1 전력 코어 후보입니다. 배치해도 실제 전력 계산은 없습니다.",
		"effect": "전력 안정 / 효율 낮음",
		"candidate_action": "place_small_core_noop",
		"rect": Rect2(Vector2(18, 62), Vector2(48, 38)),
		"shape_cells": [Vector2i(0, 0)],
		"size_cells": Vector2i(1, 1),
		"atlas_region_name": "small_core",
		"color": Color(0.16, 0.38, 0.48, 0.92),
	},
	{
		"key": "laptop_adapter",
		"display_name": "Laptop Adapter",
		"role": "power_adapter",
		"description": "노트북 전원을 우선 배분할 2x1 어댑터 후보입니다. OutletMode와는 아직 연결하지 않았습니다.",
		"effect": "노트북 우선 공급 / 발열 약간 증가",
		"candidate_action": "place_laptop_adapter_noop",
		"rect": Rect2(Vector2(18, 122), Vector2(98, 38)),
		"shape_cells": [Vector2i(0, 0), Vector2i(1, 0)],
		"size_cells": Vector2i(2, 1),
		"atlas_region_name": "laptop_adapter",
		"color": Color(0.34, 0.28, 0.16, 0.94),
	},
	{
		"key": "comm_module",
		"display_name": "Comm Module",
		"role": "power_routing",
		"description": "통신 장비 전원을 세로로 잡아주는 1x2 후보 모듈입니다. 실제 장치 active 값은 바꾸지 않습니다.",
		"effect": "통신 유지 / 신호 보정 후보",
		"candidate_action": "place_comm_module_noop",
		"rect": Rect2(Vector2(18, 182), Vector2(48, 78)),
		"shape_cells": [Vector2i(0, 0), Vector2i(0, 1)],
		"size_cells": Vector2i(1, 2),
		"atlas_region_name": "comm_module",
		"color": Color(0.48, 0.22, 0.14, 0.92),
	},
	{
		"key": "odd_efficiency_module",
		"display_name": "Odd Efficiency",
		"role": "power_efficiency",
		"description": "크지만 효율이 좋아 보이는 3칸 L-shape 후보 모듈입니다. 배치가 까다롭지만 보드 퍼즐성을 확인하기 위한 임시 모듈입니다.",
		"effect": "효율 보정 / 발열 관리 필요 / 비정형 배치 보너스 후보",
		"candidate_action": "place_efficiency_module_noop",
		"rect": Rect2(Vector2(18, 242), Vector2(98, 78)),
		"shape_cells": [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1)],
		"size_cells": Vector2i(2, 2),
		"shape_label": "L-shape 3 cells",
		"atlas_region_name": "odd_efficiency_module",
		"color": Color(0.25, 0.24, 0.30, 0.94),
	},
]

var selected_module_key := "small_core"
var debug_enabled := false
var module_buttons := {}
var module_guides := {}
var module_labels := {}
var module_home_positions := {}
var module_states := {}
var dragging_module_key := ""
var drag_offset := Vector2.ZERO
var drag_start_global := Vector2.ZERO
var drag_origin_local := Vector2.ZERO
var board_surface: Control
var drop_preview: Control
var drop_preview_texture: TextureRect
var module_title_label: Label
var module_detail_label: Label
var module_debug_label: Label
var empty_inventory_label: Label
var return_to_inventory_button: Button
var atlas_texture: Texture2D
var modules: Array[Dictionary] = []


func _init() -> void:
	name = "PowerEquipmentCloseupCandidate"
	mouse_filter = Control.MOUSE_FILTER_STOP
	custom_minimum_size = PANEL_SIZE
	set_process_unhandled_key_input(true)
	modules = _load_modules()
	_initialize_module_states()
	_build()


func reset_selection(module_key: String = "small_core") -> String:
	if _get_module(module_key).is_empty():
		module_key = "small_core"
	_select_module(module_key, false)
	return selected_module_key


func set_debug_enabled(enabled: bool) -> void:
	debug_enabled = enabled
	_refresh_module_detail()


func get_selected_module_key() -> String:
	return selected_module_key


func get_module_data(module_key: String) -> Dictionary:
	return _get_module(module_key).duplicate(true)


func rotate_active_module() -> void:
	_rotate_active_module()


func return_selected_module_to_inventory() -> void:
	_return_module_to_inventory(selected_module_key)


func _initialize_module_states() -> void:
	module_states.clear()
	for module in modules:
		var key := String(module["key"])
		module_states[key] = _make_module_state(key)


func _make_module_state(module_key: String) -> Dictionary:
	return {
		"key": module_key,
		"is_placed": false,
		"grid_anchor": INVALID_GRID_CELL,
		"rotation_index": 0,
		"drag_start_is_placed": false,
		"drag_start_grid_anchor": INVALID_GRID_CELL,
		"drag_start_rotation_index": 0,
	}


func _get_module_state(module_key: String) -> Dictionary:
	if not module_states.has(module_key):
		module_states[module_key] = _make_module_state(module_key)
	return module_states[module_key]


func _set_module_state(module_key: String, state: Dictionary) -> void:
	module_states[module_key] = state


func _is_module_placed(module_key: String) -> bool:
	return bool(_get_module_state(module_key).get("is_placed", false))


func _get_module_grid_anchor(module_key: String) -> Vector2i:
	return Vector2i(_get_module_state(module_key).get("grid_anchor", INVALID_GRID_CELL))


func clear_drag_state() -> void:
	if not dragging_module_key.is_empty():
		var button: Button = module_buttons.get(dragging_module_key, null)
		if button != null:
			button.z_index = 1
	if drop_preview != null:
		drop_preview.visible = false
	if drop_preview_texture != null:
		drop_preview_texture.visible = false
	dragging_module_key = ""
	drag_offset = Vector2.ZERO
	drag_start_global = Vector2.ZERO
	drag_origin_local = Vector2.ZERO


func _unhandled_key_input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_R:
		_rotate_active_module()
		get_viewport().set_input_as_handled()
	elif event is InputEventKey and event.pressed and not event.echo and _is_return_to_inventory_key(event.keycode):
		_return_module_to_inventory(selected_module_key)
		get_viewport().set_input_as_handled()


func _build() -> void:
	atlas_texture = _load_texture_from_png(UI_POWER_BOARD_ATLAS_PATH)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_top", 16)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_bottom", 16)
	add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 8)
	margin.add_child(vbox)

	var title := Label.new()
	title.text = "전력 장비"
	title.add_theme_color_override("font_color", Color(0.96, 0.84, 0.56, 1.0))
	title.add_theme_font_size_override("font_size", 22)
	vbox.add_child(title)

	var description := Label.new()
	description.text = "모듈을 보드에 드래그해 배치합니다. R/우클릭 회전, 보관함으로 되돌리기."
	description.add_theme_color_override("font_color", Color(0.74, 0.82, 0.78, 1.0))
	description.add_theme_font_size_override("font_size", 13)
	vbox.add_child(description)

	board_surface = Control.new()
	board_surface.name = "PowerBoardWorkbench"
	board_surface.custom_minimum_size = WORK_AREA_SIZE

	var body_row := HBoxContainer.new()
	body_row.add_theme_constant_override("separation", 12)
	vbox.add_child(body_row)
	body_row.add_child(board_surface)

	var inventory_bg := ColorRect.new()
	inventory_bg.name = "ModuleInventoryBackground"
	inventory_bg.color = Color(0.042, 0.050, 0.050, 0.98)
	inventory_bg.position = INVENTORY_RECT.position
	inventory_bg.size = INVENTORY_RECT.size
	board_surface.add_child(inventory_bg)

	var board_bg := ColorRect.new()
	board_bg.name = "PowerGridBackground"
	board_bg.color = Color(0.030, 0.036, 0.035, 0.98)
	board_bg.position = BOARD_RECT.position
	board_bg.size = BOARD_RECT.size
	board_surface.add_child(board_bg)

	var inventory_title := Label.new()
	inventory_title.text = "Module Inventory"
	inventory_title.position = INVENTORY_RECT.position + Vector2(16, 14)
	inventory_title.size = Vector2(190, 24)
	inventory_title.add_theme_color_override("font_color", Color(0.90, 0.84, 0.62, 1.0))
	inventory_title.add_theme_font_size_override("font_size", 15)
	board_surface.add_child(inventory_title)

	empty_inventory_label = Label.new()
	empty_inventory_label.text = "모든 모듈 배치됨"
	empty_inventory_label.position = INVENTORY_RECT.position + Vector2(18, 64)
	empty_inventory_label.size = Vector2(180, 44)
	empty_inventory_label.visible = false
	empty_inventory_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	empty_inventory_label.add_theme_color_override("font_color", Color(0.58, 0.68, 0.66, 0.92))
	empty_inventory_label.add_theme_font_size_override("font_size", 12)
	board_surface.add_child(empty_inventory_label)

	var board_title := Label.new()
	board_title.text = "Power Board Grid"
	board_title.position = BOARD_RECT.position + Vector2(18, 14)
	board_title.size = Vector2(210, 24)
	board_title.add_theme_color_override("font_color", Color(0.90, 0.84, 0.62, 1.0))
	board_title.add_theme_font_size_override("font_size", 15)
	board_surface.add_child(board_title)

	var board_hint := Label.new()
	board_hint.text = "겹치거나 보드 밖이면 배치할 수 없음"
	board_hint.position = BOARD_RECT.position + Vector2(18, 38)
	board_hint.size = Vector2(250, 20)
	board_hint.add_theme_color_override("font_color", Color(0.58, 0.68, 0.66, 0.92))
	board_hint.add_theme_font_size_override("font_size", 12)
	board_surface.add_child(board_hint)

	_add_grid(board_surface)

	drop_preview = Control.new()
	drop_preview.name = "PowerDropPreview"
	drop_preview.visible = false
	drop_preview.mouse_filter = Control.MOUSE_FILTER_IGNORE
	board_surface.add_child(drop_preview)

	for module in modules:
		_add_module_button(module)

	var detail_panel := PanelContainer.new()
	detail_panel.name = "PowerModuleDetailPanel"
	detail_panel.custom_minimum_size = Vector2(198, 334)
	body_row.add_child(detail_panel)

	var detail_margin := MarginContainer.new()
	detail_margin.add_theme_constant_override("margin_left", 12)
	detail_margin.add_theme_constant_override("margin_top", 12)
	detail_margin.add_theme_constant_override("margin_right", 12)
	detail_margin.add_theme_constant_override("margin_bottom", 12)
	detail_panel.add_child(detail_margin)

	var detail_box := VBoxContainer.new()
	detail_box.add_theme_constant_override("separation", 8)
	detail_margin.add_child(detail_box)

	var detail_title := Label.new()
	detail_title.text = "선택 모듈"
	detail_title.add_theme_color_override("font_color", Color(0.90, 0.84, 0.62, 1.0))
	detail_title.add_theme_font_size_override("font_size", 15)
	detail_box.add_child(detail_title)

	module_title_label = Label.new()
	module_title_label.add_theme_color_override("font_color", Color(0.92, 0.86, 0.72, 1.0))
	module_title_label.add_theme_font_size_override("font_size", 18)
	detail_box.add_child(module_title_label)

	module_detail_label = Label.new()
	module_detail_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	module_detail_label.add_theme_color_override("font_color", Color(0.74, 0.82, 0.82, 1.0))
	module_detail_label.add_theme_font_size_override("font_size", 13)
	detail_box.add_child(module_detail_label)

	module_debug_label = Label.new()
	module_debug_label.visible = false
	module_debug_label.add_theme_color_override("font_color", Color(0.50, 0.93, 0.96, 1.0))
	module_debug_label.add_theme_font_size_override("font_size", 12)
	detail_box.add_child(module_debug_label)

	return_to_inventory_button = Button.new()
	return_to_inventory_button.text = "보관함으로"
	return_to_inventory_button.pressed.connect(return_selected_module_to_inventory)
	detail_box.add_child(return_to_inventory_button)

	var button_row := HBoxContainer.new()
	button_row.add_theme_constant_override("separation", 8)
	vbox.add_child(button_row)

	var inspect_button := Button.new()
	inspect_button.text = "모듈 확인"
	inspect_button.pressed.connect(_request_module_action.bind("primary"))
	button_row.add_child(inspect_button)

	var explain_button := Button.new()
	explain_button.text = "설명"
	explain_button.pressed.connect(_request_module_action.bind("inspect"))
	button_row.add_child(explain_button)

	var close_button := Button.new()
	close_button.text = "닫기"
	close_button.pressed.connect(func() -> void: close_requested.emit())
	button_row.add_child(close_button)

	var close_hint := Label.new()
	close_hint.text = "ESC 닫기 / Delete·Backspace도 선택 모듈 되돌리기 / 전력 계산과 OutletMode는 미연결"
	close_hint.add_theme_color_override("font_color", Color(0.66, 0.70, 0.68, 0.92))
	close_hint.add_theme_font_size_override("font_size", 12)
	vbox.add_child(close_hint)

	_rebuild_module_views()
	_select_module(selected_module_key, false)


func _add_grid(parent: Control) -> void:
	var grid_backplate := ColorRect.new()
	grid_backplate.name = "PowerGridBackplate"
	grid_backplate.color = Color(0.010, 0.014, 0.014, 0.96)
	grid_backplate.position = GRID_ORIGIN - Vector2(6, 6)
	grid_backplate.size = Vector2(GRID_CELLS.x * CELL_SIZE.x + 9.0, GRID_CELLS.y * CELL_SIZE.y + 9.0)
	grid_backplate.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(grid_backplate)

	for y in GRID_CELLS.y:
		for x in GRID_CELLS.x:
			var cell := ColorRect.new()
			cell.name = "PowerGridCell_%d_%d" % [x, y]
			cell.color = Color(0.105, 0.135, 0.128, 0.98) if (x + y) % 2 == 0 else Color(0.075, 0.100, 0.096, 0.98)
			cell.position = GRID_ORIGIN + Vector2(x * CELL_SIZE.x, y * CELL_SIZE.y)
			cell.size = CELL_SIZE - Vector2(4, 4)
			cell.mouse_filter = Control.MOUSE_FILTER_IGNORE
			parent.add_child(cell)


func _add_module_button(module: Dictionary) -> void:
	var key := String(module["key"])
	var rect: Rect2 = module["rect"]
	var module_size := _get_module_pixel_size(module)

	var guide := Control.new()
	guide.name = "%sDebugRect" % key.capitalize().replace("_", "")
	guide.position = rect.position
	guide.size = module_size
	guide.visible = debug_enabled
	guide.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_populate_shape_visual(guide, _get_module_display_shape_cells(key), Color(0.17, 0.82, 0.92, 0.18), Color(0.45, 0.95, 1.0, 0.22))
	board_surface.add_child(guide)
	module_guides[key] = guide

	var button := Button.new()
	button.name = "%sModuleButton" % key.capitalize().replace("_", "")
	button.text = ""
	button.position = rect.position
	button.size = module_size
	button.tooltip_text = String(module["description"])
	button.flat = true
	button.add_theme_font_size_override("font_size", 12)
	_populate_shape_visual(
		button,
		_get_module_display_shape_cells(key),
		module.get("color", Color.WHITE),
		Color(0.82, 0.94, 0.92, 0.84)
	)
	button.gui_input.connect(_on_module_gui_input.bind(key))
	board_surface.add_child(button)
	module_buttons[key] = button
	module_home_positions[key] = rect.position

	var label := Label.new()
	label.name = "%sModuleLabel" % key.capitalize().replace("_", "")
	label.text = "%s\n%s / %s" % [
		String(module["display_name"]),
		_get_module_size_text(module),
		String(module.get("role", "candidate")),
	]
	label.position = rect.position + Vector2(module_size.x + 10.0, -2.0)
	label.size = Vector2(maxf(72.0, INVENTORY_RECT.size.x - label.position.x - 10.0), maxf(module_size.y + 8.0, 48.0))
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_color_override("font_color", Color(0.70, 0.82, 0.78, 0.96))
	label.add_theme_font_size_override("font_size", 11)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	board_surface.add_child(label)
	module_labels[key] = label


func _rebuild_module_views() -> void:
	var inventory_index := 0
	for module in modules:
		var key := String(module["key"])
		var button: Button = module_buttons.get(key, null)
		if button == null:
			continue

		_refresh_module_visual(key)
		button.visible = true

		if _is_module_placed(key):
			var anchor := _get_module_grid_anchor(key)
			button.position = GRID_ORIGIN + Vector2(anchor.x * CELL_SIZE.x, anchor.y * CELL_SIZE.y)
			var label: Label = module_labels.get(key, null)
			if label != null:
				label.visible = false
		else:
			var module_size := button.size
			var slot_position := _get_inventory_slot_position(inventory_index, module_size)
			module_home_positions[key] = slot_position
			button.position = slot_position
			var label: Label = module_labels.get(key, null)
			if label != null:
				label.visible = true
				label.text = "%s\n%s / %s" % [
					String(module["display_name"]),
					_get_display_shape_text(key),
					String(module.get("role", "candidate")),
				]
				label.position = slot_position + Vector2(module_size.x + 10.0, -2.0)
				label.size = Vector2(
					maxf(72.0, INVENTORY_RECT.size.x - label.position.x - 10.0),
					maxf(module_size.y + 8.0, 48.0)
				)
			inventory_index += 1

		_sync_module_guide(key)

	if empty_inventory_label != null:
		empty_inventory_label.visible = inventory_index == 0
	_refresh_module_detail()


func _get_inventory_slot_position(inventory_index: int, module_size: Vector2) -> Vector2:
	var y := INVENTORY_SLOT_START.y + float(inventory_index) * maxf(INVENTORY_SLOT_GAP, module_size.y + 16.0)
	return Vector2(INVENTORY_SLOT_START.x, y)


func _get_module_pixel_size(module: Dictionary) -> Vector2:
	var size_cells := _get_module_size_cells(module)
	return Vector2(CELL_SIZE.x * size_cells.x - 2.0, CELL_SIZE.y * size_cells.y - 2.0)


func _get_module_size_text(module: Dictionary) -> String:
	if module.has("shape_label"):
		return String(module["shape_label"])
	var size_cells := _get_module_size_cells(module)
	var shape_cells := _get_module_shape_cells(module)
	return _format_shape_text(shape_cells, size_cells)


func _get_display_shape_text(module_key: String) -> String:
	var shape_cells := _get_module_display_shape_cells(module_key)
	return _format_shape_text(shape_cells, _get_shape_size_cells(shape_cells))


func _format_shape_text(shape_cells: Array[Vector2i], size_cells: Vector2i) -> String:
	if shape_cells.size() == size_cells.x * size_cells.y:
		return "%dx%d" % [size_cells.x, size_cells.y]
	if shape_cells.size() == 3 and size_cells == Vector2i(2, 2):
		return "L-shape 3 cells"
	return "%d cells / bbox %dx%d" % [shape_cells.size(), size_cells.x, size_cells.y]


func _rotate_active_module() -> void:
	var active_module_key := dragging_module_key if not dragging_module_key.is_empty() else selected_module_key
	if active_module_key.is_empty():
		return
	_rotate_module(active_module_key)


func _rotate_module(module_key: String) -> void:
	var module := _get_module(module_key)
	if module.is_empty():
		return

	var previous_rotation := _get_module_rotation(module_key)
	var next_rotation := (previous_rotation + 1) % 4
	_set_module_rotation(module_key, next_rotation)

	var was_placed := _is_module_placed(module_key)
	var placed_cell := _get_module_grid_anchor(module_key)
	var shape_cells := _get_module_display_shape_cells(module_key)
	if was_placed and dragging_module_key != module_key and not _is_drop_cell_available(module_key, placed_cell, shape_cells):
		_set_module_rotation(module_key, previous_rotation)
		_rebuild_module_views()
		var invalid_payload := module.duplicate(true)
		invalid_payload["drop_reason"] = "회전 후 겹치거나 보드 밖이라"
		module_action_requested.emit(module_key, "invalid_rotate", invalid_payload)
		return

	_refresh_module_visual(module_key)
	if dragging_module_key == module_key:
		_update_drop_preview(module_key)
	else:
		_rebuild_module_views()
	_refresh_module_detail()

	var payload := module.duplicate(true)
	payload["rotation_degrees"] = _get_module_rotation_degrees(module_key)
	module_action_requested.emit(module_key, "rotate_noop", payload)


func _return_module_to_inventory(module_key: String) -> void:
	var module := _get_module(module_key)
	if module.is_empty() or not _is_module_placed(module_key):
		return

	clear_drag_state()
	var state := _get_module_state(module_key)
	state["is_placed"] = false
	state["grid_anchor"] = INVALID_GRID_CELL
	# Returning to inventory resets rotation so the palette always starts from the Resource shape.
	state["rotation_index"] = 0
	_set_module_state(module_key, state)
	_rebuild_module_views()
	_select_module(module_key)

	var payload := module.duplicate(true)
	payload["rotation_degrees"] = 0
	module_action_requested.emit(module_key, "return_to_inventory", payload)


func _refresh_module_visual(module_key: String) -> void:
	var module := _get_module(module_key)
	var button: Button = module_buttons.get(module_key, null)
	if module.is_empty() or button == null:
		return

	var shape_cells := _get_module_display_shape_cells(module_key)
	var size_cells := _get_shape_size_cells(shape_cells)
	var module_size := Vector2(CELL_SIZE.x * size_cells.x - 2.0, CELL_SIZE.y * size_cells.y - 2.0)
	button.size = module_size
	_populate_shape_visual(
		button,
		shape_cells,
		module.get("color", Color.WHITE),
		Color(0.82, 0.94, 0.92, 0.84)
	)

	if dragging_module_key != module_key:
		if _is_module_placed(module_key):
			var cell := _get_module_grid_anchor(module_key)
			button.position = GRID_ORIGIN + Vector2(cell.x * CELL_SIZE.x, cell.y * CELL_SIZE.y)
		else:
			button.position = module_home_positions.get(module_key, Vector2.ZERO)

	var guide: Control = module_guides.get(module_key, null)
	if guide != null:
		guide.size = module_size
		var guide_color := Color(1.0, 0.78, 0.20, 0.24) if module_key == selected_module_key else Color(0.17, 0.82, 0.92, 0.18)
		_populate_shape_visual(guide, shape_cells, guide_color, guide_color.lightened(0.35))
		_sync_module_guide(module_key)

	var label: Label = module_labels.get(module_key, null)
	if label != null:
		label.text = "%s\n%s / %s" % [
			String(module["display_name"]),
			_get_display_shape_text(module_key),
			String(module.get("role", "candidate")),
		]


func _get_module_rotation(module_key: String) -> int:
	return int(_get_module_state(module_key).get("rotation_index", 0)) % 4


func _set_module_rotation(module_key: String, rotation_index: int) -> void:
	var state := _get_module_state(module_key)
	state["rotation_index"] = rotation_index % 4
	_set_module_state(module_key, state)


func _get_module_rotation_degrees(module_key: String) -> int:
	return _get_module_rotation(module_key) * 90


func _is_return_to_inventory_key(keycode: Key) -> bool:
	return keycode == KEY_DELETE or keycode == KEY_BACKSPACE


func _get_module_display_shape_cells(module_key: String) -> Array[Vector2i]:
	var module := _get_module(module_key)
	var shape_cells := _get_module_shape_cells(module)
	for _step in range(_get_module_rotation(module_key)):
		shape_cells = POWER_MODULE_DEFINITION_SCRIPT.rotate_shape_cells_clockwise(shape_cells)
	return shape_cells


func _on_module_gui_input(event: InputEvent, module_key: String) -> void:
	var button: Button = module_buttons.get(module_key, null)
	if button == null:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_select_module(module_key)
			dragging_module_key = module_key
			drag_offset = button.get_global_mouse_position() - button.global_position
			drag_start_global = button.global_position
			drag_origin_local = button.position
			_capture_drag_start_state(module_key)
			button.z_index = 8
			_update_drop_preview(module_key)
			get_viewport().set_input_as_handled()
		elif dragging_module_key == module_key:
			_finish_module_drag(module_key)
			get_viewport().set_input_as_handled()
	elif event is InputEventMouseMotion and dragging_module_key == module_key:
		button.global_position = button.get_global_mouse_position() - drag_offset
		_sync_module_guide(module_key)
		_update_drop_preview(module_key)
		get_viewport().set_input_as_handled()
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		_select_module(module_key)
		_rotate_module(module_key)
		get_viewport().set_input_as_handled()


func _finish_module_drag(module_key: String) -> void:
	var button: Button = module_buttons.get(module_key, null)
	var module := _get_module(module_key)
	if button == null or module.is_empty():
		clear_drag_state()
		return

	button.z_index = 1
	if button.global_position.distance_to(drag_start_global) < 4.0:
		_sync_module_guide(module_key)
		clear_drag_state()
		_request_module_action("focus")
		return

	if bool(_get_module_state(module_key).get("drag_start_is_placed", false)) and _is_button_over_inventory(button):
		_return_module_to_inventory(module_key)
		clear_drag_state()
		return

	var drop_candidate := _get_drop_candidate(module_key)
	if bool(drop_candidate.get("valid", false)):
		var cell: Vector2i = drop_candidate["cell"]
		var state := _get_module_state(module_key)
		state["is_placed"] = true
		state["grid_anchor"] = cell
		state["rotation_index"] = _get_module_rotation(module_key)
		_set_module_state(module_key, state)
		selected_module_key = module_key
		_rebuild_module_views()
		module_dropped.emit(module_key, cell, module.duplicate(true))
	else:
		_restore_module_to_drag_origin(module_key)
		var invalid_payload := module.duplicate(true)
		invalid_payload["drop_reason"] = String(drop_candidate.get("reason", "invalid drop /"))
		module_action_requested.emit(module_key, "invalid_drop", invalid_payload)

	_sync_module_guide(module_key)
	clear_drag_state()
	_refresh_module_detail()


func _capture_drag_start_state(module_key: String) -> void:
	var state := _get_module_state(module_key)
	state["drag_start_is_placed"] = bool(state.get("is_placed", false))
	state["drag_start_grid_anchor"] = Vector2i(state.get("grid_anchor", INVALID_GRID_CELL))
	state["drag_start_rotation_index"] = int(state.get("rotation_index", 0)) % 4
	_set_module_state(module_key, state)


func _restore_module_to_drag_origin(module_key: String) -> void:
	var button: Button = module_buttons.get(module_key, null)
	if button == null:
		return

	var state := _get_module_state(module_key)
	state["is_placed"] = bool(state.get("drag_start_is_placed", false))
	state["grid_anchor"] = Vector2i(state.get("drag_start_grid_anchor", INVALID_GRID_CELL))
	state["rotation_index"] = int(state.get("drag_start_rotation_index", 0)) % 4
	_set_module_state(module_key, state)
	_rebuild_module_views()


func _get_grid_global_rect() -> Rect2:
	if board_surface == null:
		return Rect2()
	return Rect2(
		board_surface.global_position + GRID_ORIGIN,
		Vector2(GRID_CELLS.x * CELL_SIZE.x, GRID_CELLS.y * CELL_SIZE.y)
	)


func _is_button_over_inventory(button: Control) -> bool:
	if board_surface == null or button == null:
		return false
	var inventory_rect := Rect2(board_surface.global_position + INVENTORY_RECT.position, INVENTORY_RECT.size)
	return inventory_rect.has_point(button.global_position + button.size * 0.5)


func _sync_module_guide(module_key: String) -> void:
	var guide: Control = module_guides.get(module_key, null)
	var button: Button = module_buttons.get(module_key, null)
	if guide == null or button == null:
		return
	guide.position = button.position
	guide.size = button.size


func _get_drop_candidate(module_key: String) -> Dictionary:
	var button: Button = module_buttons.get(module_key, null)
	var module := _get_module(module_key)
	if button == null or module.is_empty():
		return {"inside": false, "valid": false, "reason": "module unavailable /"}

	var grid_rect := _get_grid_global_rect()
	var center := button.global_position + button.size * 0.5
	if not grid_rect.has_point(center):
		return {"inside": false, "valid": false, "reason": "grid 밖이라"}

	var shape_cells := _get_module_display_shape_cells(module_key)
	var size_cells := _get_shape_size_cells(shape_cells)
	var local_top_left := button.global_position - grid_rect.position
	var cell := Vector2i(
		roundi(local_top_left.x / CELL_SIZE.x),
		roundi(local_top_left.y / CELL_SIZE.y)
	)
	var valid := _is_drop_cell_available(module_key, cell, shape_cells)
	var reason := ""
	if not valid:
		reason = "보드 밖이라" if not _are_shape_cells_inside_grid(cell, shape_cells) else "다른 모듈과 겹쳐서"
	return {
		"inside": true,
		"valid": valid,
		"cell": cell,
		"size_cells": size_cells,
		"shape_cells": shape_cells,
		"reason": reason,
	}


func _is_drop_cell_available(module_key: String, cell: Vector2i, shape_cells: Array[Vector2i]) -> bool:
	if not _are_shape_cells_inside_grid(cell, shape_cells):
		return false

	return not POWER_MODULE_DEFINITION_SCRIPT.shape_cells_overlap_any(
		cell,
		shape_cells,
		_get_placed_module_entries(),
		module_key
	)


func _get_placed_module_entries() -> Array[Dictionary]:
	var entries: Array[Dictionary] = []
	for module in modules:
		var other_module_key := String(module["key"])
		if not _is_module_placed(other_module_key):
			continue
		var other_module := _get_module(other_module_key)
		if other_module.is_empty():
			continue
		entries.append({
			"key": other_module_key,
			"anchor": _get_module_grid_anchor(other_module_key),
			"shape_cells": _get_module_display_shape_cells(other_module_key),
		})
	return entries


func _are_shape_cells_inside_grid(cell: Vector2i, shape_cells: Array[Vector2i]) -> bool:
	return POWER_MODULE_DEFINITION_SCRIPT.shape_cells_are_inside_grid(cell, shape_cells, GRID_CELLS)


func _is_cell_inside_module(cell: Vector2i, module_cell: Vector2i, shape_cells: Array[Vector2i]) -> bool:
	for offset in shape_cells:
		if cell == module_cell + offset:
			return true
	return false


func _update_drop_preview(module_key: String) -> void:
	if drop_preview == null:
		return
	var candidate := _get_drop_candidate(module_key)
	if not bool(candidate.get("inside", false)):
		drop_preview.visible = false
		if drop_preview_texture != null:
			drop_preview_texture.visible = false
		return

	var cell: Vector2i = candidate["cell"]
	var size_cells: Vector2i = candidate["size_cells"]
	var shape_cells: Array[Vector2i] = candidate["shape_cells"]
	var preview_color := Color(0.20, 0.90, 0.68, 0.30) if bool(candidate.get("valid", false)) else Color(0.96, 0.18, 0.14, 0.34)
	drop_preview.visible = true
	drop_preview.position = GRID_ORIGIN + Vector2(cell.x * CELL_SIZE.x, cell.y * CELL_SIZE.y)
	drop_preview.size = Vector2(size_cells.x * CELL_SIZE.x, size_cells.y * CELL_SIZE.y)
	_populate_shape_visual(drop_preview, shape_cells, preview_color, preview_color.lightened(0.25))


func _request_module_action(action_key: String) -> void:
	var module := _get_module(selected_module_key)
	if module.is_empty():
		return
	module_action_requested.emit(selected_module_key, action_key, module.duplicate(true))


func _select_module(module_key: String, emit_signal := true) -> void:
	var module := _get_module(module_key)
	if module.is_empty():
		return

	selected_module_key = module_key
	for key in module_buttons.keys():
		var button: Button = module_buttons[key]
		var selected := String(key) == selected_module_key
		button.text = ""
		if selected:
			button.modulate = Color(1.16, 1.08, 0.86, 1.0)
		else:
			button.modulate = Color.WHITE

		var label: Label = module_labels.get(String(key), null)
		if label != null:
			label.add_theme_color_override(
				"font_color",
				Color(0.98, 0.86, 0.48, 1.0) if selected else Color(0.70, 0.82, 0.78, 0.96)
			)
	_refresh_module_detail()
	if emit_signal:
		selection_changed.emit(module_key, module.duplicate(true))


func _refresh_module_detail() -> void:
	var module := _get_module(selected_module_key)
	if module.is_empty():
		return

	module_title_label.text = String(module["display_name"])
	module_detail_label.text = "상태: %s\n크기: %s\n회전: %d도\n후보 효과: %s\n\n%s\n\nR/우클릭: 회전\n보관함으로: 배치 모듈 되돌리기\n아직 실제 전력 계산 없음." % [
		"board 배치됨" if _is_module_placed(selected_module_key) else "inventory",
		_get_display_shape_text(selected_module_key),
		_get_module_rotation_degrees(selected_module_key),
		String(module.get("effect", "효과 후보 없음")),
		String(module["description"]),
	]

	if return_to_inventory_button != null:
		return_to_inventory_button.disabled = not _is_module_placed(selected_module_key)

	var rect: Rect2 = module["rect"]
	module_debug_label.visible = debug_enabled
	if debug_enabled:
		var grid_pos = _get_module_grid_anchor(selected_module_key) if _is_module_placed(selected_module_key) else "palette"
		module_debug_label.text = "key: %s\nrole: %s\ncandidate action: %s\nmodule rect: %s\ngrid: %s\nrotation: %d\nno-op status: OutletMode / SurvivalState disabled" % [
			String(module["key"]),
			String(module["role"]),
			String(module["candidate_action"]),
			_format_rect(rect),
			str(grid_pos),
			_get_module_rotation_degrees(selected_module_key),
		]

	for key in module_guides.keys():
		var guide: Control = module_guides[key]
		guide.visible = debug_enabled
		var guide_color := Color(1.0, 0.78, 0.20, 0.24) if String(key) == selected_module_key else Color(0.17, 0.82, 0.92, 0.18)
		_populate_shape_visual(guide, _get_module_display_shape_cells(String(key)), guide_color, guide_color.lightened(0.35))
		_sync_module_guide(String(key))


func _get_module(module_key: String) -> Dictionary:
	for module in modules:
		if String(module["key"]) == module_key:
			return module
	return {}


func _load_modules() -> Array[Dictionary]:
	var loaded_modules: Array[Dictionary] = []
	var seen_keys := {}

	for path in MODULE_RESOURCE_PATHS:
		var resource := load(path)
		if resource == null:
			push_warning("PowerBoardCandidate could not load power module Resource: %s" % path)
			continue
		if resource.get_script() != POWER_MODULE_DEFINITION_SCRIPT:
			push_warning("PowerBoardCandidate skipped non-PowerModuleDefinition Resource: %s" % path)
			continue
		if not resource.is_valid_definition():
			push_warning("PowerBoardCandidate skipped invalid PowerModuleDefinition: %s" % path)
			continue

		var module := _module_definition_to_dictionary(resource)
		var key := String(module["key"])
		if seen_keys.has(key):
			push_warning("PowerBoardCandidate skipped duplicate power module key: %s" % key)
			continue

		loaded_modules.append(module)
		seen_keys[key] = true

	if loaded_modules.is_empty():
		push_warning("PowerBoardCandidate using fallback module data because no Resource modules loaded.")
		for module in FALLBACK_MODULES:
			loaded_modules.append(module.duplicate(true))

	return loaded_modules


func _module_definition_to_dictionary(definition: Resource) -> Dictionary:
	var size_cells: Vector2i = definition.get_size_cells()
	return {
		"key": definition.key,
		"display_name": definition.display_name,
		"role": definition.role,
		"description": definition.description,
		"effect": definition.get_effect_label(),
		"candidate_action": definition.get_candidate_action(),
		"rect": Rect2(
			definition.inventory_position,
			Vector2(CELL_SIZE.x * size_cells.x - 2.0, CELL_SIZE.y * size_cells.y - 2.0)
		),
		"shape_cells": definition.get_shape_cells(),
		"size_cells": size_cells,
		"shape_label": definition.get_shape_label(),
		"atlas_region_name": definition.atlas_region_name,
		"color": definition.color,
		"is_prototype": definition.is_prototype,
	}


func _get_module_shape_cells(module: Dictionary) -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	var raw_cells: Array = module.get("shape_cells", [])
	for raw_cell in raw_cells:
		cells.append(Vector2i(raw_cell))
	if cells.is_empty():
		cells.append(Vector2i.ZERO)
	return cells


func _get_module_size_cells(module: Dictionary) -> Vector2i:
	return _get_shape_size_cells(_get_module_shape_cells(module))


func _get_shape_size_cells(shape_cells: Array[Vector2i]) -> Vector2i:
	var size_cells := Vector2i.ONE
	for cell in shape_cells:
		size_cells.x = maxi(size_cells.x, cell.x + 1)
		size_cells.y = maxi(size_cells.y, cell.y + 1)
	return size_cells


func _populate_shape_visual(parent: Control, shape_cells: Array[Vector2i], fill_color: Color, edge_color: Color) -> void:
	for child in parent.get_children():
		parent.remove_child(child)
		child.queue_free()

	for offset in shape_cells:
		var cell := ColorRect.new()
		cell.name = "ShapeCell_%d_%d" % [offset.x, offset.y]
		cell.position = Vector2(offset.x * CELL_SIZE.x, offset.y * CELL_SIZE.y)
		cell.size = CELL_SIZE - Vector2(4, 4)
		cell.color = edge_color
		cell.mouse_filter = Control.MOUSE_FILTER_IGNORE
		parent.add_child(cell)

		var core := ColorRect.new()
		core.name = "ShapeCellCore_%d_%d" % [offset.x, offset.y]
		core.position = cell.position + Vector2(4, 4)
		core.size = CELL_SIZE - Vector2(12, 12)
		core.color = fill_color
		core.mouse_filter = Control.MOUSE_FILTER_IGNORE
		parent.add_child(core)


func _load_texture_from_png(path: String) -> Texture2D:
	var image := Image.new()
	var error := image.load(path)
	if error != OK:
		push_warning("PowerBoardCandidate could not load optional PNG: %s" % path)
		return null
	return ImageTexture.create_from_image(image)


func _make_atlas_texture(region: Rect2) -> Texture2D:
	if atlas_texture == null:
		return null
	var texture := AtlasTexture.new()
	texture.atlas = atlas_texture
	texture.region = _scale_atlas_region(region)
	return texture


func _scale_atlas_region(region: Rect2) -> Rect2:
	if atlas_texture == null:
		return region
	var texture_size := atlas_texture.get_size()
	if texture_size == ATLAS_SOURCE_SIZE:
		return region
	return Rect2(
		Vector2(region.position.x * texture_size.x / ATLAS_SOURCE_SIZE.x, region.position.y * texture_size.y / ATLAS_SOURCE_SIZE.y),
		Vector2(region.size.x * texture_size.x / ATLAS_SOURCE_SIZE.x, region.size.y * texture_size.y / ATLAS_SOURCE_SIZE.y)
	)


func _get_module_atlas_region(module_key: String) -> Rect2:
	var region_name := _get_module_atlas_region_name(module_key)
	return MODULE_ATLAS_REGIONS.get(region_name, Rect2())


func _has_module_atlas_region(module_key: String) -> bool:
	var region_name := _get_module_atlas_region_name(module_key)
	return atlas_texture != null and MODULE_ATLAS_REGIONS.has(region_name)


func _get_module_atlas_region_name(module_key: String) -> String:
	var module := _get_module(module_key)
	if module.is_empty():
		return module_key
	var atlas_region_name := String(module.get("atlas_region_name", ""))
	if atlas_region_name.is_empty():
		return module_key
	return atlas_region_name


func _format_rect(rect: Rect2) -> String:
	return "pos=%s size=%s" % [str(rect.position.round()), str(rect.size.round())]
