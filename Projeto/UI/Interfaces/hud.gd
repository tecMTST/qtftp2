extends Control

@onready var tempo_label: Label = %TempoLabel
@onready var bagunca_progress_bar: ProgressBar = %BaguncaProgressBar
@onready var pratos_entregues_label: Label = %PratosEntreguesLabel
@onready var textura_receita: TextureRect = $ReceitaAtual/TexturaReceita

func _ready() -> void:
	ControleDeFase.nivel_iniciado.connect(_nivel_iniciado)
	ControleDeFase.nova_receita.connect(_on_receita_mudou)

func _on_receita_mudou(nova_receita: Receita) -> void:
	var caminho: String = nova_receita.caminho_sprite
	if caminho != "":
		textura_receita.texture = load(caminho) as Texture2D
		textura_receita.visible = true
	else:
		push_error("imagem não encontrada para receita", nova_receita.nome)
		textura_receita.visible = false

func _nivel_iniciado(_nivel_atual: Nivel, estado_nivel: EstadoDoNivel) -> void:
	bagunca_progress_bar.max_value = estado_nivel.limite_bagunca


func _process(_delta: float) -> void:
	tempo_label.text = ControleDeFase.estado_nivel.tempo_restante_formatado
	bagunca_progress_bar.value = ControleDeFase.estado_nivel.bagunca
	pratos_entregues_label.text = str(ControleDeFase.estado_nivel.pratos_entregues.size())
