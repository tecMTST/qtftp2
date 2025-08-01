extends Node

@export var listaQuadrinhos : Array[Quadrinho]
@export var caminhoProximaCena : String
@export var modoLoop : bool

var index_quadrinhoAtual : int
var quadrinhosTerminados : bool = false

func _ready() -> void:
	listaQuadrinhos[listaQuadrinhos.size()-1].OnQuadrinhoFinalizado.connect(_quadrinhosFinalizados)
	_reiniciar_quadrinhos()

func _on_input_action_pressed() -> void:
	index_quadrinhoAtual += 1
	
	if(index_quadrinhoAtual < listaQuadrinhos.size()):
		_ativar_quadrinho(index_quadrinhoAtual)
	else:
		_carregar_proxima_cena()

func _ativar_quadrinho(index : int) -> void:
	listaQuadrinhos[index].AtivarQuadrinho()

func _carregar_proxima_cena() -> void:
	if(!quadrinhosTerminados): return
	
	if(!modoLoop):
		get_tree().change_scene_to_file(caminhoProximaCena)
	else:
		_reiniciar_quadrinhos()

func _reiniciar_quadrinhos() -> void:
	for quadrinho in listaQuadrinhos:
		quadrinho.Configurar_quadrinho()
	
	index_quadrinhoAtual = 0
	_ativar_quadrinho(index_quadrinhoAtual)
	
	quadrinhosTerminados = false

func _quadrinhosFinalizados() -> void:
	quadrinhosTerminados = true
