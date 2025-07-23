extends Control

@export var qnt_na_prateleira = 3
@export var caminho_ingredientes = ""

@onready var prateleira_1 = $VBoxContainer/Prateleira
@onready var prateleira_2 = $VBoxContainer/Prateleira2
@onready var prateleira_3 = $VBoxContainer/Prateleira3
@onready var instancia_ingrediente = preload("res://Componentes/Objetos/Interagiveis/ingrediente.tscn")

var conteudo_json
var acaoExecutada = false

func _ready() -> void:
	acaoExecutada = false
	read_json()
	preencher_Geladeira()

func read_json() -> void:
	var file = FileAccess.open(caminho_ingredientes, FileAccess.READ)
	var text = file.get_as_text()
	conteudo_json = JSON.parse_string(text)
	if not conteudo_json:
		conteudo_json = []

func preencher_Geladeira():
	for i in range(conteudo_json.size()):
		var ingrediente = instancia_ingrediente.instantiate()
		var sprite_ingrediente = load(conteudo_json[i]["CaminhoSprite"])

		ingrediente.Nome = conteudo_json[i]["Nome"]
		ingrediente.Descricao = conteudo_json[i]["Descricao"]
		ingrediente.CaminhoObjeto = conteudo_json[i]["CaminhoObjeto"]
		ingrediente.Sprite = sprite_ingrediente
		ingrediente.botao_apertado.connect(func (): ingrediente_escolhido(ingrediente.CaminhoObjeto))

		var container: Node

		if i < qnt_na_prateleira:
			container = prateleira_1.get_node("IngredienteContainer")
		elif i < qnt_na_prateleira * 2:
			container = prateleira_2.get_node("IngredienteContainer")
		elif i < qnt_na_prateleira * 3:
			container = prateleira_3.get_node("IngredienteContainer")
		else:
			break  # Se tiver mais itens do que o total possível, para aqui

		container.add_child(ingrediente)
		
func close() -> void:
	GuiTransitions.hide("Geladeira")
	await GuiTransitions.hide_completed
	visible = false
	queue_free()

func _on_button_button_up() -> void:
	Eventos.EventoFalhou.emit()
	close()

func ingrediente_escolhido(caminho: String) -> void:
	var caminho_objeto = load(caminho)
	var objeto = caminho_objeto.instantiate()
	var player = get_tree().get_nodes_in_group("player")
	
	if player and not acaoExecutada:
		acaoExecutada = true
		close()
		player[0].PosicaoObjeto.add_sibling(objeto)
		player[0].agarrar_de_menu(objeto)
	
		
