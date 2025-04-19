extends Node

var Receitas : Array[Receita]
var Ingredientes : Array[Ingrediente]
var Pratos : Array[Prato]
var Aprimoramentos : Array[Aprimoramento]
var Niveis : Array[Nivel]

func _ready():
	CarregarDados()
	
func CarregarDados():
	var jsonIngredientes = JSON.parse_string(FileAccess.get_file_as_string("res://Dados/Receitas/Ingredientes.json"))
	var jsonReceitas = JSON.parse_string(FileAccess.get_file_as_string("res://Dados/Receitas/Receitas.json"))
	var jsonPratos = JSON.parse_string(FileAccess.get_file_as_string("res://Dados/Receitas/Pratos.json"))
	var jsonNiveis = JSON.parse_string(FileAccess.get_file_as_string("res://Dados/Niveis/Niveis.json"))
	var jsonAprimoramentos = JSON.parse_string(FileAccess.get_file_as_string("res://Dados/Niveis/Aprimoramentos.json"))
	Ingredientes = []
	for item in jsonIngredientes:
		Ingredientes.append(JsonClassConverter.json_to_class(Ingrediente, item))
	Receitas = []
	for item in jsonReceitas:
		Receitas.append(JsonClassConverter.json_to_class(Receita, item))
	Pratos = []
	for item in jsonPratos:
		Pratos.append(JsonClassConverter.json_to_class(Prato, item))
	Niveis = []
	for item in jsonNiveis:
		Niveis.append(JsonClassConverter.json_to_class(Nivel, item))
	Aprimoramentos = []
	for item in jsonAprimoramentos:
		Aprimoramentos.append(JsonClassConverter.json_to_class(Aprimoramento, item))
