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
@onready var test_mode_label: Label = $TestModeLabel
@onready var test_debug_label: Label = $TestDebugLabel
@onready var test_help_label: Label = $TestHelpLabel

const NO_PROMPT_POSITION: Vector2 = Vector2(-99999.0, -99999.0)
const WARNING_DURATION_SECONDS: float = 3.0

var warning_revision: int = 0


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
	test_mode_label.add_theme_stylebox_override("normal", UIStyle.make_panel_style(Color(0.12, 0.06, 0.02, 0.9), Color(1.0, 0.52, 0.12, 0.9), 1, 2))
	test_debug_label.add_theme_stylebox_override("normal", UIStyle.make_panel_style(Color(0.02, 0.025, 0.03, 0.9), Color(0.28, 0.66, 1.0, 0.82), 1, 2))
	test_help_label.add_theme_stylebox_override("normal", UIStyle.make_panel_style(Color(0.025, 0.023, 0.02, 0.94), Color(1.0, 0.52, 0.12, 0.82), 1, 2))
	UIStyle.apply_label(test_help_label, UIStyle.TEXT, 12)
	queue_redraw()


func set_interaction_prompt(text: String, world_position: Vector2 = NO_PROMPT_POSITION) -> void:
	prompt_label.text = text
	prompt_label.visible = text.strip_edges() != ""
	if prompt_label.visible and world_position != NO_PROMPT_POSITION:
		prompt_label.position = world_position + Vector2(-78.0, -66.0)


func set_warnings(warnings: Array[String]) -> void:
	if warnings.is_empty():
		warning_panel.visible = false
		warning_label.visible = false
		warning_label.text = ""
		return

	warning_panel.visible = true
	warning_label.visible = true
	warning_label.text = " / ".join(warnings)


func show_temporary_warning(message: String) -> void:
	warning_revision += 1
	var current_revision: int = warning_revision
	set_warnings([message])
	await get_tree().create_timer(WARNING_DURATION_SECONDS).timeout
	if current_revision == warning_revision:
		set_warnings([])


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


func set_test_mode_enabled(is_enabled: bool) -> void:
	test_mode_label.visible = is_enabled
	test_debug_label.visible = is_enabled
	if not is_enabled:
		test_debug_label.text = ""
		test_help_label.visible = false


func set_test_debug_text(text: String) -> void:
	if not test_debug_label.visible:
		return
	test_debug_label.text = text


func toggle_test_help(help_text: String) -> void:
	test_help_label.text = help_text
	test_help_label.visible = not test_help_label.visible
