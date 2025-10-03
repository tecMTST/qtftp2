extends TouchScreenButton

@onready var _is_cutscene := get_tree().current_scene.name.to_lower().begins_with('cutscene')

func _ready() -> void:
	if !pressed.is_connected(_on_pressed): pressed.connect(_on_pressed)
	if !released.is_connected(_on_released): released.connect(_on_released)

func _process(_delta: float) -> void:
	if (_is_cutscene):
		visible = true
		return
	visible = ControleDeFase.travar_dialogos && ControleDeFase.esta_dialogando && !get_tree().paused

func _on_pressed() -> void:
	Dialogic.Inputs.auto_skip.enabled = true

func _on_released() -> void:
	Dialogic.Inputs.auto_skip.enabled = false
