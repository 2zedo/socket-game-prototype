extends Node2D

const PLAYER_SCRIPT := preload("res://scripts/prototypes/HackingPrototypePlayer.gd")
const ENEMY_SCRIPT := preload("res://scripts/prototypes/HackingPrototypeEnemy.gd")
const PROJECTILE_SCRIPT := preload("res://scripts/prototypes/HackingPrototypeProjectile.gd")

const ARENA_RECT := Rect2(Vector2(130, 90), Vector2(1020, 540))
const START_POSITION := Vector2(250, 530)
const OBJECTIVE_POSITION := Vector2(900, 260)
const OBJECTIVE_RADIUS := 72.0
const EXIT_RECT := Rect2(Vector2(160, 135), Vector2(120, 95))
const MAX_TRACE := 100

const HAZARDS := [
	{
		"key": "scan_line",
		"label": "SCAN LINE",
		"rect": Rect2(Vector2(520, 155), Vector2(28, 385)),
		"trace": 25,
		"color": Color(1.0, 0.12, 0.35, 0.30),
	},
	{
		"key": "unstable_tile",
		"label": "UNSTABLE TILE",
		"rect": Rect2(Vector2(670, 390), Vector2(180, 62)),
		"trace": 15,
		"color": Color(1.0, 0.54, 0.10, 0.24),
	},
]

const ENEMY_SPAWNS := [
	{"position": Vector2(615, 210), "kind": "security_drone"},
	{"position": Vector2(830, 470), "kind": "security_drone"},
	{"position": Vector2(985, 335), "kind": "firewall_sentry"},
]

@onready var background_layer: Node2D = $Arena/Background
@onready var wall_layer: Node2D = $Arena/WallLayer
@onready var hazard_layer: Node2D = $Arena/HazardLayer
@onready var objective_layer: Node2D = $Arena/ObjectiveLayer
@onready var enemy_layer: Node2D = $Arena/EnemyLayer
@onready var projectile_layer: Node2D = $Arena/ProjectileLayer
@onready var player_layer: Node2D = $Arena/PlayerLayer
@onready var exit_layer: Node2D = $Arena/ExitLayer
@onready var ui_label: Label = $UI/InfoLabel

var player: CharacterBody2D
var trace := 0
var objective_extracted := false
var mission_state := "running"
var state_text := "Running"
var hazard_cooldown := 0.0
var objective_visual: Polygon2D
var exit_visual: Polygon2D


func _ready() -> void:
	reset_prototype()


func _process(delta: float) -> void:
	if mission_state == "running":
		hazard_cooldown = maxf(0.0, hazard_cooldown - delta)
		_check_hazards()
		_check_exit()
	_update_ui()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_R:
			reset_prototype()
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_E:
			_try_extract_objective()
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_ESCAPE:
			print("Hacking action prototype: ESC pressed, no exit is wired in this prototype.")
			get_viewport().set_input_as_handled()


func reset_prototype() -> void:
	trace = 0
	objective_extracted = false
	mission_state = "running"
	state_text = "Running"
	hazard_cooldown = 0.0

	_clear_layer(background_layer)
	_clear_layer(wall_layer)
	_clear_layer(hazard_layer)
	_clear_layer(objective_layer)
	_clear_layer(enemy_layer)
	_clear_layer(projectile_layer)
	_clear_layer(player_layer)
	_clear_layer(exit_layer)

	_build_background()
	_build_walls()
	_build_hazards()
	_build_objective()
	_build_exit()
	_spawn_player()
	_spawn_enemies()
	_update_ui()


func _clear_layer(layer: Node) -> void:
	for child in layer.get_children():
		child.queue_free()


func _build_background() -> void:
	_add_rect_visual(background_layer, ARENA_RECT.grow(44.0), Color(0.01, 0.015, 0.03, 1.0), Color(0.08, 0.35, 0.40, 0.65), 2.0)
	_add_rect_visual(background_layer, ARENA_RECT, Color(0.03, 0.06, 0.10, 1.0), Color(0.18, 0.82, 0.90, 0.30), 2.0)

	for x in range(int(ARENA_RECT.position.x) + 80, int(ARENA_RECT.end.x), 110):
		var line := Line2D.new()
		line.points = PackedVector2Array([
			Vector2(x, ARENA_RECT.position.y + 14.0),
			Vector2(x, ARENA_RECT.end.y - 14.0),
		])
		line.width = 1.0
		line.default_color = Color(0.10, 0.42, 0.50, 0.13)
		background_layer.add_child(line)

	for y in range(int(ARENA_RECT.position.y) + 70, int(ARENA_RECT.end.y), 90):
		var line := Line2D.new()
		line.points = PackedVector2Array([
			Vector2(ARENA_RECT.position.x + 14.0, y),
			Vector2(ARENA_RECT.end.x - 14.0, y),
		])
		line.width = 1.0
		line.default_color = Color(0.10, 0.42, 0.50, 0.13)
		background_layer.add_child(line)


