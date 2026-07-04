extends PanelContainer
class_name PowerBoardCandidate

signal close_requested
signal module_action_requested(module_key: String, action_key: String, module: Dictionary)
signal module_dropped(module_key: String, cell: Vector2i, module: Dictionary)
signal selection_changed(module_key: String, module: Dictionary)

const PANEL_SIZE := Vector2(690, 500)
const GRID_ORIGIN := Vector2(34, 44)
const GRID_CELLS := Vector2i(7, 5)
const CELL_SIZE := Vector2(46, 38)
const UI_POWER_BOARD_ATLAS_PATH := "res://assets/art/ui/atlases/ui_power_board_atlas.png"
const ATLAS_SOURCE_SIZE := Vector2(1254, 1254)
const ATLAS_REGION_BOARD_FRAME := Rect2(Vector2(38, 40), Vector2(648, 626))
const ATLAS_REGION_GRID_CELL_NORMAL := Rect2(Vector2(714, 42), Vector2(210, 210))
const ATLAS_REGION_GRID_CELL_VALID := Rect2(Vector2(980, 44), Vector2(220, 210))
const ATLAS_REGION_GRID_CELL_INVALID := Rect2(Vector2(980, 290), Vector2(220, 214))

const MODULE_ATLAS_REGIONS := {
	"small_core": Rect2(Vector2(715, 318), Vector2(106, 120)),
	"laptop_adapter": Rect2(Vector2(718, 548), Vector2(294, 198)),
	"comm_module": Rect2(Vector2(1080, 585), Vector2(122, 290)),
	"odd_efficiency_module": Rect2(Vector2(882, 876), Vector2(342, 330)),
}

const MODULES := [
	{
		"key": "small_core",
		"display_name": "Small Core",
		"role": "power_module",
		"description": "작고 단순한 1x1 전력 코어 후보입니다. 배치해도 실제 전력 계산은 없습니다.",
		"candidate_action": "place_small_core_noop",
		"rect": Rect2(Vector2(420, 56), Vector2(46, 38)),
		"size_cells": Vector2i(1, 1),
		"color": Color(0.16, 0.38, 0.48, 0.92),
	},
	{
		"key": "laptop_adapter",
		"display_name": "Laptop Adapter",
		"role": "power_adapter",
		"description": "노트북 전원을 우선 배분할 2x1 어댑터 후보입니다. OutletMode와는 아직 연결하지 않았습니다.",
		"candidate_action": "place_laptop_adapter_noop",
		"rect": Rect2(Vector2(492, 56), Vector2(92, 38)),
		"size_cells": Vector2i(2, 1),
		"color": Color(0.34, 0.28, 0.16, 0.94),
	},
	{
		"key": "comm_module",
		"display_name": "Comm Module",
		"role": "power_routing",
		"description": "통신 장비 전원을 세로로 잡아주는 1x2 후보 모듈입니다. 실제 장치 active 값은 바꾸지 않습니다.",
		"candidate_action": "place_comm_module_noop",
		"rect": Rect2(Vector2(420, 124), Vector2(46, 76)),
		"size_cells": Vector2i(1, 2),
		"color": Color(0.48, 0.22, 0.14, 0.92),
	},
	{
		"key": "odd_efficiency_module",
		"display_name": "Odd Efficiency",
		"role": "power_efficiency",
		"description": "효율은 좋아 보이지만 모양이 애매한 2x2 후보 모듈입니다. L-shape은 다음 단계 후보입니다.",
		"candidate_action": "place_efficiency_module_noop",
		"rect": Rect2(Vector2(492, 124), Vector2(92, 76)),
		"size_cells": Vector2i(2, 2),
		"color": Color(0.25, 0.24, 0.30, 0.94),
	},
]

var selected_module_key := "small_core"
var debug_enabled := false
var module_buttons := {}
var module_guides := {}
var module_home_positions := {}
var module_grid_positions := {}
var dragging_module_key := ""
var drag_offset := Vector2.ZERO
var drag_start_global := Vector2.ZERO
var drag_origin_local := Vector2.ZERO
var drag_origin_had_cell := false
var drag_origin_cell := Vector2i.ZERO
var board_surface: Control
var drop_preview: ColorRect
var drop_preview_texture: TextureRect
var module_title_label: Label
var module_detail_label: Label
var module_debug_label: Label
var atlas_texture: Texture2D


func _init() -> void:
	name = "PowerEquipmentCloseupCandidate"
	mouse_filter = Control.MOUSE_FILTER_STOP
	custom_minimum_size = PANEL_SIZE
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
	drag_origin_had_cell = false
	drag_origin_cell = Vector2i.ZERO


