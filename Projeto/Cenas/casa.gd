class_name Casa extends Node2D

var travar_dialogos = true

@onready var botao_acao: TouchScreenButton = $Molduras/BotaoAcao
@onready var botao_pausa: TouchScreenButton = $Molduras/BotaoPausa
@onready var pausar: MenuPausa = $CanvasLayer/pausar
@onready var save_agent: SaveAgent = $SaveAgent
@onready var bt_player: BTPlayer = $BTPlayer
@onready var botao_fim: TouchScreenButton = $Molduras/BotaoFim
@onready var briefing: Briefing = $Briefing

func _ready() -> void:
	ControleDeFase.carregar_nivel()
	ControleDeFase.iniciar_nivel()
	ControleDeFase.prato_entregue.connect(_prato_entregue)
	ControleDeFase.cena_final.connect(_fim_cena)
	SaveService.SaveGame()
	pausar.hide()
	briefing.iniciar()

func _on_player_acao_ativada() -> void:
	botao_acao.visible = true

func _on_player_acao_desativada() -> void:
	botao_acao.visible = false

#essa função pausa o jogo ao pressionar o botão
func _on_botao_pausa_pressed() -> void:
	get_tree().paused = true
	botao_pausa.visible = false
	travar_dialogos = true
	pausar.show()

func _on_pausar_continuar() -> void:
	botao_pausa.visible = true
	travar_dialogos = false

func abrir_dialogo(fase: String, estado_fase: int, linha_dialogo: String) -> int:
	if travar_dialogos:
		return estado_fase
	ControleDeFase.jogador.iniciar_dialogo(load("res://Dialogo/"+ fase +".dialogue"), linha_dialogo)
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
	ControleDeFase.congelar_tempo()
	ControleDeFase.estado_nivel.cena_final_iniciada = true
	bt_player.blackboard.set_var('estado_fase', 6)

func _finalizar_nivel():
	ControleDeFase.estado_nivel.cena_final_concluida = true

func _on_briefing_iniciado() -> void:
	ControleDeFase.congelar_tempo()
	travar_dialogos = true

func _on_briefing_finalizado() -> void:
	ControleDeFase.descongelar_tempo()
	ControleDeAudio.toca_musica_com_intro(
		"casa_intro", "casa_loop",
		ControleDeFase.nivel_atual.tempo != ControleDeFase.TEMPO_INFINITO
	)
	travar_dialogos = false

func _mostrar_botao_fim():
	botao_fim.visible = true

func _on_botao_fim_pressed() -> void:
	_finalizar_nivel()

func luisa_entra() -> void:
	$Personagens/Luisa.position = $Personagens/Luisa.position.lerp(Vector2(415, 800), 0.0167 * 100)

func retorna_nivel() -> int:
	return ControleDeFase.fase_atual()
