extends TouchScreenButton

func _process(_delta: float) -> void:
	visible = ControleDeFase.travar_dialogos && ControleDeFase.esta_dialogando

func _on_pressed() -> void:
	Dialogic.Inputs.auto_skip.enabled = true

func _on_released() -> void:
	Dialogic.Inputs.auto_skip.enabled = false
