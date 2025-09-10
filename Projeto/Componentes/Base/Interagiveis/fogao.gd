class_name Fogao extends BaseInteragivel

var objeto_atual : IngredienteBase = null
@onready var indicador: Sprite2D = $Indicador
@onready var pivot_objeto : Node2D = $Pivot
@onready var fogo_animado : AnimatedSprite2D = $AnimatedFire

func _ready() -> void:
	nome = "Fogão"

func _process(_delta: float) -> void:
	indicador.visible = ControleDeFase.verifica_proximo_ponto("Fogão")

func _on_componente_interagivel_interagir(jogador: Player) -> void:
	if(objeto_atual):
		if(jogador.esta_agarrando): return
		jogador.objeto_agarrado = objeto_atual
		_recolher_objeto()
		jogador.agarrar()
	else:
		if ControleDeFase.nivel_atual.id == 3:
			var fase03 = "res://Dialogo/Fase03.dialogue"
			ControleDeFase.jogador.iniciar_dialogo(load(fase03), "semgas", 3.0)
		if(!jogador.esta_agarrando): return
		var objeto_ingrediente = jogador.objeto_agarrado
		if objeto_ingrediente.ingrediente.acoes[0].alvo == "fogao":
			if(jogador.objeto_agarrado.acao_fogao()):
				_cozinhar_objeto(jogador.objeto_agarrado)
				jogador.soltar()
			if objeto_ingrediente.ingrediente.acoes[0].evento != "":
				Eventos.evento_iniciado.emit(objeto_ingrediente.ingrediente.acoes[0].evento)

func _recolher_objeto() -> void:
	objeto_atual.acao_fogao()
	objeto_atual = null
	fogo_animado.hide()
	ControleDeAudio.para_efeito_ciclo("fogao_cozinhando")

func _cozinhar_objeto(objeto : IngredienteBase) -> void:
	objeto_atual = objeto
	objeto_atual.ao_transformar.connect(ao_transformar_objeto_cozinhando)
	_posicionar_objeto_no_fogao()
	fogo_animado.show()
	ControleDeAudio.toca_efeito("fogao_ligar")
	ControleDeAudio.toca_efeito_ciclo("fogao_cozinhando", "fogao_cozinhando")

func _posicionar_objeto_no_fogao() -> void:
	objeto_atual.reparent(pivot_objeto)
	objeto_atual.global_position = pivot_objeto.global_position

func ao_transformar_objeto_cozinhando(novo_objeto: IngredienteBase):
	objeto_atual = novo_objeto
	ControleDeAudio.para_efeito_ciclo("fogao_cozinhado")
	ControleDeAudio.toca_efeito("fogao_alarme")
