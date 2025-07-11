class_name Casa extends Node2D

@onready var botao_acao: TouchScreenButton = $BotaoAcao

func _ready() -> void:
	ControleDeFase.CarregarNivel(1)
	ControleDeFase.IniciarNivel()
	ControleDeAudio.toca_musica_com_intro("casa_intro", "casa_loop")

func _on_player_acao_ativada() -> void:
	botao_acao.visible = true

func _on_player_acao_desativada() -> void:
	botao_acao.visible = false
