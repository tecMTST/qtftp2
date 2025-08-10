class_name CozinhaSolidaria extends Node2D

@onready var botao_acao: TouchScreenButton = $BotaoAcao

func _ready() -> void:
	ControleDeFase.carregar_nivel(1)
	ControleDeFase.iniciar_nivel()

func _on_player_acao_ativada() -> void:
	botao_acao.visible = true

func _on_player_acao_desativada() -> void:
	botao_acao.visible = false
