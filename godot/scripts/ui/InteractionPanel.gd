extends Control
class_name InteractionPanel

signal confirm_requested
signal cancel_requested

@onready var panel: Panel = $Panel
@onready var title_label: Label = $Panel/TitleLabel
@onready var body_label: Label = $Panel/BodyLabel
@onready var use_button: Button = $Panel/UseButton
@onready var use_button_label: Label = $Panel/UseButton/UseButtonLabel
@onready var cancel_button: Button = $Panel/CancelButton
@onready var cancel_button_label: Label = $Panel/CancelButton/CancelButtonLabel
@onready var dialogue_panel: Panel = $DialoguePanel
@onready var portrait_panel: Panel = $DialoguePanel/PortraitPanel
@onready var portrait_label: Label = $DialoguePanel/PortraitPanel/PortraitLabel
@onready var speaker_label: Label = $DialoguePanel/SpeakerLabel
@onready var dialogue_label: Label = $DialoguePanel/DialogueLabel


func _ready() -> void:
	panel.add_theme_stylebox_override("panel", UIStyle.make_panel_style(UIStyle.PANEL, UIStyle.LINE_DIM, 1, 2))
	dialogue_panel.add_theme_stylebox_override("panel", UIStyle.make_panel_style(Color(0.035, 0.033, 0.03, 0.92), UIStyle.LINE_DIM, 1, 2))
	portrait_panel.add_theme_stylebox_override("panel", UIStyle.make_panel_style(Color(0.045, 0.04, 0.035, 0.88), UIStyle.LINE_DIM, 1, 8))
	_install_texture_backplates()
	_apply_button_styles(use_button, true)
	_apply_button_styles(cancel_button, false)
	use_button.pressed.connect(func() -> void: confirm_requested.emit())
	cancel_button.pressed.connect(func() -> void: cancel_requested.emit())
	UIStyle.apply_label(title_label, UIStyle.TEXT, 24)
	UIStyle.apply_label(body_label, UIStyle.TEXT, 15)
	UIStyle.apply_label(use_button_label, UIStyle.TEXT, 14)
	UIStyle.apply_label(cancel_button_label, UIStyle.MUTED, 14)
	UIStyle.apply_label(portrait_label, UIStyle.MUTED, 13)
	UIStyle.apply_label(speaker_label, UIStyle.ELECTRIC, 17)
	UIStyle.apply_label(dialogue_label, UIStyle.TEXT, 16)


func _apply_button_styles(button: Button, is_primary: bool) -> void:
	button.add_theme_stylebox_override("normal", UIStyle.make_button_style(is_primary))
	button.add_theme_stylebox_override("hover", UIStyle.make_button_style(is_primary))
	button.add_theme_stylebox_override("pressed", UIStyle.make_button_style(is_primary))
	button.add_theme_stylebox_override("focus", UIStyle.make_button_style(is_primary))


func _install_texture_backplates() -> void:
	# Texture backplates are decorative only; the existing StyleBox panels still
	# carry contrast so Korean text remains readable over the P0 UI art.
	_add_panel_texture(panel, AssetPaths.UI_PANEL_INTERACTION, 0.24)
	_add_panel_texture(dialogue_panel, AssetPaths.UI_PANEL_DIALOGUE, 0.28)

	var portrait_texture: TextureRect = TextureRect.new()
	portrait_texture.texture = AssetPaths.YUI_PORTRAIT_NEUTRAL
	portrait_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	portrait_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	portrait_texture.modulate = Color(1, 1, 1, 0.96)
	portrait_texture.anchor_right = 1.0
	portrait_texture.anchor_bottom = 1.0
	portrait_texture.offset_left = 6.0
	portrait_texture.offset_top = 6.0
	portrait_texture.offset_right = -6.0
	portrait_texture.offset_bottom = -6.0
	portrait_panel.add_child(portrait_texture)
	portrait_panel.move_child(portrait_texture, 0)
	portrait_label.visible = false


func _add_panel_texture(parent: Control, texture: Texture2D, alpha: float) -> void:
	var texture_rect: TextureRect = TextureRect.new()
	texture_rect.texture = texture
	texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	texture_rect.stretch_mode = TextureRect.STRETCH_SCALE
	texture_rect.modulate = Color(1, 1, 1, alpha)
	texture_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	texture_rect.anchor_right = 1.0
	texture_rect.anchor_bottom = 1.0
	texture_rect.offset_left = 0.0
	texture_rect.offset_top = 0.0
	texture_rect.offset_right = 0.0
	texture_rect.offset_bottom = 0.0
	parent.add_child(texture_rect)
	parent.move_child(texture_rect, 0)


func open(title: String, body: String, footer_text: String = "E 또는 ESC: 닫기") -> void:
	title_label.text = title
	body_label.text = body
	_apply_footer(footer_text)
	dialogue_label.text = _make_yui_line(title, body)
	visible = true


func close() -> void:
	visible = false


func _apply_footer(footer_text: String) -> void:
	var has_primary := footer_text.find("E") >= 0 and footer_text.find("닫기") < 0
	use_button.visible = has_primary
	if has_primary:
		use_button_label.text = "[E] 하루 종료" if footer_text.find("하루") >= 0 else "[E] 사용하기"
		cancel_button_label.text = "[ESC] 취소"
		return

	cancel_button_label.text = "[ESC] 닫기"


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
