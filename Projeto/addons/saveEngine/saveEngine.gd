@tool
extends EditorPlugin

func _enter_tree() -> void:
	add_autoload_singleton("SaveService", "res://addons/saveEngine/scripts/SaveService.gd")
	add_custom_type("SaveAgent", "Node", preload("res://addons/saveEngine/scripts/SaveAgent.gd"), preload("res://addons/saveEngine/SaveAgent.svg"))
	add_custom_type("SaveElement3D", "Node3D", preload("res://addons/saveEngine/scripts/SaveElement3D.gd"), preload("res://addons/saveEngine/SaveElement3D.svg"))
	add_custom_type("SaveElement2D", "Node2D", preload("res://addons/saveEngine/scripts/SaveElement2D.gd"), preload("res://addons/saveEngine/SaveElement2D.svg"))

func _exit_tree() -> void:
	remove_autoload_singleton("SaveService")
	remove_custom_type("SaveAgent")
	remove_custom_type("SaveElement3D")
	remove_custom_type("SaveElement2D")
	