func _build() -> void:
	atlas_texture = _load_texture_from_png(UI_POWER_BOARD_ATLAS_PATH)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_top", 16)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_bottom", 16)
	add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	margin.add_child(vbox)

	var title := Label.new()
	title.text = "전력 장비"
	title.add_theme_color_override("font_color", Color(0.96, 0.84, 0.56, 1.0))
	title.add_theme_font_size_override("font_size", 22)
	vbox.add_child(title)

	var description := Label.new()
	description.text = "제한된 전력을 모듈로 재배치하는 장치 후보입니다. OutletMode / SurvivalState 연결 없음."
	description.add_theme_color_override("font_color", Color(0.74, 0.82, 0.78, 1.0))
	description.add_theme_font_size_override("font_size", 13)
	vbox.add_child(description)

	board_surface = Control.new()
	board_surface.name = "PowerBoardMock"
	board_surface.custom_minimum_size = Vector2(632, 316)
	vbox.add_child(board_surface)

	var board_background := ColorRect.new()
	board_background.color = Color(0.045, 0.052, 0.048, 0.96)
	board_background.position = Vector2.ZERO
	board_background.size = Vector2(632, 316)
	board_surface.add_child(board_background)

	if atlas_texture != null:
		_add_atlas_region(
			board_surface,
			"PowerBoardFrameRegion",
			ATLAS_REGION_BOARD_FRAME,
			Vector2(8, 18),
			Vector2(378, 262),
			Color(1.0, 1.0, 1.0, 0.92)
		)

	_add_grid(board_surface)

	drop_preview = ColorRect.new()
	drop_preview.name = "PowerDropPreview"
	drop_preview.visible = false
	drop_preview.mouse_filter = Control.MOUSE_FILTER_IGNORE
	drop_preview.color = Color(0.22, 0.88, 0.72, 0.24)
	board_surface.add_child(drop_preview)

	if atlas_texture != null:
		drop_preview_texture = TextureRect.new()
		drop_preview_texture.name = "PowerDropPreviewTexture"
		drop_preview_texture.visible = false
		drop_preview_texture.stretch_mode = TextureRect.STRETCH_SCALE
		drop_preview_texture.mouse_filter = Control.MOUSE_FILTER_IGNORE
		board_surface.add_child(drop_preview_texture)

	for module in MODULES:
		_add_module_button(module)

	module_title_label = Label.new()
	module_title_label.add_theme_color_override("font_color", Color(0.92, 0.86, 0.72, 1.0))
	module_title_label.add_theme_font_size_override("font_size", 18)
	vbox.add_child(module_title_label)

	module_detail_label = Label.new()
	module_detail_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	module_detail_label.add_theme_color_override("font_color", Color(0.74, 0.82, 0.82, 1.0))
	module_detail_label.add_theme_font_size_override("font_size", 13)
	vbox.add_child(module_detail_label)

	module_debug_label = Label.new()
	module_debug_label.visible = false
	module_debug_label.add_theme_color_override("font_color", Color(0.50, 0.93, 0.96, 1.0))
	module_debug_label.add_theme_font_size_override("font_size", 12)
	vbox.add_child(module_debug_label)

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
	close_hint.text = "ESC 닫기 / 전력 계산과 OutletMode는 아직 연결하지 않음"
	close_hint.add_theme_color_override("font_color", Color(0.66, 0.70, 0.68, 0.92))
	close_hint.add_theme_font_size_override("font_size", 12)
	vbox.add_child(close_hint)

	_select_module(selected_module_key, false)


func _add_grid(parent: Control) -> void:
	for y in GRID_CELLS.y:
		for x in GRID_CELLS.x:
			if atlas_texture != null:
				var texture_cell := TextureRect.new()
				texture_cell.name = "PowerGridCell_%d_%d" % [x, y]
				texture_cell.texture = _make_atlas_texture(ATLAS_REGION_GRID_CELL_NORMAL)
				texture_cell.position = GRID_ORIGIN + Vector2(x * CELL_SIZE.x, y * CELL_SIZE.y)
				texture_cell.size = CELL_SIZE - Vector2(3, 3)
				texture_cell.stretch_mode = TextureRect.STRETCH_SCALE
				texture_cell.modulate = Color(0.84, 0.90, 0.88, 0.72) if (x + y) % 2 == 0 else Color(0.72, 0.80, 0.78, 0.68)
				texture_cell.mouse_filter = Control.MOUSE_FILTER_IGNORE
				parent.add_child(texture_cell)
				continue

			var cell := ColorRect.new()
			cell.name = "PowerGridCell_%d_%d" % [x, y]
			cell.color = Color(0.09, 0.12, 0.11, 0.72) if (x + y) % 2 == 0 else Color(0.07, 0.09, 0.085, 0.72)
			cell.position = GRID_ORIGIN + Vector2(x * CELL_SIZE.x, y * CELL_SIZE.y)
			cell.size = CELL_SIZE - Vector2(3, 3)
			cell.mouse_filter = Control.MOUSE_FILTER_IGNORE
			parent.add_child(cell)


