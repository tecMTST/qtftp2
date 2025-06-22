class_name Fogao extends BaseInteragivel

@export var pivotObjeto : Node2D
var objetoAtual : ObjetoAgarravel = null


# Called when the node enters the scene tree for the first time.
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
	_positionarObjetoNoFogao(false)
	objetoAtual.cozinhar()
	objetoAtual = null

func _cozinharObjeto(objeto : ObjetoAgarravel) -> void:
	objetoAtual = objeto
	objetoAtual.ao_transformar.connect(ao_transformar_objeto_cozinhando)
	_positionarObjetoNoFogao(true)

func _positionarObjetoNoFogao(posicionar : bool) -> void:
	if(posicionar):
		objetoAtual.reparent(pivotObjeto)
		objetoAtual.global_position = pivotObjeto.global_position
		print("posicionando no pivot")
	else:
		#objetoAtual.reparent(get_parent())
		#objetoAtual.global_position = pivotObjeto.global_position
		pass

func ao_transformar_objeto_cozinhando(novo_objeto: ObjetoAgarravel):
	objetoAtual = novo_objeto
