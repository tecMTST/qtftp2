extends Control

func _on_close_button_button_down() -> void:
	GuiTransitions.hide("Modal")
	await GuiTransitions.hide_completed
	queue_free()