func _build_walls() -> void:
	var thickness := 36.0
	_add_wall(Rect2(ARENA_RECT.position - Vector2(thickness, thickness), Vector2(ARENA_RECT.size.x + thickness * 2.0, thickness)))
	_add_wall(Rect2(Vector2(ARENA_RECT.position.x - thickness, ARENA_RECT.end.y), Vector2(ARENA_RECT.size.x + thickness * 2.0, thickness)))
	_add_wall(Rect2(ARENA_RECT.position - Vector2(thickness, 0.0), Vector2(thickness, ARENA_RECT.size.y)))
	_add_wall(Rect2(Vector2(ARENA_RECT.end.x, ARENA_RECT.position.y), Vector2(thickness, ARENA_RECT.size.y)))

	_add_wall(Rect2(Vector2(410, 280), Vector2(150, 38)))
	_add_wall(Rect2(Vector2(720, 195), Vector2(120, 34)))
	_add_wall(Rect2(Vector2(405, 445), Vector2(120, 34)))
	_add_wall(Rect2(Vector2(930, 450), Vector2(110, 36)))


func _add_wall(rect: Rect2) -> void:
	_add_rect_visual(wall_layer, rect, Color(0.08, 0.10, 0.16, 0.95), Color(0.32, 0.95, 1.0, 0.28), 1.5)

	var body := StaticBody2D.new()
	body.collision_layer = 1
	body.collision_mask = 0
	body.position = rect.position + rect.size * 0.5

	var shape := CollisionShape2D.new()
	var rectangle := RectangleShape2D.new()
	rectangle.size = rect.size
	shape.shape = rectangle
	body.add_child(shape)
	wall_layer.add_child(body)


func _build_hazards() -> void:
	for hazard in HAZARDS:
		var visual := _add_rect_visual(hazard_layer, hazard["rect"], hazard["color"], Color(1.0, 0.20, 0.42, 0.75), 2.0)
		visual.name = hazard["key"]
		_add_world_label(hazard_layer, hazard["label"], hazard["rect"].position + Vector2(8, 8), Color(1.0, 0.45, 0.58, 1.0))


func _build_objective() -> void:
	var objective_rect := Rect2(OBJECTIVE_POSITION - Vector2(42, 42), Vector2(84, 84))
	objective_visual = _add_rect_visual(objective_layer, objective_rect, Color(0.14, 0.82, 0.92, 0.28), Color(0.25, 1.0, 0.95, 0.90), 2.0)
	_add_world_label(objective_layer, "DATA NODE", OBJECTIVE_POSITION + Vector2(-44, -68), Color(0.65, 1.0, 0.95, 1.0))


func _build_exit() -> void:
	exit_visual = _add_rect_visual(exit_layer, EXIT_RECT, Color(0.22, 0.24, 0.30, 0.48), Color(0.45, 0.48, 0.58, 0.85), 2.0)
	_add_world_label(exit_layer, "EXIT", EXIT_RECT.position + Vector2(28, 34), Color(0.72, 0.75, 0.82, 1.0))


func _spawn_player() -> void:
	player = CharacterBody2D.new()
	player.name = "HackingAvatar"
	player.set_script(PLAYER_SCRIPT)
	player.position = START_POSITION
	player_layer.add_child(player)
	player.shot_requested.connect(_on_player_shot_requested)
	player.health_changed.connect(_on_player_health_changed)


func _spawn_enemies() -> void:
	for spawn in ENEMY_SPAWNS:
		var enemy := CharacterBody2D.new()
		enemy.name = "Enemy_%s" % spawn["kind"]
		enemy.set_script(ENEMY_SCRIPT)
		enemy.position = spawn["position"]
		enemy_layer.add_child(enemy)
		enemy.setup(player, spawn["kind"])


