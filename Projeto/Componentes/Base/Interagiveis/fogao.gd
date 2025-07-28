class_name Fogao extends BaseInteragivel

@onready var pivotObjeto : Node2D = $Pivot
@onready var fogoAnimado : AnimatedSprite2D = $AnimatedFire
var objetoAtual : ObjetoAgarravel = null

func _ready() -> void:
	Nome = "Fogão"

func _process(delta: float) -> void:
	pass

func _on_componente_interagivel_interagir(jogador: Player) -> void:
	if(objetoAtual):
		if(jogador.objeto_agarrado): return
		jogador.objeto_agarrado = objetoAtual
		_recolherObjeto()
		jogador.agarrar()
	else:
		if(!jogador.objeto_agarrado): return
		var objetoIngrediente = jogador.objeto_agarrado
		if objetoIngrediente.Ingrediente.Acoes[0].Alvo == "fogao":
			if(jogador.objeto_agarrado.cozinhar()):
				_cozinharObjeto(jogador.objeto_agarrado)
				jogador.soltar()

func _recolherObjeto() -> void:
	objetoAtual.cozinhar()
	objetoAtual = null
	fogoAnimado.hide()

func _cozinharObjeto(objeto : ObjetoAgarravel) -> void:
	objetoAtual = objeto
	objetoAtual.ao_transformar.connect(ao_transformar_objeto_cozinhando)
	_posicionarObjetoNoFogao()
	fogoAnimado.show()
	ControleDeAudio.toca_efeito("fogao")

func _posicionarObjetoNoFogao() -> void:
	objetoAtual.reparent(pivotObjeto)
	objetoAtual.global_position = pivotObjeto.global_position

func ao_transformar_objeto_cozinhando(novo_objeto: ObjetoAgarravel):
	objetoAtual = novo_objeto
