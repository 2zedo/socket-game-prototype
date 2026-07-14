#!/usr/bin/env bash
set -Eeuo pipefail

# CONCENT's Git-non-mutating validation wrapper. Godot itself can generate import metadata.

MODE="full"
MODE_SET=0
KEEP_LOGS=0
GODOT_BIN_ARG=""
GODOT_BIN_ARG_SET=0
CURRENT_STEP="initialization"
LOG_DIR=""
FAILED_STEPS=0
FINAL_EXIT_CODE=0
SCRIPT_SUCCEEDED=0
STEP_NAMES=()
STEP_STATES=()
STEP_LOGS=()
STEP_DETAILS=()

usage() {
	cat <<'EOF'
Usage: scripts/validate_concent.sh [--full|--quick] [--godot-bin PATH] [--keep-logs]

Runs CONCENT validation from any working directory without Git mutation commands.

  --full              Run Git checks, Godot/candidate parse, strict unit-test script parse, and Full GUT. (default)
  --quick             Run Git checks, Godot parse, and candidate startups; skip unit-test parsing and Full GUT.
  --godot-bin PATH    Use this Godot executable. Takes precedence over GODOT_BIN and PATH lookup.
  --keep-logs         Preserve the temporary log directory even when validation succeeds.
  --help              Show this help text.

Godot lookup order: --godot-bin, GODOT_BIN, godot on PATH, godot4 on PATH,
then /Applications/Godot.app/Contents/MacOS/Godot.

The script never runs Git mutation commands (add, commit, push, clean, restore, or reset) and
never deletes repository files. Godot may still create its normal .import, .uid, or .godot
metadata; the final Git-status comparison reports that separately.
EOF
}

die_usage() {
	printf 'Error: %s\n\n' "$1" >&2
	usage >&2
	exit 2
}

on_err() {
	local line="$1"
	local rc="$2"
	printf 'Unexpected error: step=%s line=%s exit=%s\n' "$CURRENT_STEP" "$line" "$rc" >&2
}

cleanup() {
	local exit_status=$?
	if [[ -z "$LOG_DIR" || ! -d "$LOG_DIR" ]]; then
		return
	fi
	if (( KEEP_LOGS )) || (( FAILED_STEPS > 0 )) || (( SCRIPT_SUCCEEDED == 0 )) || (( exit_status != 0 )); then
		printf 'Logs preserved: %s\n' "$LOG_DIR"
	else
		rm -rf -- "$LOG_DIR"
	fi
}

trap 'on_err "$LINENO" "$?"' ERR
trap cleanup EXIT

on_signal() {
	local signal_name="$1"
	local exit_status="$2"
	printf 'Interrupted by %s during step=%s.\n' "$signal_name" "$CURRENT_STEP" >&2
	exit "$exit_status"
}

trap 'on_signal INT 130' INT
trap 'on_signal TERM 143' TERM

while (( $# > 0 )); do
	case "$1" in
		--full)
			(( MODE_SET == 0 )) || die_usage 'Choose only one of --full or --quick.'
			MODE="full"
			MODE_SET=1
			;;
		--quick)
			(( MODE_SET == 0 )) || die_usage 'Choose only one of --full or --quick.'
			MODE="quick"
			MODE_SET=1
			;;
		--godot-bin)
			(( $# >= 2 )) || die_usage '--godot-bin requires a path.'
			[[ -n "$2" ]] || die_usage '--godot-bin requires a non-empty path.'
			(( GODOT_BIN_ARG_SET == 0 )) || die_usage '--godot-bin may be supplied only once.'
			GODOT_BIN_ARG="$2"
			GODOT_BIN_ARG_SET=1
			shift
			;;
		--keep-logs)
			KEEP_LOGS=1
			;;
		--help|-h)
			usage
			exit 0
			;;
		*)
			die_usage "Unknown argument: $1"
			;;
	esac
	shift
done

