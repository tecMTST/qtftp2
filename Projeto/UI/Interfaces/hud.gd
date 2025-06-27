extends Control
@onready var label: Label = $Tempo/MarginContainer/Label

func _process(_delta: float) -> void:
	label.text = ControleDeFase.EstadoNivel.TempoRestanteFormatado
