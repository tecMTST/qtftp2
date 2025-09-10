class_name MesaFilha extends BaseInteragivel

var objeto_atual : IngredienteBase = null

@onready var pivot: Node2D = $Pivot
@onready var indicador: Sprite2D = $Indicador

func _ready() -> void:
	nome = "Mesa"

func _process(_delta: float) -> void:
	indicador.visible = ControleDeFase.verifica_proximo_ponto("Mesa")

func _interagir(jogador: Player) -> void:
	if(objeto_atual == null and jogador.objeto_agarrado != null and jogador.objeto_agarrado is IngredienteBase):
		if (jogador.objeto_agarrado.pode_entregar()):
			objeto_atual = jogador.objeto_agarrado
			jogador.soltar()
			_posicionar_objeto()
			objeto_atual.entregar()

func _posicionar_objeto() -> void:
	objeto_atual.reparent(pivot)
	objeto_atual.global_position = pivot.global_position