SCRIPT_PATH="${BASH_SOURCE[0]}"
SCRIPT_DIR="$(cd -- "$(dirname -- "$SCRIPT_PATH")" && pwd -P)"
if REPO_ROOT="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel 2>/dev/null)"; then
	:
else
	REPO_ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd -P)"
fi
GODOT_PROJECT_ROOT="$REPO_ROOT/godot"
PROJECT_FILE="$GODOT_PROJECT_ROOT/project.godot"

if [[ ! -f "$PROJECT_FILE" ]]; then
	printf 'Unable to find Godot project file: %s\n' "$PROJECT_FILE" >&2
	exit 2
fi
if ! git -C "$REPO_ROOT" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
	printf 'Unable to find Git repository root from: %s\n' "$SCRIPT_PATH" >&2
	exit 2
fi

LOG_DIR="$(mktemp -d "${TMPDIR:-/tmp}/concent-validation.XXXXXX")"
START_STATUS_LOG="$LOG_DIR/git_status_start.log"
FINAL_STATUS_LOG="$LOG_DIR/git_status_final.log"
if ! git -C "$REPO_ROOT" status --short > "$START_STATUS_LOG"; then
	printf 'Unable to capture initial Git status.\n' >&2
	exit 2
fi

format_command() {
	local rendered=""
	local argument
	local display_argument
	for argument in "$@"; do
		display_argument="${argument//\\/\\\\}"
		display_argument="${display_argument//\"/\\\"}"
		rendered+=" \"$display_argument\""
	done
	printf '%s' "${rendered# }"
}

