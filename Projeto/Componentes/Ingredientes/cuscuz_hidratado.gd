class_name CuscuzHidratado extends IngredienteBase

var esta_pronto_para_cozinhar := false
var esta_cozinhando = false

@onready var timer = $Timer
@onready var visualizador_temporal: VisualizadorTemporal = $VisualizadorTemporal

func _ready() -> void:
	var ingredientes = Globais.ingredientes.filter(
		func(item: Ingrediente): return item.id == 5 and item.variacao == 2
	)
	assert(len(ingredientes) > 0, "ingrediente não encontrado!")
	ingrediente = ingredientes[0]
	nome = ingrediente.nome
	descricao = ingrediente.descricao
	timer.start(ingrediente.acoes[0].tempo)
	ControleDeFase.indicador_proximo = ""


func _on_timer_timeout():
	if(!esta_pronto_para_cozinhar):
		esta_pronto_para_cozinhar= true
		timer.paused = true
		visualizador_temporal.cor = Color("47dc00")
		ControleDeFase.indicador_proximo = "Fogão"
	elif(esta_cozinhando):
		transformar(load("res://Componentes/Ingredientes/CuscuzCozido.tscn").instantiate())

func acao_fogao() -> bool:
	ControleDeFase.indicador_proximo = ""
	if(!esta_pronto_para_cozinhar): return false
	if(!esta_cozinhando):
		timer.paused = false
		timer.start(ingrediente.acoes[0].tempo)
		esta_cozinhando = true
	else:
		timer.paused = !timer.paused
	return true
