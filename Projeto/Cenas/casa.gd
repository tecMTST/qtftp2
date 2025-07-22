class_name Casa extends Node2D

@onready var botao_acao: TouchScreenButton = $BotaoAcao
@onready var botao_pausa: TouchScreenButton = $BotaoPausa
#@onready var menu_pausa: Node2D =  $MenuPausa
@onready var slider_volume: HSlider = $MenuPausa/SliderVolume
@onready var menu_pausa: CanvasLayer = $CanvasLayer

func _ready() -> void:
	ControleDeFase.CarregarNivel(1)
	ControleDeFase.IniciarNivel()
	ControleDeAudio.toca_musica_com_intro("casa_intro", "casa_loop")
	slider_volume.set_value_no_signal(db_to_linear(AudioServer.get_bus_index("Master")))
	menu_pausa.hide()
	
func _on_player_acao_ativada() -> void:
	botao_acao.visible = true

func _on_player_acao_desativada() -> void:
	botao_acao.visible = false


func _on_botao_pausa_pressed() -> void:
	get_tree().paused = true
	menu_pausa.show()
	
	#botao_pausa.hide()
	#menu_pausa.visible = !menu_pausa.visible
	#get_tree().paused = !get_tree().paused


func _on_continuar_pressed() -> void:
	get_tree().paused = false
	menu_pausa.hide()


func _on_sair_pressed() -> void:
	get_tree().quit()
