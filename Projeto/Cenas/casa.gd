class_name Casa extends Node2D

@onready var botao_acao: TouchScreenButton = $BotaoAcao
@onready var botao_pausa: TouchScreenButton = $BotaoPausa
@onready var pausar: MenuPausa = $CanvasLayer/pausar
@onready var save_agent: SaveAgent = $SaveAgent

func _ready() -> void:	
	ControleDeFase.CarregarNivel()
	ControleDeFase.IniciarNivel()
	ControleDeAudio.toca_musica_com_intro("casa_intro", "casa_loop")
	pausar.hide()
	save_agent.SaveSceneData()
	
func _on_player_acao_ativada() -> void:
	botao_acao.visible = true

func _on_player_acao_desativada() -> void:
	botao_acao.visible = false

#essa função pausa o jogo ao pressionar o botão
func _on_botao_pausa_pressed() -> void:
	get_tree().paused = true
	botao_pausa.visible = false
	pausar.show()

func _on_pausar_continue() -> void:
	botao_pausa.visible = true
