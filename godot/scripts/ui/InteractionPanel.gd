extends Control
class_name InteractionPanel

@onready var title_label: Label = $Panel/TitleLabel
@onready var body_label: Label = $Panel/BodyLabel


func open(title: String, body: String) -> void:
	title_label.text = title
	body_label.text = body
	visible = true


func close() -> void:
	visible = false
