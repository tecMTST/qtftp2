extends Node

var receitas : Array[Receita]
var ingredientes : Array[Ingrediente]
var pratos : Array[Prato]
var aprimoramentos : Array[Aprimoramento]
var niveis : Array[Nivel]


func _ready():
	carregar_dados()


func carregar_dados():
	var json_ingredientes = _carrega_json("res://Dados/Receitas/Ingredientes.json")
	var json_receitas = _carrega_json("res://Dados/Receitas/Receitas.json")
	var json_pratos = _carrega_json("res://Dados/Receitas/Pratos.json")
	var json_niveis = _carrega_json("res://Dados/Niveis/Niveis.json")
	var json_aprimoramentos = _carrega_json("res://Dados/Niveis/Aprimoramentos.json")
	ingredientes = []
	for item in json_ingredientes:
		ingredientes.append(JsonClassConverter.json_to_class(Ingrediente, item))
	receitas = []
	for item in json_receitas:
		receitas.append(JsonClassConverter.json_to_class(Receita, item))
	pratos = []
	for item in json_pratos:
		pratos.append(JsonClassConverter.json_to_class(Prato, item))
	niveis = []
	for item in json_niveis:
		niveis.append(JsonClassConverter.json_to_class(Nivel, item))
	aprimoramentos = []
	for item in json_aprimoramentos:
		aprimoramentos.append(JsonClassConverter.json_to_class(Aprimoramento, item))


func get_ingrediente(id : int, variacao : int) -> Ingrediente:
	var encontrados = ingredientes.filter(
		func(item: Ingrediente): return item.id == id and item.variacao == variacao)
	if len(encontrados) > 0:
		return encontrados[0]
	return null

func _carrega_json(nome_arquivo: String) -> Array:
	return JSON.parse_string(FileAccess.get_file_as_string(nome_arquivo))
