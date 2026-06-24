extends RefCounted
class_name GridCreditState

const TRANSACTION_EARN := "earn"
const TRANSACTION_SPEND := "spend"
const TRANSACTION_ADJUST := "adjust"

const REASON_HACKING_REWARD := "hacking_reward"
const REASON_POWER_PURCHASE := "power_purchase"
const REASON_DEVICE_REPAIR := "device_repair"
const REASON_FOOD := "food"
const REASON_DEBUG := "debug"
const REASON_UNKNOWN := "unknown"

var current_credit: int = 0
var lifetime_earned: int = 0
var lifetime_spent: int = 0
var transaction_log: Array[Dictionary] = []


func reset(starting_credit: int = 0) -> void:
	current_credit = maxi(0, starting_credit)
	lifetime_earned = 0
	lifetime_spent = 0
	transaction_log.clear()


func earn(amount: int, reason: String = REASON_UNKNOWN, source: String = "") -> bool:
	if amount <= 0:
		return false

	current_credit += amount
	lifetime_earned += amount
	_append_transaction(TRANSACTION_EARN, amount, reason, source, "")
	return true


func can_spend(amount: int) -> bool:
	return amount > 0 and current_credit >= amount


func spend(amount: int, reason: String = REASON_UNKNOWN, target: String = "") -> bool:
	if not can_spend(amount):
		return false

	current_credit -= amount
	lifetime_spent += amount
	_append_transaction(TRANSACTION_SPEND, amount, reason, "", target)
	return true


func adjust(delta: int, reason: String = REASON_DEBUG, source: String = "") -> bool:
	if delta == 0:
		return false

	var previous_credit := current_credit
	current_credit = maxi(0, current_credit + delta)
	var applied_delta := current_credit - previous_credit
	_append_transaction(TRANSACTION_ADJUST, applied_delta, reason, source, "")
	return true


func get_summary() -> Dictionary:
	return {
		"current_credit": current_credit,
		"lifetime_earned": lifetime_earned,
		"lifetime_spent": lifetime_spent,
		"transaction_count": transaction_log.size(),
	}


func get_transaction_log() -> Array[Dictionary]:
	return transaction_log.duplicate(true)


func get_last_transaction() -> Dictionary:
	if transaction_log.is_empty():
		return {}
	return transaction_log[transaction_log.size() - 1].duplicate(true)


func clear_log() -> void:
	transaction_log.clear()


func _append_transaction(type: String, amount: int, reason: String, source: String, target: String) -> void:
	transaction_log.append({
		"type": type,
		"amount": amount,
		"balance_after": current_credit,
		"reason": reason,
		"source": source,
		"target": target,
	})
