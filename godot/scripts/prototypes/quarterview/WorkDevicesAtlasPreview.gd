extends Control

const PROTOTYPE_UTILS := preload("res://scripts/prototypes/PrototypeSceneUtils.gd")

const ATLAS_PATH := "res://assets/art/quarterview/atlases/qv_work_devices_atlas.png"
const CELL_SIZE := Vector2(380, 300)
const THUMB_SIZE := Vector2(340, 220)

const REGION_SPECS := [
	{"name": "laptop_off", "rect": Rect2(165, 40, 415, 385), "use": "Desk / Laptop off"},
	{"name": "laptop_on", "rect": Rect2(703, 40, 415, 385), "use": "Desk / Laptop on"},
	{"name": "laptop_active", "rect": Rect2(1241, 40, 415, 385), "use": "Desk / Laptop active"},
	{"name": "phone_idle", "rect": Rect2(168, 511, 267, 190), "use": "Phone idle"},
	{"name": "phone_charging", "rect": Rect2(617, 511, 267, 190), "use": "Phone charging"},
	{"name": "charger", "rect": Rect2(1128, 514, 204, 174), "use": "Charger / adapter"},
	{"name": "cable", "rect": Rect2(1557, 511, 263, 205), "use": "Loose cable"},
	{"name": "power_strip_empty", "rect": Rect2(400, 770, 373, 215), "use": "Power strip empty"},
	{"name": "power_strip_active", "rect": Rect2(1077, 770, 374, 215), "use": "Power strip active"},
	{"name": "comm_off", "rect": Rect2(460, 1015, 313, 222), "use": "Communication device off"},
	{"name": "comm_on", "rect": Rect2(1146, 1015, 314, 222), "use": "Communication device on"},
	{"name": "node17_off", "rect": Rect2(442, 1270, 264, 199), "use": "NODE-17 off"},
	{"name": "node17_on", "rect": Rect2(1125, 1270, 264, 199), "use": "NODE-17 on"},
	{"name": "signal_booster_off", "rect": Rect2(432, 1472, 243, 219), "use": "Signal booster off"},
	{"name": "signal_booster_on", "rect": Rect2(1140, 1472, 244, 219), "use": "Signal booster on"},
	{"name": "speaker_off", "rect": Rect2(294, 1708, 182, 280), "use": "Speaker / audio analyzer off"},
	{"name": "speaker_on", "rect": Rect2(770, 1708, 181, 280), "use": "Speaker / audio analyzer on"},
	{"name": "ups_idle", "rect": Rect2(1259, 1709, 283, 292), "use": "UPS / backup power"},
]

var atlas_texture: Texture2D
var atlas_load_error := ""


func _ready() -> void:
	_build_preview()


func _unhandled_input(event: InputEvent) -> void:
	if PROTOTYPE_UTILS.is_hub_back_event(event):
		PROTOTYPE_UTILS.go_to_hub(self)
		get_viewport().set_input_as_handled()
		return

	if PROTOTYPE_UTILS.is_restart_event(event):
		PROTOTYPE_UTILS.restart_current_scene(self)
		get_viewport().set_input_as_handled()
		return


func _build_preview() -> void:
	_build_background()

	var root := MarginContainer.new()
	root.name = "PreviewRoot"
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.add_theme_constant_override("margin_left", 24)
	root.add_theme_constant_override("margin_top", 20)
	root.add_theme_constant_override("margin_right", 24)
	root.add_theme_constant_override("margin_bottom", 20)
	add_child(root)

	var layout := VBoxContainer.new()
	layout.name = "Layout"
	layout.add_theme_constant_override("separation", 14)
	root.add_child(layout)

	layout.add_child(_make_header())
	layout.add_child(_make_scroll_preview())


func _build_background() -> void:
	var background := ColorRect.new()
	background.name = "Background"
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.color = Color(0.012, 0.014, 0.02, 1.0)
	add_child(background)