record_step() {
	STEP_NAMES[${#STEP_NAMES[@]}]="$1"
	STEP_STATES[${#STEP_STATES[@]}]="$2"
	STEP_LOGS[${#STEP_LOGS[@]}]="$3"
	STEP_DETAILS[${#STEP_DETAILS[@]}]="$4"
}

godot_fatal_log_markers() {
	local log_file="$1"
	local marker_text=""
	if grep -Fq -- 'Parse Error' "$log_file"; then
		marker_text="Parse Error"
	fi
	if grep -Fq -- 'Failed to load script' "$log_file"; then
		if [[ -n "$marker_text" ]]; then
			marker_text+=", "
		fi
		marker_text+="Failed to load script"
	fi
	printf '%s' "$marker_text"
}

run_step() {
	local name="$1"
	local log_name="$2"
	shift 2
	local scan_godot_log=0
	if [[ "${1:-}" == "--scan-godot-log" ]]; then
		scan_godot_log=1
		shift
	fi
	local log_file="$LOG_DIR/$log_name.log"
	local command_text
	local rc=0
	local command_rc=0
	local fatal_markers=""
	local detail=""

	CURRENT_STEP="$name"
	command_text="$(format_command "$@")"
	printf '\n[%s]\nCommand: %s\n' "$name" "$command_text"
	if "$@" > "$log_file" 2>&1; then
		command_rc=0
	else
		command_rc=$?
	fi
	if (( scan_godot_log )); then
		fatal_markers="$(godot_fatal_log_markers "$log_file")"
	fi
	if (( command_rc == 0 )) && [[ -z "$fatal_markers" ]]; then
		record_step "$name" "PASS" "$log_file" ""
		printf 'PASS: %s\n' "$name"
		return
	fi

	rc="$command_rc"
	if (( rc == 0 )); then
		rc=1
	fi
	if (( command_rc != 0 )); then
		detail="exit=$command_rc"
	fi
	if [[ -n "$fatal_markers" ]]; then
		if [[ -n "$detail" ]]; then
			detail+="; "
		fi
		detail+="fatal-log=$fatal_markers"
	fi
	FAILED_STEPS=$((FAILED_STEPS + 1))
	if (( FINAL_EXIT_CODE == 0 )); then
		FINAL_EXIT_CODE="$rc"
	fi
	record_step "$name" "FAIL" "$log_file" "$detail"
	printf 'FAIL: %s (%s)\nLog: %s\nLast log lines:\n' "$name" "$detail" "$log_file" >&2
	tail -n 30 "$log_file" >&2
}

skip_step() {
	record_step "$1" "SKIP" "" "$2"
	printf 'SKIP: %s (%s)\n' "$1" "$2"
}

check_godot_scripts() {
	local godot_bin="$1"
	local project_root="$2"
	local scripts_root="$3"
	local script_file
	local resource_path
	local command_rc
	local final_rc=0
	local found=0

	while IFS= read -r script_file; do
		[[ -n "$script_file" ]] || continue
		found=1
		resource_path="res://${script_file#"$project_root/"}"
		printf '\n[check-only] %s\n' "$resource_path"
		command_rc=0
		"$godot_bin" --headless --path "$project_root" --script "$resource_path" --check-only || command_rc=$?
		if (( command_rc != 0 )) && (( final_rc == 0 )); then
			final_rc="$command_rc"
		fi
	done < <(find "$scripts_root" -type f -name '*.gd' -print | LC_ALL=C sort)

	if (( found == 0 )); then
		printf 'No GDScript files found under: %s\n' "$scripts_root" >&2
		return 1
	fi
	return "$final_rc"
}

find_path_executable() {
	local executable_name="$1"
	local path_entry
	local original_ifs="$IFS"
	local path_value="${PATH:-}"
	local had_noglob=0
	case "$-" in
		*f*) had_noglob=1 ;;
	esac
	set -f
	IFS=:
	for path_entry in $path_value; do
		if [[ -z "$path_entry" ]]; then
			path_entry="."
		fi
		if [[ -f "$path_entry/$executable_name" && -x "$path_entry/$executable_name" ]]; then
			printf '%s' "$path_entry/$executable_name"
			IFS="$original_ifs"
			if (( had_noglob == 0 )); then
				set +f
			fi
			return 0
		fi
	done
	IFS="$original_ifs"
	if (( had_noglob == 0 )); then
		set +f
	fi
	return 0
}

resolve_godot_bin() {
	local candidate=""
	local source=""
	local path_candidate=""
	local attempted=()

	if (( GODOT_BIN_ARG_SET )); then
		candidate="$GODOT_BIN_ARG"
		source="--godot-bin"
		attempted+=("$source: $candidate")
		if [[ -x "$candidate" ]]; then
			GODOT_BIN="$candidate"
			GODOT_SOURCE="$source"
			return 0
		fi
	elif [[ -n "${GODOT_BIN:-}" ]]; then
		candidate="$GODOT_BIN"
		source="GODOT_BIN"
		attempted+=("$source: $candidate")
		if [[ -x "$candidate" ]]; then
			GODOT_BIN="$candidate"
			GODOT_SOURCE="$source"
			return 0
		fi
	else
		path_candidate="$(find_path_executable godot)"
		if [[ -n "$path_candidate" ]]; then
			attempted+=("PATH godot: $path_candidate")
			if [[ -x "$path_candidate" ]]; then
				GODOT_BIN="$path_candidate"
				GODOT_SOURCE="PATH godot"
				return 0
			fi
		else
			attempted+=("PATH godot: not found")
		fi
		path_candidate="$(find_path_executable godot4)"
		if [[ -n "$path_candidate" ]]; then
			attempted+=("PATH godot4: $path_candidate")
			if [[ -x "$path_candidate" ]]; then
				GODOT_BIN="$path_candidate"
				GODOT_SOURCE="PATH godot4"
				return 0
			fi
		else
			attempted+=("PATH godot4: not found")
		fi
		candidate="/Applications/Godot.app/Contents/MacOS/Godot"
		attempted+=("macOS default: $candidate")
		if [[ -x "$candidate" ]]; then
			GODOT_BIN="$candidate"
			GODOT_SOURCE="macOS default"
			return 0
		fi
	fi

	printf 'Godot executable was not found or is not executable. Checked:\n' >&2
	local item
	for item in "${attempted[@]}"; do
		printf '  - %s\n' "$item" >&2
	done
	printf 'Set GODOT_BIN or pass --godot-bin /path/to/Godot.\n' >&2
	return 127
}

git_status_counts() {
	local status_log="$1"
	awk '
		$1 == "??" { untracked++; next }
		{ if (substr($0, 1, 1) != " ") staged++; if (substr($0, 2, 1) != " ") tracked++ }
		END { printf "%d %d %d", staged + 0, tracked + 0, untracked + 0 }
	' "$status_log"
}

count_log_matches() {
	local pattern="$1"
	local log_file
	local matches
	local total=0
	for log_file in "$LOG_DIR"/*.log; do
		[[ -f "$log_file" ]] || continue
		if grep -Fq -- "$pattern" "$log_file"; then
			matches="$(grep -Fc -- "$pattern" "$log_file")"
			total=$((total + matches))
		fi
	done
	printf '%s' "$total"
}

print_summary() {
	local duration_seconds="$1"
	local hours=$((duration_seconds / 3600))
	local minutes=$(((duration_seconds % 3600) / 60))
	local seconds=$((duration_seconds % 60))
	local index
	local warning_summary="none detected"
	local total_warning_count=0
	local error_marker_count=0
	local git_counts
	local staged_count
	local tracked_count
	local untracked_count
	local status_note="unchanged during validation"

	total_warning_count="$(count_log_matches 'WARNING:')"
	error_marker_count="$(count_log_matches 'ERROR:')"
	if (( total_warning_count > 0 )); then
		warning_summary="total warnings ${total_warning_count}"
	fi
	if (( error_marker_count > 0 )); then
		warning_summary="$warning_summary; log ERROR markers $error_marker_count (fatal script-load markers fail their Godot step; other errors follow command exit status)"
	fi
	if [[ -f "$FINAL_STATUS_LOG" ]] && ! cmp -s "$START_STATUS_LOG" "$FINAL_STATUS_LOG"; then
		status_note="changed during validation; review the final status below"
	fi
	git_counts="$(git_status_counts "$FINAL_STATUS_LOG")"
	staged_count="${git_counts%% *}"
	git_counts="${git_counts#* }"
	tracked_count="${git_counts%% *}"
	untracked_count="${git_counts##* }"

	printf '\nCONCENT Validation Summary\n'
	printf '%s\n' '----------------------------------------'
	for ((index = 0; index < ${#STEP_NAMES[@]}; index++)); do
		printf '%-5s %s' "${STEP_STATES[index]}" "${STEP_NAMES[index]}"
		if [[ -n "${STEP_DETAILS[index]}" ]]; then
			printf ' (%s)' "${STEP_DETAILS[index]}"
		fi
		printf '\n'
	done
	printf '%s\n' '----------------------------------------'
	if (( FAILED_STEPS > 0 )); then
		printf 'Result: FAILURE\n'
	else
		printf 'Result: SUCCESS\n'
	fi
	printf 'Duration: %02d:%02d:%02d\n' "$hours" "$minutes" "$seconds"
	printf 'Branch: %s\n' "$BRANCH_NAME"
	printf 'Godot: %s\n' "$GODOT_VERSION"
	printf 'Warnings: %s\n' "$warning_summary"
	printf 'Exit policy: first failing step code is returned; every step log keeps its own code.\n'
	printf 'Git status: tracked %s / staged %s / untracked %s (%s)\n' "$tracked_count" "$staged_count" "$untracked_count" "$status_note"
	if [[ -s "$FINAL_STATUS_LOG" ]]; then
		printf 'Final git status --short:\n'
		cat "$FINAL_STATUS_LOG"
	fi
	if (( KEEP_LOGS )) || (( FAILED_STEPS > 0 )); then
		printf 'Logs: %s\n' "$LOG_DIR"
	fi
}

START_EPOCH="$(date +%s)"
START_TIME="$(date '+%Y-%m-%d %H:%M:%S %Z')"
if ! resolve_godot_bin; then
	exit 127
fi
if ! GODOT_VERSION="$("$GODOT_BIN" --version 2>&1)"; then
	printf 'Godot version probe failed for: %s\n' "$GODOT_BIN" >&2
	exit 127
fi
if BRANCH_NAME="$(git -C "$REPO_ROOT" symbolic-ref --quiet --short HEAD 2>/dev/null)"; then
	:
else
	BRANCH_NAME="detached-$(git -C "$REPO_ROOT" rev-parse --short HEAD)"
fi

printf 'CONCENT validation\n'
printf 'Repo root: %s\n' "$REPO_ROOT"
printf 'Godot project root: %s\n' "$GODOT_PROJECT_ROOT"
printf 'Godot binary: %s (%s)\n' "$GODOT_BIN" "$GODOT_SOURCE"
printf 'Godot version: %s\n' "$GODOT_VERSION"
printf 'Branch: %s\n' "$BRANCH_NAME"
printf 'Mode: %s\n' "$MODE"
printf 'Started: %s\n' "$START_TIME"

run_step "Shell syntax check" "shell_syntax_check" bash -n "$SCRIPT_PATH"
if command -v shellcheck >/dev/null 2>&1; then
	run_step "ShellCheck" "shellcheck" shellcheck "$SCRIPT_PATH"
else
	skip_step "ShellCheck" "not installed"
fi
run_step "Git working diff check" "git_diff_check" git -C "$REPO_ROOT" diff --check
run_step "Git staged diff check" "git_staged_diff_check" git -C "$REPO_ROOT" diff --cached --check
run_step "Godot project parse" "godot_parse" --scan-godot-log "$GODOT_BIN" --headless --path "$GODOT_PROJECT_ROOT" --quit-after 2
run_step "QuarterviewMain startup" "quarterview_main_startup" --scan-godot-log "$GODOT_BIN" --headless --path "$GODOT_PROJECT_ROOT" res://scenes/QuarterviewMain.tscn --quit-after 2
run_step "Apartment shell startup" "apartment_shell_startup" --scan-godot-log "$GODOT_BIN" --headless --path "$GODOT_PROJECT_ROOT" res://scenes/quarterview/QuarterviewApartmentShellCandidate.tscn --quit-after 2
run_step "QuarterviewRoom startup" "quarterview_room_startup" --scan-godot-log "$GODOT_BIN" --headless --path "$GODOT_PROJECT_ROOT" res://scenes/quarterview/QuarterviewRoom.tscn --quit-after 2
run_step "Apartment playable startup" "apartment_playable_startup" --scan-godot-log "$GODOT_BIN" --headless --path "$GODOT_PROJECT_ROOT" res://scenes/quarterview/QuarterviewApartmentPlayable.tscn --quit-after 2
if [[ "$MODE" == "full" ]]; then
	run_step "Unit test script parse" "unit_test_script_parse" --scan-godot-log check_godot_scripts "$GODOT_BIN" "$GODOT_PROJECT_ROOT" "$GODOT_PROJECT_ROOT/test/unit"
	run_step "Full GUT" "gut_full" --scan-godot-log "$GODOT_BIN" --headless --path "$GODOT_PROJECT_ROOT" -s res://addons/gut/gut_cmdln.gd -gdir=res://test/unit -gexit
else
	skip_step "Unit test script parse" "quick mode"
	skip_step "Full GUT" "quick mode"
fi
run_step "Final Git status" "git_status_final" git -C "$REPO_ROOT" status --short

CURRENT_STEP="summary"
END_EPOCH="$(date +%s)"
print_summary "$((END_EPOCH - START_EPOCH))"
if (( FAILED_STEPS > 0 )); then
	exit "$FINAL_EXIT_CODE"
fi
SCRIPT_SUCCEEDED=1
