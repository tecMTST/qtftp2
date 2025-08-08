extends CanvasLayer

@onready var modal_nivel_concluido := preload("res://UI/Interfaces/FimNivel.tscn")

func _ready() -> void:
	Eventos.EventoIniciado.connect(self._on_evento_iniciado)
	ControleDeFase.NivelConcluido.connect(nivel_concluido)

func _on_evento_iniciado(evento):
	var cena := Eventos.Cenas[evento] as PackedScene
	add_child(cena.instantiate())

func nivel_concluido(nivel, estado_nivel):
	add_child(modal_nivel_concluido.instantiate())
	pass
