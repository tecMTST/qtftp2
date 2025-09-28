extends TouchScreenButton

func _ready() -> void:
	pressed.connect(_on_pressed)
	released.connect(_on_released)

func _process(_delta: float) -> void:
	if (get_tree().current_scene.name.begins_with('cutscene')):
		visible = true
		return
	visible = ControleDeFase.travar_dialogos && ControleDeFase.esta_dialogando && !get_tree().paused

func _on_pressed() -> void:
	Dialogic.Inputs.auto_skip.enabled = true

func _on_released() -> void:
	Dialogic.Inputs.auto_skip.enabled = false
