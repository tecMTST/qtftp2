extends Control

@onready var tempo_label: Label = %TempoLabel
@onready var bagunca_progress_bar: ProgressBar = %BaguncaProgressBar
@onready var pratos_entregues_label: Label = %PratosEntreguesLabel

func _ready() -> void:
	ControleDeFase.nivel_iniciado.connect(_nivel_iniciado)

func _nivel_iniciado(_nivel_atual: Nivel, estado_nivel: EstadoDoNivel) -> void:
	bagunca_progress_bar.max_value = estado_nivel.limite_bagunca

func _process(_delta: float) -> void:
	tempo_label.text = ControleDeFase.estado_nivel.tempo_restante_formatado
	bagunca_progress_bar.value = ControleDeFase.estado_nivel.bagunca
	pratos_entregues_label.text = str(ControleDeFase.estado_nivel.pratos_entregues.size())
