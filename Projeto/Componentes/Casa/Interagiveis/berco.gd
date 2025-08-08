class_name Berco extends BaseInteragivel

var timer_choro: float = 0
var iniciado: bool = false
var choro_ativo: bool = false

@onready var bebe: AnimatedSprite2D = $Bebe
@onready var timer: Timer = $Timer
@onready var visualizador_temporal: VisualizadorTemporal = $VisualizadorTemporal


func _ready() -> void:
	Nome = "Berço"
	if not ControleDeFase.NivelAtual or not ControleDeFase.NivelAtual.Choro:
		return
	#TODO Configurar Audio do choro
	resetar_timer()
	iniciado = true


func _process(delta: float) -> void:
	if not ControleDeFase.NivelAtual or not ControleDeFase.NivelAtual.Choro:
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
	print_debug('mechendo')
	
func animacao_choro():
	print_debug('choro')

func iniciar_choro():
	#TODO animacao iniciar
	choro_ativo = true
	timer.start(ControleDeFase.NivelAtual.TempoLimiteChoro)
	ControleDeAudio.toca_efeito_ciclo("bebe_chorando", "bebe_chorando")


func finalizar_choro():
	#TODO animacao parar
	choro_ativo = false
	timer.stop()
	ControleDeAudio.para_efeito_ciclo("bebe_chorando")
	ControleDeAudio.toca_efeito("bebe_feliz")
	resetar_timer()


func resetar_timer():
	if ControleDeFase.NivelAtual:
		timer_choro = (
			ControleDeFase.NivelAtual.IntervaloChoro
			+ randf_range(
				-ControleDeFase.NivelAtual.VariacaoChoro, ControleDeFase.NivelAtual.VariacaoChoro
			)
		)


func _on_timer_timeout() -> void:
	ControleDeFase.EstadoNivel.LimiteChoroAtingido = true


func _on_componente_interagivel_interagir(_jogador: Player) -> void:
	finalizar_choro()
