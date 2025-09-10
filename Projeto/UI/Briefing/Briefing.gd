class_name Briefing extends CanvasLayer

signal iniciado
signal finalizado

@export var partes: Array[Texture2D] = []

var atual: int = -1
var tratar_pause:bool=true

@onready var fader_principal: Fader = $BriefingBase/FaderPrincipal
@onready var imagem: TextureRect = $BriefingBase/Panel/Centro/Imagem
@onready var fader_centro: Fader = $BriefingBase/Panel/Centro/FaderCentro
@onready var proximo_label: Label = $BriefingBase/Proximo/ProximoLabel
@onready var voltar: TouchScreenButton = $BriefingBase/Voltar


func iniciar(pause:bool=true):
	fader_principal.FadeIn()
	tratar_pause=pause
	visible = true
	if tratar_pause:
		get_tree().paused = true
	_carregar_imagens_de_briefing()
	ControleDeAudio.toca_musica("briefing", false)
	_proximo()
	_mostrar()
	iniciado.emit()

func _carregar_imagens_de_briefing():
	partes = []
	for caminho_briefing in ControleDeFase.nivel_atual.caminhos_briefing:
		partes.push_front(load(caminho_briefing))

func _mostrar():
	await fader_principal.finished
	fader_centro.FadeIn()
	await fader_centro.finished

func _proximo():
	atual += 1
	if atual == 0:
		voltar.visible = false
	else:
		voltar.visible = true
	if len(partes) == 0:
		_finalizar()
	elif len(partes) - 1 > atual:
		imagem.texture = partes[atual]
		if atual == 0:
			voltar.visible = false
		else:
			voltar.visible = true
	elif len(partes) - 1 == atual:
		imagem.texture = partes[atual]
		proximo_label.text = "Começar"
	else:
		_finalizar()

func _voltar():
	if atual > 0:
		atual -= 1
		proximo_label.text = "Próximo"
		if atual == 0:
			voltar.visible = false
		else:
			voltar.visible = true
		imagem.texture = partes[atual]

func _finalizar():
	fader_principal.FadeOut()
	await fader_principal.finished
	if tratar_pause:
		get_tree().paused = false
	finalizado.emit()
	#queue_free()
	visible = false
	atual=-1

func _on_voltar_pressed() -> void:
	_voltar()

func _on_proximo_pressed() -> void:
	_proximo()
