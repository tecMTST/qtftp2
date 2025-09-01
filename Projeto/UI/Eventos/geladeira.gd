extends Control

signal ingrediente_escolhido(caminho)

@export var qnt_na_prateleira = 3
@export var caminho_ingredientes = ""

var conteudo_json
var acao_executada = false

@onready var prateleira_1 = $VBoxContainer/Prateleira
@onready var prateleira_2 = $VBoxContainer/Prateleira2
@onready var prateleira_3 = $VBoxContainer/Prateleira3
@onready var instancia_ingrediente = preload("res://Componentes/Ingredientes/ingrediente.tscn")


func _ready() -> void:
	acao_executada = false
	preencher_geladeira()


func preencher_geladeira():
	if not ControleDeFase.nivel_atual or not ControleDeFase.receita_selecionada:
		close()
	if ControleDeFase.nivel_atual.id != 3:
		var i : int = 0
		for ingrediente_receita in ControleDeFase.receita_selecionada.ingredientes:
			var ingrediente = Globais.get_ingrediente(
				ingrediente_receita.id_ingrediente,
				ingrediente_receita.variacao_ingrediente
			)
			var sprite_ingrediente = load(ingrediente.caminho_sprite)

			var igrediente_geladeira = instancia_ingrediente.instantiate() as ObjIngrediente
			igrediente_geladeira.nome = ingrediente.nome
			igrediente_geladeira.descricao = ingrediente.descricao
			igrediente_geladeira.sprite = sprite_ingrediente
			igrediente_geladeira.caminho_objeto = ingrediente.cena
			igrediente_geladeira.botao_apertado.connect(escolhe_ingrediente)

			var container: Node

			if i < qnt_na_prateleira:
				container = prateleira_1.get_node("IngredienteContainer")
			elif i < qnt_na_prateleira * 2:
				container = prateleira_2.get_node("IngredienteContainer")
			elif i < qnt_na_prateleira * 3:
				container = prateleira_3.get_node("IngredienteContainer")
			else:
				break  # Se tiver mais itens do que o total possível, para aqui
			container.add_child(igrediente_geladeira)
			i += 1


func close() -> void:
	GuiTransitions.hide("Geladeira")
	await GuiTransitions.hide_completed
	get_parent().queue_free()
	if ControleDeFase.nivel_atual.id == 3:
		ControleDeFase.jogador.iniciar_dialogo(load("res://Dialogo/Fase03.dialogue"),"geladeiravazia", 3.0)


func escolhe_ingrediente(caminho: String) -> void:
	ingrediente_escolhido.emit(caminho)
	var caminho_objeto = load(caminho)
	var objeto = caminho_objeto.instantiate()
	var player = get_tree().get_nodes_in_group("player")
	if player and not acao_executada:
		acao_executada = true
		player[0].agarrar_de_menu(objeto)
		close()


func _on_button_pressed() -> void:
	close()
