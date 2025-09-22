class_name CozinhaSolidaria extends Node2D

@onready var botao_acao: TouchScreenButton = $Molduras/BotaoAcao
@onready var botao_pausa: TouchScreenButton = $Molduras/BotaoPausa
@onready var pausar: MenuPausa = $CanvasLayer/pausar
@onready var save_agent: SaveAgent = $SaveAgent
@onready var botao_fim: TouchScreenButton = $BotaoFim
@onready var briefing: Briefing = $Briefing
@onready var transicao_cena: TransicaoCena = $TransicaoCena


func _ready() -> void:
	ControleDeFase.carregar_nivel()
	ControleDeFase.iniciar_nivel()
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
	ControleDeFase.travar_dialogos = true
	pausar.atualizar()
	pausar.show()

func _on_pausar_continuar() -> void:
	botao_pausa.visible = true
	ControleDeFase.travar_dialogos = false

func _fim_cena(_nivel, _estado_nivel):
	ControleDeFase.congelar_tempo()
	ControleDeFase.estado_nivel.cena_final_iniciada = true

func _finalizar_nivel():
	transicao_cena.escurecer()
	await transicao_cena.finalizou
	ControleDeFase.estado_nivel.cena_final_concluida = true

func _on_briefing_iniciado() -> void:
	ControleDeFase.congelar_tempo()

func _on_briefing_finalizado() -> void:
	ControleDeFase.descongelar_tempo()
	ControleDeAudio.toca_musica_com_intro(
		"casa_intro", "casa_loop",
		ControleDeFase.nivel_atual.tempo != ControleDeFase.TEMPO_INFINITO
	)

func _mostrar_botao_fim():
	botao_fim.visible = true

func _on_botao_fim_pressed() -> void:
	_finalizar_nivel()

func retorna_nivel() -> int:
	return ControleDeFase.fase_atual()
