class_name Casa extends Node2D

@onready var botao_acao: TouchScreenButton = $BotaoAcao
@onready var botao_pausa: TouchScreenButton = $BotaoPausa
@onready var pausar: MenuPausa = $CanvasLayer/pausar
@onready var save_agent: SaveAgent = $SaveAgent
@onready var bt_player: BTPlayer = $BTPlayer


func _ready() -> void:
	ControleDeFase.carregar_nivel()
	ControleDeFase.iniciar_nivel()
	ControleDeAudio.toca_musica_com_intro("casa_intro", "casa_loop")
	ControleDeFase.prato_entregue.connect(_prato_entregue)
	ControleDeFase.nivel_concluido.connect(_fim_cena)
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


func _on_pausar_continuar() -> void:
	botao_pausa.visible = true


func abrir_dialogo(estado_fase: int, linha_dialogo: String) -> int:
	ControleDeFase.jogador.iniciar_dialogo(load("res://Dialogo/Fase00.dialogue"), linha_dialogo)
	return estado_fase + 1


func _on_player_acao_agarrou(_objeto: Variant) -> void:
	if bt_player.blackboard.get_var('estado_fase') == 1:
		bt_player.blackboard.set_var('estado_fase', 2)


func _prato_entregue(_prato):
	if ControleDeFase.estado_nivel.pratos_entregues.size() != 2:
		return
	if bt_player.blackboard.get_var('estado_fase') == 3:
		bt_player.blackboard.set_var('estado_fase', 4)


func _fim_cena(_nivel, _estado_nivel):
	bt_player.blackboard.set_var('estado_fase', 6)
