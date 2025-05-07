extends Control

func _ready() -> void:
	if %ProgressoEvento.running: return
	%ProgressoEvento.failed.connect(_on_failed)
	%ProgressoEvento.completed.connect(_on_completed)
	%ProgressoEvento.start()
	
func close() -> void:
	GuiTransitions.hide("Modal")
	await GuiTransitions.hide_completed
	queue_free()

func _on_close_button_button_down() -> void:
	Eventos.EventoFalhou.emit()
	close()

func _on_failed():
	Eventos.EventoFalhou.emit()
	var tween = create_tween()
	tween.tween_property(self,"modulate", Color.INDIAN_RED, 2)
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.play()
	await tween.finished
	close()

func _on_completed():
	Eventos.EventoRealizado.emit()
	var tween = create_tween()
	tween.tween_property(self,"modulate", Color.LIME_GREEN, 2)
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.play()
	await tween.finished
	close()
