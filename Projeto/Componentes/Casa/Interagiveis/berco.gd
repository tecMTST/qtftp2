class_name Berco extends BaseInteragivel

var timer_choro: float = 0
var iniciado: bool = false
var choro_ativo: bool = false

@onready var timer: Timer = $Timer
@onready var visualizador_temporal: VisualizadorTemporal = $VisualizadorTemporal
@onready var lucas_rig: LucasRigDessat = $lucas_rig_dessat


func _ready() -> void:
	nome = "Berço"
	if not ControleDeFase.nivel_atual or not ControleDeFase.nivel_atual.choro:
		return
	resetar_timer()
	iniciado = true
	lucas_rig.choramingando = false
	lucas_rig.chorando = false


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
	lucas_rig.choramingando = true


func iniciar_choro():
	lucas_rig.chorando = true
	choro_ativo = true
	timer.start(ControleDeFase.nivel_atual.tempo_limite_choro)
	ControleDeAudio.toca_efeito_ciclo("bebe_chorando", "bebe_chorando")


func finalizar_choro():
	lucas_rig.choramingando = false
	lucas_rig.chorando = false
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
