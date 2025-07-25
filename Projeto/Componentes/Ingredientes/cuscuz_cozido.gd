class_name CuscuzCozido extends IngredienteBase

var esta_desenformando = false

@onready var timer = $Timer
@onready var visualizador_temporal: VisualizadorTemporal = $VisualizadorTemporal

@export var tempoAteQueimar : int = 10

func _ready() -> void:
	var ingredientes = Globais.Ingredientes.filter(
		func(item : Ingrediente): return item.Id == 5 and item.Variacao == 3)
	if len(ingredientes) > 0:
		Ingrediente = ingredientes[0]
		Nome = Ingrediente.Nome
		Descricao = Ingrediente.Descricao
		timer.start(tempoAteQueimar)

func _on_timer_timeout():
	if(!esta_desenformando): #Sinal do timer de queimar inicial
		timer.paused = true
		ao_transformar.emit(null)
		queue_free()
	else: #Sinal do timer de desenformar
		transformar(load("uid://dorynrmsas25r").instantiate())
		
func cozinhar() -> bool:  #Método para remover o cuscuz antes de queimar
	visualizador_temporal.cor = Color("478cbf")
	timer.start(Ingrediente.Acoes[0].Tempo)
	timer.paused = true
	return false
	
func desenformar() -> void:
	if(!esta_desenformando):
		timer.paused = false
		esta_desenformando = true
	else:
		timer.paused = !timer.paused

func entregar():
	# Inserir animações e efeitos
	ControleDeFase.Jogador.iniciar_dialogo(load("res://Dialogo/Cuscuz.dialogue"), "cuscuz_pronto", 3.5)
	await get_tree().create_timer(1).timeout
	ControleDeFase.entregarPrato(Ingrediente)
	queue_free()
