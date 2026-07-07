extends GutTest

const SELECTED_AUDIO_FILES := [
	"res://assets/audio/third_party/kenney/ui/ui_select.wav",
	"res://assets/audio/third_party/kenney/ui/ui_confirm.wav",
	"res://assets/audio/third_party/kenney/interface/prototype_open.wav",
	"res://assets/audio/third_party/kenney/interface/prototype_cancel.wav",
	"res://assets/audio/third_party/kenney/interface/hacking_hit.wav",
	"res://assets/audio/third_party/kenney/interface/hacking_damage.wav",
	"res://assets/audio/third_party/kenney/interface/hacking_success.wav",
	"res://assets/audio/third_party/kenney/interface/hacking_fail.wav",
]

const SELECTED_PROMPT_FILES := [
	"res://assets/ui/third_party/kenney/input_prompts/key_a.png",
	"res://assets/ui/third_party/kenney/input_prompts/key_arrows.png",
	"res://assets/ui/third_party/kenney/input_prompts/key_b.png",
	"res://assets/ui/third_party/kenney/input_prompts/key_backspace.png",
	"res://assets/ui/third_party/kenney/input_prompts/key_d.png",
	"res://assets/ui/third_party/kenney/input_prompts/key_e.png",
	"res://assets/ui/third_party/kenney/input_prompts/key_enter.png",
	"res://assets/ui/third_party/kenney/input_prompts/key_escape.png",
	"res://assets/ui/third_party/kenney/input_prompts/key_j.png",
	"res://assets/ui/third_party/kenney/input_prompts/key_r.png",
	"res://assets/ui/third_party/kenney/input_prompts/key_s.png",
	"res://assets/ui/third_party/kenney/input_prompts/key_shift.png",
	"res://assets/ui/third_party/kenney/input_prompts/key_space.png",
	"res://assets/ui/third_party/kenney/input_prompts/key_w.png",
	"res://assets/ui/third_party/kenney/input_prompts/mouse_left.png",
]

const LICENSE_FILES := [
	"res://assets/audio/third_party/kenney/LICENSES/kenney_ui_audio_LICENSE.txt",
	"res://assets/audio/third_party/kenney/LICENSES/kenney_interface_sounds_LICENSE.txt",
	"res://assets/ui/third_party/kenney/LICENSES/kenney_input_prompts_LICENSE.txt",
]

const INVENTORY_PATH := "res://../docs/reference/TECHNICAL_MAP.md"


func test_selected_audio_files_exist() -> void:
	assert_true(SELECTED_AUDIO_FILES.size() > 0, "Smoke test should include selected prototype audio files.")
	for path in SELECTED_AUDIO_FILES:
		assert_true(FileAccess.file_exists(path), "%s should exist." % path)
		assert_false(path.begins_with("res://addons/"), "%s should not point at an addon source folder." % path)


func test_selected_audio_files_load_as_wav() -> void:
	for path in SELECTED_AUDIO_FILES:
		var stream := AudioStreamWAV.load_from_file(path)
		assert_not_null(stream, "%s should load as AudioStreamWAV." % path)


func test_selected_input_prompt_files_exist() -> void:
	assert_true(SELECTED_PROMPT_FILES.size() > 0, "Smoke test should include selected input prompt PNG files.")
	for path in SELECTED_PROMPT_FILES:
		assert_true(FileAccess.file_exists(path), "%s should exist." % path)
		assert_false(path.begins_with("res://addons/"), "%s should not point at an addon source folder." % path)


func test_selected_input_prompt_images_load() -> void:
	for path in SELECTED_PROMPT_FILES:
		var texture := ResourceLoader.load(path, "Texture2D")
		assert_not_null(texture, "%s should load as Texture2D." % path)
		assert_true(texture is Texture2D, "%s should be a Texture2D." % path)
		assert_true(texture.get_width() > 0, "%s should have positive width." % path)
		assert_true(texture.get_height() > 0, "%s should have positive height." % path)


func test_license_files_exist_and_are_not_empty() -> void:
	for path in LICENSE_FILES:
		assert_true(FileAccess.file_exists(path), "%s should exist." % path)
		var text := FileAccess.get_file_as_string(path).strip_edges()
		assert_false(text.is_empty(), "%s should not be empty." % path)


func test_asset_inventory_mentions_selected_asset_groups() -> void:
	var inventory_path := ProjectSettings.globalize_path(INVENTORY_PATH)
	assert_true(FileAccess.file_exists(inventory_path), "Current technical asset inventory reference should be accessible.")

	var inventory_text := FileAccess.get_file_as_string(inventory_path)
	assert_true(inventory_text.contains("Kenney UI Audio"), "Inventory should mention Kenney UI Audio.")
	assert_true(inventory_text.contains("Kenney Interface Sounds"), "Inventory should mention Kenney Interface Sounds.")
	assert_true(inventory_text.contains("Kenney Input Prompts"), "Inventory should mention Kenney Input Prompts.")
	assert_true(inventory_text.contains("Current Use"), "Inventory should include Current Use tracking.")
	assert_true(inventory_text.contains("selected copies"), "Inventory should mention selected copied asset paths.")
