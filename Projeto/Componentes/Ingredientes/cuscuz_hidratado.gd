class_name CuscuzHidratado extends IngredienteBase

func _ready() -> void:
	var ingredientes = Globais.Ingredientes.filter(
		func(item : Ingrediente): return item.Id == 5 and item.Variacao == 2)
	if len(ingredientes) > 0:
		Ingrediente = ingredientes[0]
		Nome = Ingrediente.Nome
		Descricao = Ingrediente.Descricao
