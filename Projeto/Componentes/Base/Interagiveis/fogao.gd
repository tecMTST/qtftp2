class_name Fogao extends BaseInteragivel

@onready var pivotObjeto : Node2D = $Pivot
@onready var fogoAnimado : AnimatedSprite2D = $AnimatedFire
var objetoAtual : ObjetoAgarravel = null

func _ready() -> void:
	Nome = "Fogão"
func _process(delta: float) -> void:
	pass

func _interagir(jogador: Player):	
	if(objetoAtual):
		if(jogador.objetoAgarrado): return
		jogador.objetoAgarrado = objetoAtual
		_recorlherObjeto()
		jogador.agarrar()
	else:
		if(!jogador.objetoAgarrado): return
		if(jogador.objetoAgarrado.cozinhar()):
			_cozinharObjeto(jogador.objetoAgarrado)
			jogador.soltar()
		
func _recorlherObjeto() -> void:
	objetoAtual.ao_transformar.disconnect(ao_transformar_objeto_cozinhando)
	objetoAtual.cozinhar()
	objetoAtual = null
	fogoAnimado.hide()

func _cozinharObjeto(objeto : ObjetoAgarravel) -> void:
	objetoAtual = objeto
	objetoAtual.ao_transformar.connect(ao_transformar_objeto_cozinhando)
	_positionarObjetoNoFogao()
	fogoAnimado.show()

func _positionarObjetoNoFogao() -> void:
	objetoAtual.reparent(pivotObjeto)
	objetoAtual.global_position = pivotObjeto.global_position

func ao_transformar_objeto_cozinhando(novo_objeto: ObjetoAgarravel):
	objetoAtual = novo_objeto
