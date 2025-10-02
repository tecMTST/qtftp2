extends Control

var player: Player

@onready var receita: Label = $MarginContainer/PanelContainer/VBoxContainer/Receita
@onready var imagem_evento: TextureRect = %ImagemEvento

func _ready() -> void:
	receita.text="Nome Receita"
	if(is_instance_valid(ControleDeFase.receita_selecionada)):
		receita.text=ControleDeFase.receita_selecionada.nome
	var receita_match: String= "Picar a salsicha"
	if(is_instance_valid(ControleDeFase.passo_atual)):
		receita_match = ControleDeFase.passo_atual.descricao
	match receita_match:
		"Colocar feijão no fogo":
			imagem_evento.texture=load("res://Recursos/Graficos/UI/Ingredientes/feijao2.svg")
	if %ProgressoEvento.running: return
	%ProgressoEvento.failed.connect(_on_failed)
	%ProgressoEvento.completed.connect(_on_completed)
	%ProgressoEvento.start()
	player=get_tree().get_first_node_in_group("player")
	player.desativar()


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
	close()


func _on_completed():
	Eventos.evento_realizado.emit()
	close()


func _on_spin_button_giro_completo(_contador: int) -> void:
	%ProgressoEvento.do_act()


func _exit_tree() -> void:
	player.ativar()