func _add_module_button(module: Dictionary) -> void:
	var key := String(module["key"])
	var rect: Rect2 = module["rect"]
	var module_size := _get_module_pixel_size(module)

	var guide := ColorRect.new()
	guide.name = "%sDebugRect" % key.capitalize().replace("_", "")
	guide.color = Color(0.17, 0.82, 0.92, 0.18)
	guide.position = rect.position
	guide.size = module_size
	guide.visible = debug_enabled
	guide.mouse_filter = Control.MOUSE_FILTER_IGNORE
	board_surface.add_child(guide)
	module_guides[key] = guide

	var button := Button.new()
	button.name = "%sModuleButton" % key.capitalize().replace("_", "")
	button.text = String(module["display_name"])
	button.position = rect.position
	button.size = module_size
	button.tooltip_text = String(module["description"])
	if _has_module_atlas_region(key):
		button.icon = _make_atlas_texture(_get_module_atlas_region(key))
		button.expand_icon = true
		button.text = ""
		button.modulate = Color(1.0, 1.0, 1.0, 1.0)
	else:
		button.modulate = module["color"]
	button.gui_input.connect(_on_module_gui_input.bind(key))
	board_surface.add_child(button)
	module_buttons[key] = button
	module_home_positions[key] = rect.position


func _get_module_pixel_size(module: Dictionary) -> Vector2:
	var size_cells: Vector2i = module.get("size_cells", Vector2i(1, 1))
	return Vector2(CELL_SIZE.x * size_cells.x - 2.0, CELL_SIZE.y * size_cells.y - 2.0)


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
			drag_origin_had_cell = module_grid_positions.has(module_key)
			drag_origin_cell = module_grid_positions.get(module_key, Vector2i.ZERO)
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

	var drop_candidate := _get_drop_candidate(module_key)
	if bool(drop_candidate.get("valid", false)):
		var cell: Vector2i = drop_candidate["cell"]
		var grid_rect := _get_grid_global_rect()
		button.global_position = grid_rect.position + Vector2(cell.x * CELL_SIZE.x, cell.y * CELL_SIZE.y)
		module_grid_positions[module_key] = cell
		selected_module_key = module_key
		module_dropped.emit(module_key, cell, module.duplicate(true))
	else:
		button.position = drag_origin_local
		if drag_origin_had_cell:
			module_grid_positions[module_key] = drag_origin_cell
		else:
			module_grid_positions.erase(module_key)
		var invalid_payload := module.duplicate(true)
		invalid_payload["drop_reason"] = String(drop_candidate.get("reason", "invalid drop /"))
		module_action_requested.emit(module_key, "invalid_drop", invalid_payload)

	_sync_module_guide(module_key)
	clear_drag_state()
	_refresh_module_detail()


func _get_grid_global_rect() -> Rect2:
	if board_surface == null:
		return Rect2()
	return Rect2(
		board_surface.global_position + GRID_ORIGIN,
		Vector2(GRID_CELLS.x * CELL_SIZE.x, GRID_CELLS.y * CELL_SIZE.y)
	)


func _sync_module_guide(module_key: String) -> void:
	var guide: ColorRect = module_guides.get(module_key, null)
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

	var size_cells: Vector2i = module.get("size_cells", Vector2i(1, 1))
	var local_top_left := button.global_position - grid_rect.position
	var cell := Vector2i(
		clampi(roundi(local_top_left.x / CELL_SIZE.x), 0, GRID_CELLS.x - size_cells.x),
		clampi(roundi(local_top_left.y / CELL_SIZE.y), 0, GRID_CELLS.y - size_cells.y)
	)
	var valid := _is_drop_cell_available(module_key, cell, size_cells)
	return {
		"inside": true,
		"valid": valid,
		"cell": cell,
		"size_cells": size_cells,
		"reason": "" if valid else "다른 모듈과 겹쳐서",
	}


