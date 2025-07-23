class_name Casa extends Node2D

@onready var botao_acao: TouchScreenButton = $BotaoAcao
@onready var botao_pausa: TouchScreenButton = $BotaoPausa
@onready var menu_pausa: CanvasLayer = $CanvasLayer

func _ready() -> void:
	ControleDeFase.CarregarNivel(1)
	ControleDeFase.IniciarNivel()
	ControleDeAudio.toca_musica_com_intro("casa_intro", "casa_loop")
	menu_pausa.hide()
	
func _on_player_acao_ativada() -> void:
	botao_acao.visible = true

func _on_player_acao_desativada() -> void:
	botao_acao.visible = false

#essa função pausa o jogo ao pressionar o botão
func _on_botao_pausa_pressed() -> void:
	get_tree().paused = true
	menu_pausa.show()
#essa função despausa o jogo
func _on_continuar_pressed() -> void:
	get_tree().paused = false
	menu_pausa.hide()
#sai do jogo desde o menu de pausa
func _on_sair_pressed() -> void:
	get_tree().quit()
#vai para a tela principal desde o menu de pausa
func _on_retornar_à_tela_inicial_pressed() -> void:
	get_tree().change_scene_to_file("res://TelaInicial/menu_principal.tscn")
