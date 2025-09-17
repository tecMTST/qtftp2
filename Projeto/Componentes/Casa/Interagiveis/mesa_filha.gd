class_name MesaFilha extends BaseInteragivel

@export var fila: Node

@onready var pivot: Node2D = $Pivot
@onready var indicador: Sprite2D = $Indicador

func _ready() -> void:
	nome = "Mesa"

func _process(_delta: float) -> void:
	indicador.visible = ControleDeFase.verifica_proximo_ponto("mesa")

func _interagir(jogador: Player) -> void:
	print_debug("to aqui na mesa da filha")
	if(
		jogador.objeto_agarrado != null
		and jogador.objeto_agarrado is IngredienteBase
		and jogador.objeto_agarrado.ingrediente.acoes[0].alvo == "mesa"
		and (!is_instance_valid(fila) or fila.remove_pessoa_da_fila())
	):
		var objeto_atual = jogador.objeto_agarrado
		jogador.soltar()
		objeto_atual.entregar()
