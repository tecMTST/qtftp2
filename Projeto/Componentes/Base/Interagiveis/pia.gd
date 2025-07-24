class_name Pia extends BaseInteragivel

func _ready() -> void:
	Nome = "Pia"

func _on_componente_interagivel_interagir(jogador: Player):
	if jogador.objeto_agarrado != null:
		var objetoIngrediente = jogador.objeto_agarrado
		if objetoIngrediente.Ingrediente.Acoes[0].Alvo == "pia":
			jogador.objeto_agarrado.enxaguar()
