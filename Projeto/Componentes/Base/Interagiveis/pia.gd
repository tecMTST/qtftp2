class_name Pia extends BaseInteragivel

@onready var indicador: Sprite2D = $Indicador

func _ready() -> void:
	nome = "Pia"

func _process(_delta: float) -> void:
	indicador.visible = ControleDeFase.verifica_proximo_ponto("Pia")

func _on_componente_interagivel_interagir(jogador: Player):
	if jogador.esta_agarrando:
		var objeto_ingrediente = jogador.objeto_agarrado
		if objeto_ingrediente.ingrediente.acoes[0].alvo == "pia":
			jogador.objeto_agarrado.acao_pia()
			if objeto_ingrediente.ingrediente.acoes[0].evento != "":
				Eventos.evento_iniciado.emit(objeto_ingrediente.ingrediente.acoes[0].evento)
