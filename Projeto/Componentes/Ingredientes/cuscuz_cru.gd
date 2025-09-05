class_name CuscuzCru extends IngredienteBase

func _ready() -> void:
	var ingredientes = Globais.ingredientes.filter(
		func(item: Ingrediente): return item.id == 5 and item.variacao == 1
	)
	assert(len(ingredientes) > 0, "ingrediente não encontrado!")
	ingrediente = ingredientes[0]
	nome = ingrediente.nome
	descricao = ingrediente.descricao
	ControleDeFase.indicador_proximo = "Pia"


func acao_pia():
	transformar(load("res://Componentes/Ingredientes/CuscuzHidratado.tscn").instantiate())
	ControleDeFase.jogador.iniciar_dialogo(
		load("res://Dialogo/Cuscuz.dialogue"),
		"cuscuz_descansar",
		3.0
	)
