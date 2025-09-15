class_name Pia extends BaseInteragivel

@onready var indicador: Sprite2D = $Indicador
@onready var instancia_agua = load("res://Componentes/Ingredientes/IngredienteBase.tscn")

func _ready() -> void:
	nome = "Pia"

func _process(_delta: float) -> void:
	indicador.visible = ControleDeFase.verifica_proximo_ponto("pia")


func _on_componente_interagivel_interagir(jogador: Player):
	print_debug("[pia]")
	if ControleDeFase.passo_atual.alvo != "pia":
		print_debug("  [-] não é hora de usar a pia")
		return
	if jogador.esta_agarrando:
		var objeto_ingrediente = jogador.objeto_agarrado
		if objeto_ingrediente.ingrediente.acoes[0].alvo == "pia":
			print_debug("  [-] jogador molhando ", objeto_ingrediente.id)
			objeto_ingrediente.transformar()
	else:
		print_debug("  [-] jogador pegando água da pia")
		var dados_agua = Globais.obtem_ingrediente("agua_fria")
		var nova_agua: IngredienteBase = instancia_agua.instantiate()
		nova_agua.iniciar(dados_agua)
		nova_agua.estado_atual = nova_agua.EstadoIngrediente.PRONTO_PARA_COZINHAR
		jogador.agarrar(nova_agua)
		ControleDeFase.proximo_passo()
