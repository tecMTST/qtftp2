@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_custom_type("TouchAnalog", "Node2D",  preload("scripts/TouchAnalog.gd"), preload("icons/PolyTouchAnalog2D.svg"))		

func _exit_tree() -> void:
	remove_custom_type("TouchAnalog")