func _on_player_shot_requested(origin: Vector2, direction: Vector2) -> void:
	if mission_state != "running":
		return

	var projectile := Area2D.new()
	projectile.name = "HackingShot"
	projectile.set_script(PROJECTILE_SCRIPT)
	projectile.global_position = origin
	projectile_layer.add_child(projectile)
	projectile.setup(direction)


func _on_player_health_changed(current_hp: int) -> void:
	if current_hp <= 0:
		_finish_mission("failed", "FAILED - Avatar damaged")


func _try_extract_objective() -> void:
	if mission_state != "running" or objective_extracted or not is_instance_valid(player):
		return

	if player.global_position.distance_to(OBJECTIVE_POSITION) > OBJECTIVE_RADIUS:
		print("Hacking action prototype: objective is out of range.")
		return

	objective_extracted = true
	state_text = "Running - Data extracted"
	objective_visual.color = Color(0.42, 1.0, 0.72, 0.34)
	exit_visual.color = Color(0.10, 0.50, 0.95, 0.44)
	print("Hacking action prototype: data node extracted.")


func _check_hazards() -> void:
	if hazard_cooldown > 0.0 or not is_instance_valid(player):
		return
	if player.has_method("is_hopping") and player.is_hopping():
		return

	for hazard in HAZARDS:
		var rect: Rect2 = hazard["rect"]
		if rect.has_point(player.global_position):
			trace = mini(MAX_TRACE, trace + int(hazard["trace"]))
			hazard_cooldown = 0.55
			if trace >= MAX_TRACE:
				_finish_mission("failed", "FAILED - Trace lost")
			return


func _check_exit() -> void:
	if not objective_extracted or not is_instance_valid(player):
		return
	if EXIT_RECT.has_point(player.global_position):
		_finish_mission("success", "SUCCESS - Data extracted")


func _finish_mission(next_state: String, next_text: String) -> void:
	if mission_state != "running":
		return
	mission_state = next_state
	state_text = next_text

	if is_instance_valid(player) and player.has_method("set_controls_enabled"):
		player.set_controls_enabled(false)
	for enemy in enemy_layer.get_children():
		enemy.set_physics_process(false)
	for projectile in projectile_layer.get_children():
		projectile.queue_free()
	print("Hacking action prototype: %s" % state_text)


func _update_ui() -> void:
	var hp_text := "-"
	if is_instance_valid(player):
		hp_text = str(player.hp)

	var objective_text := "Find data node"
	if objective_extracted:
		objective_text = "Reach extraction gate"
	if mission_state == "success":
		objective_text = "Complete"
	elif mission_state == "failed":
		objective_text = "Restart with R"

	ui_label.text = "\n".join([
		"HACKING ACTION PROTOTYPE",
		"WASD/Arrow: Move",
		"J/LMB: Shot",
		"Shift/K: Roll",
		"Space: Hop",
		"E: Extract Node",
		"R: Restart",
		"",
		"HP: %s" % hp_text,
		"Trace: %d%%" % trace,
		"Objective: %s" % objective_text,
		"State: %s" % state_text,
	])


func _add_rect_visual(layer: Node2D, rect: Rect2, fill_color: Color, outline_color: Color = Color.TRANSPARENT, outline_width: float = 0.0) -> Polygon2D:
	var polygon := Polygon2D.new()
	polygon.polygon = PackedVector2Array([
		rect.position,
		Vector2(rect.end.x, rect.position.y),
		rect.end,
		Vector2(rect.position.x, rect.end.y),
	])
	polygon.color = fill_color
	layer.add_child(polygon)

	if outline_width > 0.0 and outline_color.a > 0.0:
		var outline := Line2D.new()
		outline.points = PackedVector2Array([
			rect.position,
			Vector2(rect.end.x, rect.position.y),
			rect.end,
			Vector2(rect.position.x, rect.end.y),
			rect.position,
		])
		outline.width = outline_width
		outline.default_color = outline_color
		layer.add_child(outline)

	return polygon


func _add_world_label(layer: Node2D, text: String, label_position: Vector2, color: Color) -> void:
	var label := Label.new()
	label.text = text
	label.position = label_position
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.85))
	label.add_theme_constant_override("shadow_offset_x", 1)
	label.add_theme_constant_override("shadow_offset_y", 1)
	layer.add_child(label)
