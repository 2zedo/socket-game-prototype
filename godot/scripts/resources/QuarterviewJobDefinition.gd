extends Resource
class_name QuarterviewJobDefinition

const STATUS_PENDING := "미수락"
const STATUS_ACCEPTED := "수락됨"

@export_category("식별")
@export var key: String = ""
@export var title: String = ""
@export var sender_label: String = ""
@export_multiline var summary: String = ""
@export_multiline var detail_text: String = ""

@export_category("후보 상태")
@export var reward_label: String = ""
@export var risk_label: String = ""
@export var status_label: String = STATUS_PENDING
@export var related_object_key: String = ""

@export_category("상태")
@export var is_prototype: bool = true


func is_valid_definition() -> bool:
	return not key.is_empty() \
		and not title.is_empty() \
		and not sender_label.is_empty() \
		and not related_object_key.is_empty()


func get_status_label(accepted := false) -> String:
	if accepted:
		return STATUS_ACCEPTED
	if status_label.is_empty():
		return STATUS_PENDING
	return status_label


func get_summary_text() -> String:
	if not summary.is_empty():
		return summary
	return detail_text


func to_candidate_payload(accepted := false) -> Dictionary:
	return {
		"key": key,
		"title": title,
		"sender_label": sender_label,
		"summary": summary,
		"detail_text": detail_text,
		"reward_label": reward_label,
		"risk_label": risk_label,
		"status_label": get_status_label(accepted),
		"related_object_key": related_object_key,
		"is_prototype": is_prototype,
	}


func get_debug_summary() -> String:
	return "%s / sender=%s / reward=%s / risk=%s / related=%s / prototype=%s" % [
		key,
		sender_label,
		reward_label,
		risk_label,
		related_object_key,
		str(is_prototype),
	]
