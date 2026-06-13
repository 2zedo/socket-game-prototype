extends Control
class_name InteractionPanel

@onready var title_label: Label = $Panel/TitleLabel
@onready var body_label: Label = $Panel/BodyLabel
@onready var footer_label: Label = $Panel/FooterLabel


func open(title: String, body: String, footer_text: String = "E 또는 ESC: 닫기") -> void:
	title_label.text = title
	body_label.text = body
	footer_label.text = footer_text
	visible = true


func close() -> void:
	visible = false
