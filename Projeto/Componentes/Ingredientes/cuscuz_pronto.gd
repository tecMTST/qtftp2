class_name CuscuzPronto extends IngredienteBase

func _ready() -> void:
	var ingredientes = Globais.Ingredientes.filter(
		func(item : Ingrediente): return item.Id == 5 and item.Variacao == 3)
	if len(ingredientes) > 0:
		Ingrediente = ingredientes[0]
		Nome = Ingrediente.Nome
		Descricao = Ingrediente.Descricao

func entregar():
	# Inserir animações e efeitos
	ControleDeFase.Jogador.iniciar_dialogo(load("res://Dialogo/Cuscuz.dialogue"), "cuscuz_pronto", 3.5)
	await get_tree().create_timer(1).timeout
	ControleDeFase.entregarPrato(Ingrediente)
	queue_free()
