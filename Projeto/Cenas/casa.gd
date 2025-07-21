class_name Casa extends Node2D

@onready var botao_acao: TouchScreenButton = $BotaoAcao
@onready var botao_pausa: TouchScreenButton = $BotaoPausa
@onready var menu_pausa: Node2D =  $MenuPausa
@onready var slider_volume: HSlider = $MenuPausa/SliderVolume

func _ready() -> void:
	ControleDeFase.CarregarNivel(1)
	ControleDeFase.IniciarNivel()
	ControleDeAudio.toca_musica_com_intro("casa_intro", "casa_loop")
	slider_volume.set_value_no_signal(db_to_linear(AudioServer.get_bus_index("Master")))

func _on_player_acao_ativada() -> void:
	botao_acao.visible = true

func _on_player_acao_desativada() -> void:
	botao_acao.visible = false


func _on_botao_pausa_pressed() -> void:
	#botao_pausa.hide()
	menu_pausa.visible = !menu_pausa.visible
	get_tree().paused = !get_tree().paused


func _on_slider_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
