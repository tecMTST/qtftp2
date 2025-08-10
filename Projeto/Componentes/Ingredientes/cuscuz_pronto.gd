class_name CuscuzPronto extends IngredienteBase

func _ready() -> void:
	var ingredientes = Globais.ingredientes.filter(
		func(item : Ingrediente): return item.id == 5 and item.variacao == 3)
	if len(ingredientes) > 0:
		ingrediente = ingredientes[0]
		nome = ingrediente.nome
		descricao = ingrediente.descricao

func entregar():
	# Inserir animações e efeitos
	ControleDeFase.jogador.iniciar_dialogo(load("res://Dialogo/Cuscuz.dialogue"), "cuscuz_pronto", 3.5)
	await get_tree().create_timer(1).timeout
	ControleDeFase.entregar_prato(ingrediente)
	queue_free()
