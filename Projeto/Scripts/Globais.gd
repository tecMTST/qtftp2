extends Node

var receitas : Array[Receita]
var ingredientes : Array[Ingrediente]
var niveis : Array[Nivel]

func _ready():
	carregar_dados()


func carregar_dados():
	var json_ingredientes = _carrega_json("res://Dados/Receitas/Ingredientes.json")
	var json_receitas = _carrega_json("res://Dados/Receitas/Receitas.json")
	var json_niveis = _carrega_json("res://Dados/Niveis/Niveis.json")
	ingredientes = []
	for item in json_ingredientes:
		ingredientes.append(JsonClassConverter.json_to_class(Ingrediente, item))
	receitas = []
	for item in json_receitas:
		receitas.append(JsonClassConverter.json_to_class(Receita, item))
	niveis = []
	for item in json_niveis:
		niveis.append(JsonClassConverter.json_to_class(Nivel, item))

func obtem_ingrediente(id_ingrediente: String) -> Ingrediente:
	var encontrados = ingredientes.filter(
		func(item: Ingrediente): return item.id == id_ingrediente
	)
	assert(len(encontrados) > 0, "ingrediente " + id_ingrediente + " não encontrado!")
	return encontrados[0]


func _carrega_json(nome_arquivo: String) -> Array:
	return JSON.parse_string(FileAccess.get_file_as_string(nome_arquivo))
