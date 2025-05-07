extends CanvasLayer

func _ready() -> void:
	Eventos.EventoIniciado.connect(self._on_evento_iniciado)

func _on_evento_iniciado(evento):
	var cena := Eventos.Cenas[evento] as PackedScene
	add_child(cena.instantiate())
