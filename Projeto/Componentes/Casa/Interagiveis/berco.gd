class_name Berco extends BaseInteragivel

var timer_choro: float = 0
var iniciado: bool = false
var choro_ativo: bool = false

@onready var bebe: AnimatedSprite2D = $Bebe
@onready var timer: Timer = $Timer
@onready var visualizador_temporal: VisualizadorTemporal = $VisualizadorTemporal


func _ready() -> void:
	nome = "Berço"
	if not ControleDeFase.nivel_atual or not ControleDeFase.nivel_atual.choro:
		return
	resetar_timer()
	iniciado = true


func _process(delta: float) -> void:
	if not ControleDeFase.nivel_atual or not ControleDeFase.nivel_atual.choro:
		return
	if not iniciado:
		iniciado = true
		resetar_timer()
		return
	if choro_ativo:
		return
	timer_choro -= delta
	if timer_choro <= 0:
		iniciar_choro()


func iniciar_mexer():
	bebe.frame = 1
	print_debug('mechendo')


func animacao_choro():
	bebe.frame = 2
	print_debug('choro')


func iniciar_choro():
	bebe.frame = 2
	choro_ativo = true
	timer.start(ControleDeFase.nivel_atual.tempo_limite_choro)
	ControleDeAudio.toca_efeito_ciclo("bebe_chorando", "bebe_chorando")


func finalizar_choro():
	bebe.frame = 0
	choro_ativo = false
	timer.stop()
	ControleDeAudio.para_efeito_ciclo("bebe_chorando")
	ControleDeAudio.toca_efeito("bebe_feliz")
	resetar_timer()


func resetar_timer():
	if ControleDeFase.nivel_atual:
		timer_choro = (
			ControleDeFase.nivel_atual.intervalo_choro
			+ randf_range(
				-ControleDeFase.nivel_atual.variacao_choro, ControleDeFase.nivel_atual.variacao_choro
			)
		)


func _on_timer_timeout() -> void:
	ControleDeFase.estado_nivel.limite_choro_atingido = true


func _on_componente_interagivel_interagir(_jogador: Player) -> void:
	finalizar_choro()
