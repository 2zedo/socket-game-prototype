extends RefCounted
class_name UIStyle

const BG: Color = Color("#070808")
const PANEL: Color = Color(0.055, 0.052, 0.047, 0.88)
const PANEL_SOFT: Color = Color(0.09, 0.078, 0.064, 0.72)
const LINE: Color = Color("#8f7a55")
const LINE_DIM: Color = Color(0.47, 0.39, 0.27, 0.72)
const TEXT: Color = Color("#eadfca")
const MUTED: Color = Color("#a99a82")
const ELECTRIC: Color = Color("#e0b653")
const WARNING: Color = Color("#b75b4f")
const SUCCESS: Color = Color("#6f946c")


static func make_panel_style(fill: Color = PANEL, border: Color = LINE_DIM, border_width: int = 1, corner_radius: int = 3) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = border
	style.border_width_left = border_width
	style.border_width_top = border_width
	style.border_width_right = border_width
	style.border_width_bottom = border_width
	style.corner_radius_top_left = corner_radius
	style.corner_radius_top_right = corner_radius
	style.corner_radius_bottom_left = corner_radius
	style.corner_radius_bottom_right = corner_radius
	style.content_margin_left = 16
	style.content_margin_top = 14
	style.content_margin_right = 16
	style.content_margin_bottom = 14
	return style


static func apply_label(label: Label, color: Color = TEXT, font_size: int = 15) -> void:
	label.add_theme_color_override("font_color", color)
	label.add_theme_font_size_override("font_size", font_size)
