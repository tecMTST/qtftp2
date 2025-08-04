extends Control

signal IngredienteEscolhido(caminho)

@export var qnt_na_prateleira = 3
@export var caminho_ingredientes = ""

@onready var prateleira_1 = $VBoxContainer/Prateleira
@onready var prateleira_2 = $VBoxContainer/Prateleira2
@onready var prateleira_3 = $VBoxContainer/Prateleira3
@onready var instancia_ingrediente = preload("res://Componentes/Ingredientes/ingrediente.tscn")

var conteudo_json
var acaoExecutada = false

func _ready() -> void:
	acaoExecutada = false
	preencher_Geladeira()

func preencher_Geladeira():
	if not ControleDeFase.NivelAtual or not ControleDeFase.ReceitaSelecionada:
		close()
		
	var i : int = 0	
	for ingredienteReceita in ControleDeFase.ReceitaSelecionada.Ingredientes:
		var ingrediente = Globais.GetIngrediente(ingredienteReceita.IdIngrediente, ingredienteReceita.VariacaoIngrediente)		
		var sprite_ingrediente = load(ingrediente.CaminhoSprite)
	
		var igredienteGeladeira = load("res://Componentes/Ingredientes/ingrediente.tscn").instantiate() as ObjIngrediente		
		igredienteGeladeira.Nome = ingrediente.Nome
		igredienteGeladeira.Descricao = ingrediente.Descricao
		igredienteGeladeira.Sprite = sprite_ingrediente
		igredienteGeladeira.CaminhoObjeto = ingrediente.Cena	
		igredienteGeladeira.botao_apertado.connect(ingrediente_escolhido)
		
		var container: Node

		if i < qnt_na_prateleira:
			container = prateleira_1.get_node("IngredienteContainer")
		elif i < qnt_na_prateleira * 2:
			container = prateleira_2.get_node("IngredienteContainer")
		elif i < qnt_na_prateleira * 3:
			container = prateleira_3.get_node("IngredienteContainer")
		else:
			break  # Se tiver mais itens do que o total possível, para aqui

		container.add_child(igredienteGeladeira)
		
		i += 1
		
func close() -> void:
	GuiTransitions.hide("Geladeira")
	await GuiTransitions.hide_completed
	queue_free()

func ingrediente_escolhido(caminho: String) -> void:
	IngredienteEscolhido.emit(caminho)
	var caminho_objeto = load(caminho)
	var objeto = caminho_objeto.instantiate()
	var player = get_tree().get_nodes_in_group("player")	
	if player and not acaoExecutada:
		acaoExecutada = true
		player[0].agarrar_de_menu(objeto)
		close()

func _on_button_pressed() -> void:
	close()
