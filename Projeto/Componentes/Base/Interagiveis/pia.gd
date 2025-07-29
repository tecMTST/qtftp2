class_name Pia extends BaseInteragivel

func _ready() -> void:
	Nome = "Pia"

func _on_componente_interagivel_interagir(jogador: Player):
	if jogador.esta_agarrando != null:
		jogador.objeto_agarrado.enxaguar()
