class_name Berco extends BaseInteragivel

@export var tempo_amamentar = 1.0

var timer_choro: float = 0
var iniciado: bool = false
var choro_ativo: bool = false
var player : Player
var amamentando : bool = false

@onready var timer: Timer = $Timer
@onready var visualizador_temporal: VisualizadorTemporal = $VisualizadorTemporal
@onready var lucas_rig: LucasRigDessat = $lucas_rig_dessat

func _ready() -> void:
	ativo = false
	player = get_tree().get_first_node_in_group("player")
	nome = "Berço"
	if get_tree().current_scene.is_in_group("cutscene"):
		return
	if not ControleDeFase.nivel_atual or not ControleDeFase.nivel_atual.choro:
		return
	resetar_timer()
	iniciado = true
	lucas_rig.choramingando = false
	lucas_rig.chorando = false


func _process(delta: float) -> void:
	if not amamentando:
		if not ControleDeFase.nivel_atual or not ControleDeFase.nivel_atual.choro:
			return
		if get_tree().current_scene.is_in_group("cutscene"):
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
	ativo = true
	lucas_rig.choramingando = true

func iniciar_choro():
	ativo = true
	lucas_rig.chorando = true
	choro_ativo = true
	visualizador_temporal.visible = true
	timer.start(ControleDeFase.nivel_atual.tempo_limite_choro)
	ControleDeAudio.toca_efeito_ciclo("bebe_chorando", "bebe_chorando")

func finalizar_choro():
	ativo = false
	lucas_rig.choramingando = false
	lucas_rig.chorando = false
	visualizador_temporal.visible = false
	choro_ativo = false
	timer.stop()
	ControleDeAudio.para_efeito_ciclo("bebe_chorando")
	ControleDeAudio.toca_efeito("bebe_feliz")

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
	if ativo and not player.esta_agarrando:
		player.inicia_amamentacao(self, tempo_amamentar)
		finalizar_choro()

func ocultar_lucas():
	lucas_rig.visible = false

func mostrar_lucas():
	lucas_rig.visible = true
