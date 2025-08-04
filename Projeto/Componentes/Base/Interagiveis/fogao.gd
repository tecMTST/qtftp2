class_name Fogao extends BaseInteragivel

@onready var pivotObjeto : Node2D = $Pivot
@onready var fogoAnimado : AnimatedSprite2D = $AnimatedFire
var objetoAtual : IngredienteBase = null

func _ready() -> void:
	Nome = "Fogão"

func _process(delta: float) -> void:
	pass

func _on_componente_interagivel_interagir(jogador: Player) -> void:
	if(objetoAtual):
		if(jogador.esta_agarrando): return
		jogador.objeto_agarrado = objetoAtual
		_recolherObjeto()
		jogador.agarrar()
	else:
		if(!jogador.esta_agarrando): return
		var objetoIngrediente = jogador.objeto_agarrado
		if objetoIngrediente.Ingrediente.Acoes[0].Alvo == "fogao":
			if(jogador.objeto_agarrado.acao_fogao()):
				_cozinharObjeto(jogador.objeto_agarrado)
				jogador.soltar()
			if objetoIngrediente.Ingrediente.Acoes[0].Evento != "":
				Eventos.EventoIniciado.emit(objetoIngrediente.Ingrediente.Acoes[0].Evento)

func _recolherObjeto() -> void:
	objetoAtual.acao_fogao()
	objetoAtual = null
	fogoAnimado.hide()
	ControleDeAudio.para_efeito_ciclo("fogao_cozinhando")

func _cozinharObjeto(objeto : IngredienteBase) -> void:
	objetoAtual = objeto
	objetoAtual.ao_transformar.connect(ao_transformar_objeto_cozinhando)
	_posicionarObjetoNoFogao()
	fogoAnimado.show()
	ControleDeAudio.toca_efeito("fogao_ligar")
	ControleDeAudio.toca_efeito_ciclo("fogao_cozinhando", "fogao_cozinhando")

func _posicionarObjetoNoFogao() -> void:
	objetoAtual.reparent(pivotObjeto)
	objetoAtual.global_position = pivotObjeto.global_position

func ao_transformar_objeto_cozinhando(novo_objeto: IngredienteBase):
	objetoAtual = novo_objeto
	ControleDeAudio.para_efeito_ciclo("fogao_cozinhado")
	ControleDeAudio.toca_efeito("fogao_alarme")
