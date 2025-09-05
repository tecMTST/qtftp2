extends Control

@onready var tempo_label: Label = %TempoLabel
@onready var pratos_entregues_label: Label = %PratosEntreguesLabel
@onready var textura_receita: TextureRect = $ReceitaAtual/TexturaReceita

func _ready() -> void:
	ControleDeFase.nova_receita.connect(_on_receita_mudou)

func _on_receita_mudou(nova_receita: Receita) -> void:
	var caminho: String = nova_receita.caminho_sprite
	if caminho != "":
		textura_receita.texture = load(caminho) as Texture2D
		textura_receita.visible = true
	else:
		push_error("imagem não encontrada para receita", nova_receita.nome)
		textura_receita.visible = false

func _process(_delta: float) -> void:
	tempo_label.text = ControleDeFase.estado_nivel.tempo_restante_formatado
	pratos_entregues_label.text = str(
		ControleDeFase.estado_nivel.pratos_entregues.size(),
		"/",
		ControleDeFase.nivel_atual.quantidade_pratos_exibido
	)
