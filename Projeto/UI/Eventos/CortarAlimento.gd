extends Control

@onready var receita: Label = $MarginContainer/PanelContainer/VBoxContainer/Receita
@onready var imagem_evento: TextureRect = %ImagemEvento




func _ready() -> void:
	receita.text="Nome Receita"
	if(is_instance_valid(ControleDeFase.receita_selecionada)):
		receita.text="
		" + ControleDeFase.receita_selecionada.nome
	var receita_match: String= "Picar a salsicha"
	if(is_instance_valid(ControleDeFase.passo_atual)):
		receita_match = ControleDeFase.passo_atual.descricao
	match receita_match:
		"Picar cebola e alho na bancada":
			imagem_evento.texture=load("res://Recursos/Graficos/UI/Ingredientes/cebola_alho.svg")
		"Picar a salsicha":
			imagem_evento.texture=load("res://Recursos/Graficos/UI/Ingredientes/salsicha_cozida.svg")
		"Picar a carne":
			imagem_evento.texture=load("res://Recursos/Graficos/UI/Ingredientes/acem.svg")
		"Picar a couve na bancada":
			imagem_evento.texture=load("res://Recursos/Graficos/UI/Ingredientes/maco_couve.svg")
	if %ProgressoEvento.running: return
	%ProgressoEvento.failed.connect(_on_failed)
	%ProgressoEvento.completed.connect(_on_completed)
	%ProgressoEvento.start()


func close() -> void:
	GuiTransitions.hide("Modal")
	await GuiTransitions.hide_completed
	get_tree().paused = false
	queue_free()


func _on_close_button_button_down() -> void:
	Eventos.evento_falhou.emit()
	close()


func _on_cortou_alimento() -> void:
	ControleDeAudio.toca_efeito("cortar")

func _on_failed():
	Eventos.evento_falhou.emit()
	var tween = create_tween()
	tween.tween_property(self,"modulate", Color.INDIAN_RED, 2)
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.play()
	await tween.finished
	close()


func _on_completed():
	Eventos.evento_realizado.emit()
	var tween = create_tween()
	tween.tween_property(self,"modulate", Color.LIME_GREEN, 2)
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.play()
	await tween.finished
	close()
