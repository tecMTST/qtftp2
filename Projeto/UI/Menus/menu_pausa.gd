class_name MenuPausa extends Control

signal continuar

@export var briefing : Briefing

@onready var receita_miolo: TextureRect= $"Receita"
@onready var fase: Label = $Fase
@onready var receita_atual: TextureRect = $"Receita Atual"
@onready var botao_briefing: Button = $"TextureRect/Menu Abas/botao_briefing"
@onready var retornar_para_tela_inicial: Button = $"retornar para tela inicial"
@onready var botao_controles: Button = $"TextureRect/Menu Abas/botao_controles"
@onready var botao_configuracoes: Button = $"TextureRect/Menu Abas/botao_configuracoes"
@onready var botaoaba: Theme = preload("res://UI/botaoAbaPause.tres")
@onready var botaoaba_naoselecionado: Theme = preload("res://UI/MenuAbaPause_naoselecionado.tres")
@onready var controle_musica: HSlider = $controle_audio_musica
@onready var controle_efeitos: HSlider = $controle_audio_efeita_sonoro


func _ready() -> void:
	controle_musica.value_changed.connect(
		Callable(ControleDeAudio, "_on_value_changed")
	)
	controle_efeitos.value_changed.connect(
		Callable(ControleDeAudio, "_on_value_changed_sfx")
	)


func atualizar() -> void:
	fase.text=ControleDeFase.nivel_atual.nome
	if(ControleDeFase.receita_selecionada):
		botao_briefing.icon=load(ControleDeFase.receita_selecionada.caminho_sprite)
		_on_receita_pressed()
	else:
		_on_control_pressed()
		botao_briefing.hide()


# essa função despausa o jogo
func _on_continuar_pressed() -> void:
	continuar.emit()
	get_tree().paused = false
	hide()


# sai do jogo desde o menu de pausa
func _on_sair_pressed() -> void:
	get_tree().quit()


# vai para a tela principal desde o menu de pausa
func _on_retornar_para_tela_inicial_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/Menus/menu_principal.tscn")


#abre a receita atual
func _on_receita_pressed() -> void:
	var caminho_receita=ControleDeFase.nivel_atual.caminhos_briefing.filter(
		func(c): return c.nome==ControleDeFase.receita_selecionada.nome)[0]
	receita_miolo.texture=load(caminho_receita.caminho.replace("briefing","pause"))
	receita_miolo.show()
	retornar_para_tela_inicial.hide()
	botao_controles.set_theme(botaoaba_naoselecionado)
	botao_configuracoes.set_theme(botaoaba_naoselecionado)
	botao_briefing.set_theme(botaoaba)

#abre a aba de controles
func _on_control_pressed() -> void:
	receita_miolo.texture=load("res://Recursos/Graficos/UI/Briefing/pause-tutorial-controles.svg")
	receita_miolo.show()
	retornar_para_tela_inicial.hide()
	botao_controles.set_theme(botaoaba)
	botao_configuracoes.set_theme(botaoaba_naoselecionado)
	botao_briefing.set_theme(botaoaba_naoselecionado)

#abre a aba de configurações
func _on_config_pressed() -> void:
	receita_miolo.hide()
	botao_briefing.set_theme(botaoaba_naoselecionado)
	botao_controles.set_theme(botaoaba_naoselecionado)
	botao_configuracoes.set_theme(botaoaba)
	retornar_para_tela_inicial.show()
