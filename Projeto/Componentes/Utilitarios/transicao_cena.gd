class_name TransicaoCena extends CanvasLayer

signal finalizou

@export var cor_fundo : Color = Color.BLACK
@export var tempo_transicao : float = 1.0
@export var auto_clarear : bool = true
@export var iniciar_visivel : bool = true
@onready var fundo: ColorRect = $TransicaoCena/Fundo
@onready var fader: Fader = $TransicaoCena/Fader

func _ready() -> void:
	fundo.color = cor_fundo
	fader.StartVisible = iniciar_visivel
	fundo.visible = true
	visible = true
	if auto_clarear:
		clarear()

func escurecer():
	fader.FadeIn(tempo_transicao)
	await fader.finished
	finalizou.emit()

func clarear():
	fader.FadeOut(tempo_transicao)
	await fader.finished
	finalizou.emit()
