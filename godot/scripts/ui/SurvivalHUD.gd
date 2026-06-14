extends Control
class_name SurvivalHUD

@onready var prompt_label: Label = $PromptLabel
@onready var warning_panel: ColorRect = $WarningPanel
@onready var warning_label: Label = $WarningLabel
@onready var stats_panel: ColorRect = $StatsPanel
@onready var stats_label: Label = $StatsLabel
@onready var time_panel: ColorRect = $TimePanel
@onready var time_label: Label = $TimeLabel
@onready var phase_effect_label: Label = $PhaseEffectLabel
@onready var hint_label: Label = $HintLabel

const NO_PROMPT_POSITION: Vector2 = Vector2(-99999.0, -99999.0)


func _ready() -> void:
	stats_panel.color = UIStyle.PANEL_STRONG
	time_panel.color = UIStyle.PANEL_SOFT
	warning_panel.color = Color(0.25, 0.08, 0.06, 0.74)
	stats_panel.color = Color(0.045, 0.041, 0.035, 0.9)
	hint_label.add_theme_stylebox_override("normal", UIStyle.make_panel_style(Color(0.035, 0.032, 0.028, 0.78), UIStyle.LINE_DIM, 1, 2))
	UIStyle.apply_label(stats_label, UIStyle.TEXT, 14)
	UIStyle.apply_label(time_label, UIStyle.MUTED, 13)
	UIStyle.apply_label(prompt_label, UIStyle.TEXT, 13)
	UIStyle.apply_label(hint_label, UIStyle.MUTED, 13)
	prompt_label.add_theme_stylebox_override("normal", UIStyle.make_panel_style(Color(0.035, 0.032, 0.028, 0.88), UIStyle.LINE, 1, 2))
	queue_redraw()


func _draw() -> void:
	draw_texture_rect(AssetPaths.ICON_POWER, Rect2(Vector2(24, 132), Vector2(20, 20)), false, Color(1, 1, 1, 0.82))


func set_interaction_prompt(text: String, world_position: Vector2 = NO_PROMPT_POSITION) -> void:
	prompt_label.text = text
	prompt_label.visible = text.strip_edges() != ""
	if prompt_label.visible and world_position != NO_PROMPT_POSITION:
		prompt_label.position = world_position + Vector2(-78.0, -66.0)


func set_warnings(warnings: Array[String]) -> void:
	if warnings.is_empty():
		warning_panel.visible = false
		warning_label.text = ""
		return

	warning_panel.visible = true
	warning_label.text = " / ".join(warnings)


func set_stats(text: String) -> void:
	stats_label.text = text


func set_time(text: String) -> void:
	var has_text := text.strip_edges() != ""
	time_panel.visible = has_text
	time_label.visible = has_text
	time_label.text = text


func set_phase_effect(text: String) -> void:
	phase_effect_label.text = text


func set_phase_style(phase_key: String) -> void:
	if phase_key == "night":
		stats_panel.color = Color(0.045, 0.041, 0.035, 0.9)
		time_panel.color = UIStyle.PANEL_SOFT
		stats_label.add_theme_color_override("font_color", UIStyle.TEXT)
		time_label.add_theme_color_override("font_color", UIStyle.MUTED)
		phase_effect_label.add_theme_color_override("font_color", UIStyle.MUTED)
		return

	stats_panel.color = Color(0.045, 0.041, 0.035, 0.9)
	time_panel.color = UIStyle.PANEL_SOFT
	stats_label.add_theme_color_override("font_color", UIStyle.TEXT)
	time_label.add_theme_color_override("font_color", UIStyle.MUTED)
	phase_effect_label.add_theme_color_override("font_color", UIStyle.MUTED)
