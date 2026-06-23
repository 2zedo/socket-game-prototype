class_name PrototypeSfx
extends Node

const DEFAULT_VOLUME_DB := -8.0

const STREAM_PATHS := {
	"select": "res://assets/audio/third_party/kenney/ui/ui_select.wav",
	"confirm": "res://assets/audio/third_party/kenney/ui/ui_confirm.wav",
	"open": "res://assets/audio/third_party/kenney/interface/prototype_open.wav",
	"cancel": "res://assets/audio/third_party/kenney/interface/prototype_cancel.wav",
	"error": "res://assets/audio/third_party/kenney/interface/hacking_damage.wav",
	"hit": "res://assets/audio/third_party/kenney/interface/hacking_hit.wav",
	"damage": "res://assets/audio/third_party/kenney/interface/hacking_damage.wav",
	"success": "res://assets/audio/third_party/kenney/interface/hacking_success.wav",
	"fail": "res://assets/audio/third_party/kenney/interface/hacking_fail.wav",
}

var stream_cache := {}


func play(sound_key: String) -> void:
	var stream := _get_stream(sound_key)
	if stream == null:
		return

	var player := AudioStreamPlayer.new()
	player.stream = stream
	player.volume_db = DEFAULT_VOLUME_DB
	player.finished.connect(player.queue_free)
	add_child(player)
	player.play()


func _get_stream(sound_key: String) -> AudioStream:
	if stream_cache.has(sound_key):
		return stream_cache[sound_key]

	var path := String(STREAM_PATHS.get(sound_key, ""))
	if path.is_empty():
		return null

	var stream := AudioStreamWAV.load_from_file(path)
	if stream == null:
		push_warning("PrototypeSfx could not load %s from %s" % [sound_key, path])
		return null

	stream_cache[sound_key] = stream
	return stream


func play_select() -> void:
	play("select")


func play_confirm() -> void:
	play("confirm")


func play_open() -> void:
	play("open")


func play_cancel() -> void:
	play("cancel")


func play_error() -> void:
	play("error")


func play_hit() -> void:
	play("hit")


func play_damage() -> void:
	play("damage")


func play_success() -> void:
	play("success")


func play_fail() -> void:
	play("fail")
