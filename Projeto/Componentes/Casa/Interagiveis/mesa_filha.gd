class_name MesaFilha extends BaseInteragivel

var objeto_atual : IngredienteBase = null

@onready var pivot: Node2D = $Pivot


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	nome = "Mesa"
	acao = "Servir"


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
