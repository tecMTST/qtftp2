class_name CuscuzHidratado extends IngredienteBase

var esta_pronto_para_cozinhar := false

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
	esta_pronto_para_cozinhar= true
	timer.paused = true
	visualizador_temporal.cor = Color("47dc00")
