extends Control

func _on_sair_fase_button_up() -> void:
	GuiTransitions.go_to("Menu")

func _on_repetir_fase_button_up() -> void:
	get_tree().reload_current_scene()
	GuiTransitions.hide("Fim")
