class_name MesaFilha extends BaseInteragivel

@onready var pivot: Node2D = $Pivot

var objetoAtual : IngredienteBase = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Nome = "Mesa"

func _interagir(jogador: Player) -> void:
	if(objetoAtual == null and jogador.objetoAgarrado is IngredienteBase):
		if (jogador.objetoAgarrado.pode_entregar()):
			objetoAtual = jogador.objetoAgarrado
			jogador.soltar()
			_posicionarObjeto()
			objetoAtual.entregar()

func _posicionarObjeto() -> void:
	objetoAtual.reparent(pivot)
	objetoAtual.global_position = pivot.global_position
