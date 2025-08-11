extends CanvasLayer

@onready var modal_nivel_concluido := preload("res://UI/Interfaces/FimNivel.tscn")

func _ready() -> void:
	Eventos.evento_iniciado.connect(self._on_evento_iniciado)
	ControleDeFase.nivel_concluido.connect(nivel_concluido)

func _on_evento_iniciado(evento):
	var cena := Eventos.CENAS[evento] as PackedScene
	add_child(cena.instantiate())

func nivel_concluido(_nivel, _estado_nivel):
	add_child(modal_nivel_concluido.instantiate())
