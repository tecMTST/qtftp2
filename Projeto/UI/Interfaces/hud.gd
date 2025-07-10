extends Control
@onready var tempo_label: Label = %TempoLabel
@onready var bagunca_progress_bar: ProgressBar = %BaguncaProgressBar

func _ready() -> void:
	ControleDeFase.NivelIniciado.connect(_nivel_iniciado)

func _nivel_iniciado(NivelAtual: Nivel, EstadoNivel: EstadoDoNivel) -> void:
	bagunca_progress_bar.max_value = EstadoNivel.LimiteBagunca

func _process(_delta: float) -> void:
	tempo_label.text = ControleDeFase.EstadoNivel.TempoRestanteFormatado
	bagunca_progress_bar.value = ControleDeFase.EstadoNivel.Bagunca