func _make_header() -> Control:
	var header := VBoxContainer.new()
	header.name = "Header"
	header.add_theme_constant_override("separation", 4)

	var title := Label.new()
	title.text = "Work Devices Atlas Preview"
	title.add_theme_font_size_override("font_size", 26)
	title.add_theme_color_override("font_color", Color(0.93, 0.86, 0.72, 1.0))
	header.add_child(title)

	var help := Label.new()
	help.text = "Temporary atlas region check only. Not wired to QuarterviewMain. R: reload / B or Backspace: PrototypeHub"
	help.add_theme_color_override("font_color", Color(0.68, 0.78, 0.82, 1.0))
	header.add_child(help)

	var status := Label.new()
	status.name = "StatusLabel"
	status.text = _get_status_text()
	status.add_theme_color_override("font_color", Color(0.76, 0.92, 0.86, 1.0))
	header.add_child(status)

	return header


func _make_scroll_preview() -> Control:
	var scroll := ScrollContainer.new()
	scroll.name = "ScrollContainer"
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED

	var grid := GridContainer.new()
	grid.name = "RegionGrid"
	grid.columns = 3
	grid.add_theme_constant_override("h_separation", 18)
	grid.add_theme_constant_override("v_separation", 18)
	scroll.add_child(grid)

	atlas_texture = _load_atlas_texture()
	for spec in REGION_SPECS:
		grid.add_child(_make_region_card(spec))

	return scroll


func _make_region_card(spec: Dictionary) -> Control:
	var panel := PanelContainer.new()
	panel.name = "%sCard" % (spec["name"] as String).to_pascal_case()
	panel.custom_minimum_size = CELL_SIZE

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 6)
	panel.add_child(box)

	var name_label := Label.new()
	name_label.text = spec["name"] as String
	name_label.add_theme_font_size_override("font_size", 18)
	name_label.add_theme_color_override("font_color", Color(0.95, 0.82, 0.34, 1.0))
	box.add_child(name_label)

	var texture_rect := TextureRect.new()
	texture_rect.name = "RegionTexture"
	texture_rect.custom_minimum_size = THUMB_SIZE
	texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	texture_rect.texture = _make_atlas_texture(spec["rect"] as Rect2)
	box.add_child(texture_rect)

	var rect_label := Label.new()
	var rect := spec["rect"] as Rect2
	rect_label.text = "rect: %d, %d, %d, %d" % [
		int(rect.position.x),
		int(rect.position.y),
		int(rect.size.x),
		int(rect.size.y),
	]
	rect_label.add_theme_color_override("font_color", Color(0.74, 0.82, 0.86, 1.0))
	box.add_child(rect_label)

	var use_label := Label.new()
	use_label.text = spec["use"] as String
	use_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	use_label.add_theme_color_override("font_color", Color(0.68, 0.68, 0.64, 1.0))
	box.add_child(use_label)

	return panel


func _make_atlas_texture(region: Rect2) -> AtlasTexture:
	if atlas_texture == null:
		return null

	var texture := AtlasTexture.new()
	texture.atlas = atlas_texture
	texture.region = region
	return texture


func _get_status_text() -> String:
	var exists := FileAccess.file_exists(ATLAS_PATH)
	if not exists:
		return "Atlas missing: %s" % ATLAS_PATH

	var texture := _load_atlas_texture()
	if texture == null:
		return "Atlas load failed: %s / %s" % [ATLAS_PATH, atlas_load_error]

	return "Atlas: %s / %d x %d / regions: %d" % [
		ATLAS_PATH,
		int(texture.get_width()),
		int(texture.get_height()),
		REGION_SPECS.size(),
	]


func _load_atlas_texture() -> Texture2D:
	var image := Image.new()
	var error := image.load(ATLAS_PATH)
	if error != OK:
		atlas_load_error = "Image.load error %d" % error
		return null

	atlas_load_error = ""
	return ImageTexture.create_from_image(image)
