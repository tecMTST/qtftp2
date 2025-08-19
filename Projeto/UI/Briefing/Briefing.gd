class_name Briefing extends CanvasLayer

signal Iniciado
signal Finalizado

@export var Partes : Array[Texture2D] = []

@onready var fader_principal: Fader = $BriefingBase/FaderPrincipal
@onready var imagem: TextureRect = $BriefingBase/Panel/Centro/Imagem
@onready var fader_centro: Fader = $BriefingBase/Panel/Centro/FaderCentro
@onready var proximo_label: Label = $BriefingBase/Proximo/ProximoLabel
@onready var voltar: TouchScreenButton = $BriefingBase/Voltar

var atual : int = -1

func Iniciar():
	visible = true
	get_tree().paused = true
	__proximo()	
	__mostrar()
	Iniciado.emit()
	
func __mostrar():
	await fader_principal.finished
	fader_centro.FadeIn()
	await fader_centro.finished

func __proximo():		
	atual += 1	
	if atual == 0:
		voltar.visible = false
	else:
		voltar.visible = true
	if len(Partes) == 0:
		__finalizar()
	elif len(Partes) - 1 > atual:
		imagem.texture = Partes[atual]	
		if atual == 0:
			voltar.visible = false
		else:
			voltar.visible = true			
	elif len(Partes) - 1 == atual:	
		imagem.texture = Partes[atual]	
		proximo_label.text = "Começar"		
	else:
		__finalizar()

func __voltar():
	if atual > 0:
		atual -= 1
		proximo_label.text = "Próximo"	
		if atual == 0:
			voltar.visible = false
		else:
			voltar.visible = true	
		imagem.texture = Partes[atual]	
			
func __finalizar():
	fader_principal.FadeOut()
	await fader_principal.finished
	get_tree().paused = false
	Finalizado.emit()
	queue_free()

func _on_voltar_pressed() -> void:
	__voltar()

func _on_proximo_pressed() -> void:
	__proximo()
