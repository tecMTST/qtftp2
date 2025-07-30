extends Node

@export var listaQuadrinhos : Array[Quadrinho]
@export var guidProximaCena : String

var index_quadrinhoAtual : int

func _ready() -> void:
	for quadrinho in listaQuadrinhos:
		quadrinho.Configurar_quadrinho()
		
	index_quadrinhoAtual = -1
	#_ativar_quadrinho(index_quadrinhoAtual)

func _on_input_action_pressed() -> void:
	index_quadrinhoAtual += 1
	
	if(index_quadrinhoAtual < listaQuadrinhos.size()):
		_ativar_quadrinho(index_quadrinhoAtual)
	else:
		_carregar_proxima_cena()

func _ativar_quadrinho(index : int) -> void:
	listaQuadrinhos[index].AtivarQuadrinho()

func _carregar_proxima_cena() -> void:
	print("CARREGANDO PROXIMA CENA")
	pass
