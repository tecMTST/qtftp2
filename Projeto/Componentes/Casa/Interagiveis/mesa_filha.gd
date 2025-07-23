class_name MesaFilha extends BaseInteragivel

@onready var pivot: Node2D = $Pivot

var objetoAtual : IngredienteBase = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Nome = "Mesa"

func _interagir(jogador: Player) -> void:
	if(objetoAtual == null and jogador.objeto_agarrado is IngredienteBase):
		if (jogador.objeto_agarrado.pode_entregar()):
			objetoAtual = jogador.objeto_agarrado
			jogador.soltar()
			_posicionarObjeto()
			objetoAtual.entregar()

func _posicionarObjeto() -> void:
	objetoAtual.reparent(pivot)
	objetoAtual.global_position = pivot.global_position
