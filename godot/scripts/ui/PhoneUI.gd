extends Control
class_name PhoneUI

@onready var stats_label: Label = $Panel/StatsLabel


func set_open(is_open: bool, survival_state: SurvivalState) -> void:
	visible = is_open

	if visible:
		refresh(survival_state)


func refresh(survival_state: SurvivalState) -> void:
	stats_label.text = survival_state.get_phone_text()
