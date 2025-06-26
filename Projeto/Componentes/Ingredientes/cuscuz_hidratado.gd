class_name CuscuzHidratado extends IngredienteBase

var esta_pronto_para_cozinhar := false
var esta_cozinhando = false

@onready var timer = $Timer
@onready var visualizador_temporal: VisualizadorTemporal = $VisualizadorTemporal

func _ready() -> void:
	var ingredientes = Globais.Ingredientes.filter(
		func(item : Ingrediente): return item.Id == 5 and item.Variacao == 2)
	if len(ingredientes) > 0:
		Ingrediente = ingredientes[0]
		Nome = Ingrediente.Nome
		Descricao = Ingrediente.Descricao
		timer.start(Ingrediente.Acoes[0].Tempo)

func _on_timer_timeout():
	if(!esta_pronto_para_cozinhar):
		esta_pronto_para_cozinhar= true
		timer.paused = true
		visualizador_temporal.cor = Color("47dc00")
	elif(esta_cozinhando):
		transformar(load("uid://jvc15grkq4fr").instantiate())
		
func cozinhar() -> bool:
	if(!esta_pronto_para_cozinhar): return false
	if(!esta_cozinhando):
		timer.paused = false
		timer.start(Ingrediente.Acoes[0].Tempo)
		esta_cozinhando = true
	else:
		timer.paused = !timer.paused
	return true
