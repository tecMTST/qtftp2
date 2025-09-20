class_name Geladeira extends BaseInteragivel

var geladeira_aberta
var _posicao_geladeira: int = 0
var player : Player

@onready var menu_geladeira = preload("res://UI/Eventos/Geladeira.tscn")
@onready var indicador: Sprite2D = $Indicador

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	nome = "Geladeira"
	ControleDeFase.nova_receita.connect(_prepara_geladeira_para_proxima_receita)


func _prepara_geladeira_para_proxima_receita(_nova_receita):
	_posicao_geladeira = 0


func _process(_delta: float) -> void:
	indicador.visible = ControleDeFase.verifica_proximo_ponto("geladeira")

func _on_componente_interagivel_interagir(jogador: Player) -> void:
	if ControleDeFase.passo_atual.alvo != "geladeira": return
	if(
		!jogador.esta_agarrando # não pode abrir geladeira segurando coisas
		and !get_tree().get_first_node_in_group("menu_geladeira") # nem com geladeira aberta
	):
		player.desativar()
		geladeira_aberta = menu_geladeira.instantiate()
		add_sibling(geladeira_aberta)
		geladeira_aberta.get_child(0).preencher_geladeira(_posicao_geladeira)
		geladeira_aberta.get_child(0).escolheu_ingrediente.connect(_incrementa_posicao_geladeira)

func _incrementa_posicao_geladeira() -> void:
	_posicao_geladeira = _posicao_geladeira + 1
