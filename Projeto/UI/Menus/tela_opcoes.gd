extends Control


func _on_voltar_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/Menus/menu_principal.tscn")


func _on_value_changed(new_value: float) -> void:
	ControleDeAudio._on_value_changed(new_value)


func _on_value_changed_sfx(new_value: float) -> void:
	ControleDeAudio._on_value_changed_sfx(new_value)
