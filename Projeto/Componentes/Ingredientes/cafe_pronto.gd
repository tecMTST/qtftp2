class_name CafePronto extends IngredienteBase

func _ready() -> void:
	var ingredientes = Globais.ingredientes.filter(
		func(item: Ingrediente): return item.id == 5 and item.variacao == 3
	)
	assert(len(ingredientes) > 0, "ingrediente não encontrado!")
	ingrediente = ingredientes[0]
	nome = ingrediente.nome
	descricao = ingrediente.descricao

func entregar():
	ControleDeFase.entregar_prato(ingrediente)
	queue_free()
