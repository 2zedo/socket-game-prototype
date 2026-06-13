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


func set_interaction_prompt(text: String) -> void:
	prompt_label.text = text


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
		stats_panel.color = Color(0.24, 0.28, 0.36, 0.2)
		time_panel.color = Color(0.24, 0.28, 0.36, 0.14)
		stats_label.add_theme_color_override("font_color", Color("#dbe5ff"))
		time_label.add_theme_color_override("font_color", Color("#dbe5ff"))
		phase_effect_label.add_theme_color_override("font_color", Color("#dbe5ff"))
		return

	stats_panel.color = Color(0.78, 0.61, 0.38, 0.16)
	time_panel.color = Color(0.78, 0.61, 0.38, 0.1)
	stats_label.add_theme_color_override("font_color", Color("#452e1d"))
	time_label.add_theme_color_override("font_color", Color("#452e1d"))
	phase_effect_label.add_theme_color_override("font_color", Color("#5a3d28"))
