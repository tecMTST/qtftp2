class_name Nivel extends Node

var id : int
var nome : String
var descricao : String
var textos : Array[String]
var imagem : String
var local : String
var tempo : int
var limite_bagunca : int
var id_receitas : Array[int] = []
var quantidade_pratos_real : int
var quantidade_pratos_exibido : int
var valor_nutricional_minimo : int
var valor_sabor_minimo : int
var pontos_recompensa : int
var receita_recompensa : int
var bagunca : bool = false
var intervalo_bagunca : float = 30
var variacao_bagunca : float = 5
var choro : bool = false
var intervalo_choro : float = 20
var variacao_choro : float = 5
var tempo_limite_choro : float = 20.0
