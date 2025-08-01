extends Node

@export var lista_quadrinhos : Array[Quadrinho]
@export var caminho_proxima_cena : String
@export var modo_loop : bool

var index_quadrinho_atual : int
var quadrinhos_terminados : bool = false

func _ready() -> void:
	lista_quadrinhos[lista_quadrinhos.size()-1].on_quadrinho_finalizado.connect(_quadrinhos_finalizados)
	_reiniciar_quadrinhos()

func _on_input_action_pressed() -> void:
	index_quadrinho_atual += 1

	if(index_quadrinho_atual < lista_quadrinhos.size()):
		_ativar_quadrinho(index_quadrinho_atual)
	else:
		_carregar_proxima_cena()

func _ativar_quadrinho(index : int) -> void:
	lista_quadrinhos[index].ativar_quadrinho()

func _carregar_proxima_cena() -> void:
	if(!quadrinhos_terminados): return

	if(!modo_loop):
		get_tree().change_scene_to_file(caminho_proxima_cena)
	else:
		_reiniciar_quadrinhos()

func _reiniciar_quadrinhos() -> void:
	for quadrinho in lista_quadrinhos:
		quadrinho.configurar_quadrinho()

	index_quadrinho_atual = 0
	_ativar_quadrinho(index_quadrinho_atual)

	quadrinhos_terminados = false

func _quadrinhos_finalizados() -> void:
	quadrinhos_terminados = true
