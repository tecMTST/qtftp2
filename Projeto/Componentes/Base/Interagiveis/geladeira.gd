class_name Geladeira extends BaseInteragivel

var geladeira_aberta

@onready var menu_geladeira = preload("res://UI/Eventos/Geladeira.tscn")

@onready var indicador: Sprite2D = $Indicador

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	nome = "Geladeira"

func _process(_delta: float) -> void:
	indicador.visible = ControleDeFase.verifica_proximo_ponto("Geladeira")

func _on_componente_interagivel_interagir(jogador: Player) -> void:
	if jogador.objeto_agarrado == null and (!geladeira_aberta || !is_instance_valid(geladeira_aberta)):
		geladeira_aberta = menu_geladeira.instantiate()
		add_sibling(geladeira_aberta)
