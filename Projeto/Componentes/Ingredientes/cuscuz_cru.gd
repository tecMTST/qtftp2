class_name CuscuzCru extends IngredienteBase

func _ready() -> void:
	var ingredientes = Globais.Ingredientes.filter(
		func(item : Ingrediente): return item.Id == 5 and item.Variacao == 1)
	if len(ingredientes) > 0:
		Ingrediente = ingredientes[0]
		Nome = Ingrediente.Nome
		Descricao = Ingrediente.Descricao

func enxaguar():
	transformar(load("res://Componentes/Ingredientes/CuscuzHidratado.tscn").instantiate())
	ControleDeFase.Jogador.iniciar_dialogo(load("res://Dialogo/Cuscuz.dialogue"), "cuscuz_descansar", 3.0)
