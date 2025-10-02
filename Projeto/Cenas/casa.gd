class_name Casa extends Node2D

@onready var botao_acao: TouchScreenButton = $Molduras/BotaoAcao
@onready var botao_pausa: TouchScreenButton = $Molduras/BotaoPausa
@onready var pausar: MenuPausa = $CanvasLayer/pausar
@onready var save_agent: SaveAgent = $SaveAgent
@onready var botao_fim: TouchScreenButton = $Molduras/BotaoFim
@onready var briefing: Briefing = $Briefing
@onready var transicao_cena: TransicaoCena = $TransicaoCena
@onready var player: Player = $Personagens/Player
@onready var touch_analog: TouchAnalog = $Molduras/TouchAnalog
@onready var filtro_dessaturar: CanvasLayer = $FiltroDessaturar

func _ready() -> void:
	ControleDeFase.carregar_nivel()
	ControleDeFase.iniciar_nivel()
	ControleDeFase.cena_final.connect(_fim_cena)
	SaveService.SaveGame()
	pausar.hide()
	briefing.iniciar()
	if EstadoDeJogo.nivel_atual==3 or EstadoDeJogo.nivel_atual==4 :
		filtro_dessaturar.show()
	else :
		filtro_dessaturar.hide()

func _process(_delta: float) -> void:
	touch_analog.Enabled = player.ativo

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
	ControleDeAudio.para_musica()
	ControleDeAudio.toca_efeito("vitoria")
	print_debug("<<PENDÊNCIA>> exibir 'parabéns, vc venceu' por 3 segundos")
	ControleDeFase.estado_nivel.cena_final_iniciada = true
	var tempo_ate_fade_out = Timer.new()
	add_child(tempo_ate_fade_out)
	tempo_ate_fade_out.wait_time = 3.0
	tempo_ate_fade_out.timeout.connect(_finalizar_nivel)
	tempo_ate_fade_out.start()

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

func luisa_entra() -> void:
	$Personagens/Luisa.position = $Personagens/Luisa.position.lerp(Vector2(415, 800), 0.0167 * 100)

func retorna_nivel() -> int:
	return ControleDeFase.fase_atual()
