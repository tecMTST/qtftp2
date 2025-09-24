class_name Nivel extends Node

var id : int
var nome : String
var descricao : String
var textos : Array[String]
var dialogos: String
var condicoes_dialogo: Array[CondicaoDialogo]
var imagem : String
var local : String
var caminhos_briefing: Array[CaminhoBriefing]
var tempo : int
var limite_bagunca : int
var id_receitas : Array[int] = []
var ordem_aleatoria: bool = true
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
