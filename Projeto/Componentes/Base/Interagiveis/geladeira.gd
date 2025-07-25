class_name Geladeira extends BaseInteragivel

@onready var menu_geladeira = preload("res://UI/Eventos/Geladeira.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Nome = "Geladeira"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_componente_interagivel_interagir(jogador: Player) -> void:
	if jogador.objeto_agarrado == null:
		var _geladeira = menu_geladeira.instantiate()
		add_sibling(_geladeira)
