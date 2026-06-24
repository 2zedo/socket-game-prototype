extends GutTest

const GRID_CREDIT_STATE := preload("res://scripts/systems/GridCreditState.gd")


func test_reset_clamps_negative_starting_credit() -> void:
	var state = GRID_CREDIT_STATE.new()

	state.reset(-10)

	assert_eq(state.current_credit, 0)
	assert_eq(state.lifetime_earned, 0)
	assert_eq(state.lifetime_spent, 0)
	assert_true(state.transaction_log.is_empty())


func test_earn_increases_credit_and_lifetime_earned() -> void:
	var state = GRID_CREDIT_STATE.new()

	var did_earn := state.earn(100, state.REASON_HACKING_REWARD, "mission_a")
	var transaction := state.get_last_transaction()

	assert_true(did_earn)
	assert_eq(state.current_credit, 100)
	assert_eq(state.lifetime_earned, 100)
	assert_eq(state.lifetime_spent, 0)
	assert_eq(state.transaction_log.size(), 1)
	assert_eq(transaction["type"], state.TRANSACTION_EARN)
	assert_eq(transaction["amount"], 100)
	assert_eq(transaction["balance_after"], 100)
	assert_eq(transaction["reason"], state.REASON_HACKING_REWARD)
	assert_eq(transaction["source"], "mission_a")


func test_earn_rejects_zero_or_negative_amount() -> void:
	var state = GRID_CREDIT_STATE.new()
	state.reset(20)

	assert_false(state.earn(0))
	assert_false(state.earn(-5))
	assert_eq(state.current_credit, 20)
	assert_eq(state.lifetime_earned, 0)
	assert_true(state.transaction_log.is_empty())


func test_spend_succeeds_when_credit_is_available() -> void:
	var state = GRID_CREDIT_STATE.new()
	state.reset(100)

	var did_spend := state.spend(40, state.REASON_POWER_PURCHASE, "extra_power")
	var transaction := state.get_last_transaction()

	assert_true(did_spend)
	assert_eq(state.current_credit, 60)
	assert_eq(state.lifetime_spent, 40)
	assert_eq(state.transaction_log.size(), 1)
	assert_eq(transaction["type"], state.TRANSACTION_SPEND)
	assert_eq(transaction["amount"], 40)
	assert_eq(transaction["balance_after"], 60)
	assert_eq(transaction["reason"], state.REASON_POWER_PURCHASE)
	assert_eq(transaction["target"], "extra_power")


func test_spend_fails_when_credit_is_insufficient() -> void:
	var state = GRID_CREDIT_STATE.new()
	state.reset(10)

	assert_false(state.spend(20))
	assert_eq(state.current_credit, 10)
	assert_eq(state.lifetime_spent, 0)
	assert_true(state.transaction_log.is_empty())


func test_adjust_supports_positive_and_negative_values_with_floor_clamp() -> void:
	var state = GRID_CREDIT_STATE.new()
	state.reset(10)

	assert_true(state.adjust(5, state.REASON_DEBUG, "test"))
	assert_eq(state.current_credit, 15)
	assert_eq(state.get_last_transaction()["amount"], 5)
	assert_eq(state.get_last_transaction()["type"], state.TRANSACTION_ADJUST)

	assert_true(state.adjust(-50, state.REASON_DEBUG, "test"))
	assert_eq(state.current_credit, 0)
	assert_eq(state.get_last_transaction()["amount"], -15)
	assert_eq(state.lifetime_earned, 0)
	assert_eq(state.lifetime_spent, 0)


func test_transaction_log_is_returned_as_copy() -> void:
	var state = GRID_CREDIT_STATE.new()
	state.earn(15, state.REASON_HACKING_REWARD, "mission")

	var returned_log := state.get_transaction_log()
	returned_log[0]["amount"] = 999
	returned_log.append({"type": "fake"})

	assert_eq(state.transaction_log.size(), 1)
	assert_eq(state.transaction_log[0]["amount"], 15)


func test_summary_and_clear_log_keep_current_totals() -> void:
	var state = GRID_CREDIT_STATE.new()
	state.earn(30, state.REASON_HACKING_REWARD, "mission")
	state.spend(10, state.REASON_FOOD, "meal")

	var summary := state.get_summary()
	assert_eq(summary["current_credit"], 20)
	assert_eq(summary["lifetime_earned"], 30)
	assert_eq(summary["lifetime_spent"], 10)
	assert_eq(summary["transaction_count"], 2)

	state.clear_log()

	assert_true(state.transaction_log.is_empty())
	assert_eq(state.current_credit, 20)
	assert_eq(state.lifetime_earned, 30)
	assert_eq(state.lifetime_spent, 10)
