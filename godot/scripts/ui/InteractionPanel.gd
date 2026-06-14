extends Control
class_name InteractionPanel

@onready var panel: Panel = $Panel
@onready var title_label: Label = $Panel/TitleLabel
@onready var body_label: Label = $Panel/BodyLabel
@onready var footer_label: Label = $Panel/FooterLabel
@onready var dialogue_panel: Panel = $DialoguePanel
@onready var speaker_label: Label = $DialoguePanel/SpeakerLabel
@onready var dialogue_label: Label = $DialoguePanel/DialogueLabel


func _ready() -> void:
	panel.add_theme_stylebox_override("panel", UIStyle.make_panel_style(UIStyle.PANEL, UIStyle.LINE_DIM, 1, 2))
	dialogue_panel.add_theme_stylebox_override("panel", UIStyle.make_panel_style(Color(0.035, 0.033, 0.03, 0.92), UIStyle.LINE_DIM, 1, 2))
	UIStyle.apply_label(title_label, UIStyle.TEXT, 24)
	UIStyle.apply_label(body_label, UIStyle.TEXT, 15)
	UIStyle.apply_label(footer_label, UIStyle.MUTED, 14)
	UIStyle.apply_label(speaker_label, UIStyle.ELECTRIC, 17)
	UIStyle.apply_label(dialogue_label, UIStyle.TEXT, 16)


func open(title: String, body: String, footer_text: String = "E 또는 ESC: 닫기") -> void:
	title_label.text = title
	body_label.text = body
	footer_label.text = footer_text
	dialogue_label.text = _make_yui_line(title, body)
	visible = true


func close() -> void:
	visible = false


func _make_yui_line(title: String, body: String) -> String:
	if body.find("전원이 연결되어 있지 않다") >= 0:
		return "전원이 없으면 아무것도 시작할 수 없어. 먼저 연결부터 확인하자."
	if body.find("오늘 남은 전력이 부족하다") >= 0:
		return "오늘 쓸 수 있는 전력이 얼마 남지 않았어. 다른 선택을 해야 해."
	if title.find("사용 완료") >= 0:
		return "전력을 쓴 만큼 오늘은 조금 더 버틸 수 있을지도 몰라."
	if title.find("오늘을 마친다") >= 0:
		return "더 쓸 전력이 남아 있어도, 오늘은 여기서 멈출 수 있어."

	return "전력을 쓸 때마다 줄어드는 게 느껴져. 그래도 필요한 건 확인해야 해."
