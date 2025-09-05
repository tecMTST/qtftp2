class_name CuscuzCozido extends IngredienteBase

@export var tempo_ate_queimar: int = 10

var esta_desenformando = false

@onready var timer = $Timer
@onready var visualizador_temporal: VisualizadorTemporal = $VisualizadorTemporal


func _ready() -> void:
	var ingredientes = Globais.ingredientes.filter(
		func(item: Ingrediente): return item.id == 5 and item.variacao == 3
	)
	assert(len(ingredientes) > 0, "ingrediente não encontrado!")
	ingrediente = ingredientes[0]
	nome = ingrediente.nome
	descricao = ingrediente.descricao
	timer.start(tempo_ate_queimar)
	ControleDeFase.indicador_proximo = "Fogão"


func _on_timer_timeout():
	if(!esta_desenformando): #Sinal do timer de queimar inicial
		timer.paused = true
		ao_transformar.emit(null)
		queue_free()
	else: #Sinal do timer de desenformar
		transformar(load("res://Componentes/Ingredientes/CuscuzCru.tscn").instantiate())


func acao_fogao() -> bool:  #Método para remover o cuscuz antes de queimar
	visualizador_temporal.cor = Color("478cbf")
	timer.start(ingrediente.acoes[0].tempo)
	timer.paused = true
	ControleDeFase.indicador_proximo = "Bancada"
	return false


func acao_bancada() -> void:
	ControleDeFase.indicador_proximo = ""
	if(!esta_desenformando):
		timer.paused = false
		esta_desenformando = true
		transformar(load("res://Componentes/Ingredientes/CuscuzPronto.tscn").instantiate())
	else:
		timer.paused = !timer.paused
