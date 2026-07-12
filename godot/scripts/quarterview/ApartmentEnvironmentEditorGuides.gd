@tool
extends Node2D


func _ready() -> void:
	visible = Engine.is_editor_hint()


func _process(_delta: float) -> void:
	visible = Engine.is_editor_hint()
