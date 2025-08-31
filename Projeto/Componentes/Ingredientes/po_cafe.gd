class_name PoCafe extends IngredienteBase

var esta_cozinhando = false

@onready var timer = $Timer


func _ready() -> void:
	var ingredientes = Globais.ingredientes.filter(
		func(item: Ingrediente): return item.id == 6 and item.variacao == 1
	)
	assert(len(ingredientes) > 0, "ingrediente não encontrado!")
	ingrediente = ingredientes[0]
	nome = ingrediente.nome
	descricao = ingrediente.descricao
	timer.start(ingrediente.acoes[0].tempo)


func _on_timer_timeout():
	if(esta_cozinhando):
		transformar(load("res://Componentes/Ingredientes/CafeCoado.tscn").instantiate())


func acao_fogao() -> bool:
	if(!esta_cozinhando):
		timer.paused = false
		timer.start(ingrediente.acoes[0].tempo)
		esta_cozinhando = true
	else:
		timer.paused = !timer.paused
	return true
