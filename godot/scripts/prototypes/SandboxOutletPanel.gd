extends Control

signal closed
signal mock_action_requested(action_key: String)

@onready var title_label: Label = $Panel/Margin/VBox/TitleLabel
@onready var detail_label: Label = $Panel/Margin/VBox/DetailLabel
@onready var slot_label: Label = $Panel/Margin/VBox/SlotListLabel
@onready var device_label: Label = $Panel/Margin/VBox/DeviceListLabel
@onready var mock_laptop_button: Button = $Panel/Margin/VBox/ButtonRow/MockLaptopButton
@onready var mock_disconnect_button: Button = $Panel/Margin/VBox/ButtonRow/MockDisconnectButton
@onready var close_button: Button = $Panel/Margin/VBox/ButtonRow/CloseButton


func _ready() -> void:
	visible = false
	mock_laptop_button.pressed.connect(_on_mock_laptop_pressed)
	mock_disconnect_button.pressed.connect(_on_mock_disconnect_pressed)
	close_button.pressed.connect(close)


func open_with_state(state_text: String, source: String = "power primary") -> void:
	title_label.text = "POWER / SANDBOX OUTLET"
	detail_label.text = "%s\n\nOpened from: %s\n\nSandbox only.\nReal OutletMode / Main / SurvivalState / Apartment wire overlay are not connected." % [
		state_text,
		source,
	]
	slot_label.text = "Slots:\n[1] empty\n[2] empty\n[3] empty\n[4] empty"
	device_label.text = "Device candidates:\nLaptop - 2 slots\nPhone Charger - 1 slot\nCommunication - 1 slot\nLight / Fan - current Main only"
	mock_laptop_button.text = "Mock Laptop"
	mock_disconnect_button.text = "Mock Clear"
	close_button.text = "Close"
	visible = true


func show_mock_message(message: String) -> void:
	detail_label.text = "%s\n\nNo real connected / active state changed." % message


func close() -> void:
	if not visible:
		return
	visible = false
	closed.emit()


func is_open() -> bool:
	return visible


func _on_mock_laptop_pressed() -> void:
	mock_action_requested.emit("mock_laptop")


func _on_mock_disconnect_pressed() -> void:
	mock_action_requested.emit("mock_disconnect_all")
