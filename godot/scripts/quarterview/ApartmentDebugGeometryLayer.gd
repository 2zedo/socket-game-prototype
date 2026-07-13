extends Node2D
class_name ApartmentDebugGeometryLayer

var _commands: Array[Dictionary] = []


func clear_commands() -> void:
	_commands.clear()
	queue_redraw()


func add_polyline_command(command_name: String, points: PackedVector2Array, color: Color, width: float, dashed := false, dash_length := 8.0) -> void:
	if points.size() < 2:
		return
	_commands.append({
		"name": command_name,
		"points": points,
		"color": color,
		"width": width,
		"dashed": dashed,
		"dash_length": dash_length,
	})
	queue_redraw()


func command_count() -> int:
	return _commands.size()


func has_command_prefix(prefix: String) -> bool:
	for command in _commands:
		if String(command.get("name", "")).begins_with(prefix):
			return true
	return false


func command_color(command_name: String) -> Color:
	for command in _commands:
		if String(command.get("name", "")) == command_name:
			return Color(command.get("color", Color.TRANSPARENT))
	return Color.TRANSPARENT


func _draw() -> void:
	for command in _commands:
		var points := PackedVector2Array(command.get("points", PackedVector2Array()))
		var color := Color(command.get("color", Color.WHITE))
		var width := float(command.get("width", 1.0))
		if bool(command.get("dashed", false)):
			for index in range(points.size() - 1):
				draw_dashed_line(
					points[index],
					points[index + 1],
					color,
					width,
					float(command.get("dash_length", 8.0)),
					true,
					true
				)
		else:
			draw_polyline(points, color, width, true)
