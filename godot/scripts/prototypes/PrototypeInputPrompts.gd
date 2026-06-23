extends RefCounted

const PROMPT_PATHS := {
	"arrows": "res://assets/ui/third_party/kenney/input_prompts/key_arrows.png",
	"backspace": "res://assets/ui/third_party/kenney/input_prompts/key_backspace.png",
	"b": "res://assets/ui/third_party/kenney/input_prompts/key_b.png",
	"d": "res://assets/ui/third_party/kenney/input_prompts/key_d.png",
	"e": "res://assets/ui/third_party/kenney/input_prompts/key_e.png",
	"enter": "res://assets/ui/third_party/kenney/input_prompts/key_enter.png",
	"escape": "res://assets/ui/third_party/kenney/input_prompts/key_escape.png",
	"j": "res://assets/ui/third_party/kenney/input_prompts/key_j.png",
	"lmb": "res://assets/ui/third_party/kenney/input_prompts/mouse_left.png",
	"r": "res://assets/ui/third_party/kenney/input_prompts/key_r.png",
	"shift": "res://assets/ui/third_party/kenney/input_prompts/key_shift.png",
	"space": "res://assets/ui/third_party/kenney/input_prompts/key_space.png",
	"w": "res://assets/ui/third_party/kenney/input_prompts/key_w.png",
	"a": "res://assets/ui/third_party/kenney/input_prompts/key_a.png",
	"s": "res://assets/ui/third_party/kenney/input_prompts/key_s.png",
}


static func create_prompt_box(rows: Array, icon_size: Vector2, text_color: Color) -> VBoxContainer:
	var box := VBoxContainer.new()
	box.name = "PromptIconRows"
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_theme_constant_override("separation", 8)

	for row_data in rows:
		box.add_child(create_prompt_row(row_data.get("keys", []), String(row_data.get("text", "")), icon_size, text_color))

	return box


static func create_prompt_row(prompt_keys: Array, text: String, icon_size: Vector2, text_color: Color) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_theme_constant_override("separation", 6)

	for prompt_key in prompt_keys:
		row.add_child(create_prompt_icon(String(prompt_key), icon_size))

	var label := Label.new()
	label.name = "PromptText"
	label.text = text
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_color_override("font_color", text_color)
	label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.85))
	label.add_theme_constant_override("shadow_offset_x", 1)
	label.add_theme_constant_override("shadow_offset_y", 1)
	row.add_child(label)

	return row


static func create_prompt_icon(prompt_key: String, icon_size: Vector2) -> TextureRect:
	var icon := TextureRect.new()
	icon.name = "PromptIcon_%s" % prompt_key
	icon.texture = get_prompt_texture(prompt_key)
	icon.custom_minimum_size = icon_size
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	return icon


static func get_prompt_texture(prompt_key: String) -> Texture2D:
	var path := String(PROMPT_PATHS.get(prompt_key, ""))
	if path == "":
		push_warning("Unknown prototype input prompt key: %s" % prompt_key)
		return null
	return load(path) as Texture2D