func _is_drop_cell_available(module_key: String, cell: Vector2i, size_cells: Vector2i) -> bool:
	for y in range(cell.y, cell.y + size_cells.y):
		for x in range(cell.x, cell.x + size_cells.x):
			if x < 0 or y < 0 or x >= GRID_CELLS.x or y >= GRID_CELLS.y:
				return false
			var check_cell := Vector2i(x, y)
			for other_key in module_grid_positions.keys():
				if String(other_key) == module_key:
					continue
				var other_module := _get_module(String(other_key))
				if other_module.is_empty():
					continue
				var other_cell: Vector2i = module_grid_positions[other_key]
				var other_size: Vector2i = other_module.get("size_cells", Vector2i(1, 1))
				if _is_cell_inside_module(check_cell, other_cell, other_size):
					return false
	return true


func _is_cell_inside_module(cell: Vector2i, module_cell: Vector2i, size_cells: Vector2i) -> bool:
	return (
		cell.x >= module_cell.x
		and cell.y >= module_cell.y
		and cell.x < module_cell.x + size_cells.x
		and cell.y < module_cell.y + size_cells.y
	)


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
	drop_preview.visible = true
	drop_preview.position = GRID_ORIGIN + Vector2(cell.x * CELL_SIZE.x, cell.y * CELL_SIZE.y)
	drop_preview.size = Vector2(size_cells.x * CELL_SIZE.x - 3.0, size_cells.y * CELL_SIZE.y - 3.0)
	drop_preview.color = Color(0.20, 0.90, 0.68, 0.28) if bool(candidate.get("valid", false)) else Color(0.96, 0.18, 0.14, 0.32)
	if drop_preview_texture != null:
		drop_preview_texture.visible = true
		drop_preview_texture.position = drop_preview.position
		drop_preview_texture.size = drop_preview.size
		drop_preview_texture.texture = _make_atlas_texture(
			ATLAS_REGION_GRID_CELL_VALID if bool(candidate.get("valid", false)) else ATLAS_REGION_GRID_CELL_INVALID
		)
		drop_preview_texture.modulate = Color(1.0, 1.0, 1.0, 0.78)


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
		var button_module := _get_module(String(key))
		var selected := String(key) == selected_module_key
		if _has_module_atlas_region(String(key)):
			button.text = ">" if selected else ""
			button.modulate = Color(1.18, 1.12, 0.92, 1.0) if selected else Color(0.88, 0.93, 0.93, 1.0)
		else:
			var prefix := "> " if selected else ""
			button.text = "%s%s" % [prefix, String(button_module.get("display_name", key))]
	_refresh_module_detail()
	if emit_signal:
		selection_changed.emit(module_key, module.duplicate(true))


func _refresh_module_detail() -> void:
	var module := _get_module(selected_module_key)
	if module.is_empty():
		return

	module_title_label.text = String(module["display_name"])
	module_detail_label.text = "%s\n\n전력 모듈 후보는 아직 연결되지 않았습니다." % String(module["description"])

	var rect: Rect2 = module["rect"]
	module_debug_label.visible = debug_enabled
	if debug_enabled:
		var grid_pos = module_grid_positions.get(selected_module_key, "palette")
		module_debug_label.text = "key: %s\nrole: %s\ncandidate action: %s\nmodule rect: %s\ngrid: %s\nno-op status: OutletMode / SurvivalState disabled" % [
			String(module["key"]),
			String(module["role"]),
			String(module["candidate_action"]),
			_format_rect(rect),
			str(grid_pos),
		]

	for key in module_guides.keys():
		var guide: ColorRect = module_guides[key]
		guide.visible = debug_enabled
		guide.color = Color(1.0, 0.78, 0.20, 0.24) if String(key) == selected_module_key else Color(0.17, 0.82, 0.92, 0.18)
		_sync_module_guide(String(key))


func _get_module(module_key: String) -> Dictionary:
	for module in MODULES:
		if String(module["key"]) == module_key:
			return module
	return {}


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


func _add_atlas_region(parent: Control, node_name: String, region: Rect2, position: Vector2, size: Vector2, region_modulate := Color.WHITE) -> TextureRect:
	var texture_rect := TextureRect.new()
	texture_rect.name = node_name
	texture_rect.texture = _make_atlas_texture(region)
	texture_rect.position = position
	texture_rect.size = size
	texture_rect.stretch_mode = TextureRect.STRETCH_SCALE
	texture_rect.modulate = region_modulate
	texture_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(texture_rect)
	return texture_rect


func _get_module_atlas_region(module_key: String) -> Rect2:
	return MODULE_ATLAS_REGIONS.get(module_key, Rect2())


func _has_module_atlas_region(module_key: String) -> bool:
	return atlas_texture != null and MODULE_ATLAS_REGIONS.has(module_key)


func _format_rect(rect: Rect2) -> String:
	return "pos=%s size=%s" % [str(rect.position.round()), str(rect.size.round())]
