class_name GraficoDerrota extends CanvasLayer

var timer : float = 4.0

@onready var derrota_vazado: CPUParticles2D = $Control/Derrota/DerrotaVazado
@onready var derrota_cheio: CPUParticles2D = $Control/Derrota/DerrotaCheio
@onready var fader: Fader = $Control/FaderBase
@onready var fader_preto: Fader = $Control/ColorRect/FaderPreto

func _ready() -> void:
	if len(get_tree().get_nodes_in_group("grafico_derrota")) > 1:
		queue_free()
	get_tree().paused = true
	derrota_vazado.emitting = true
	derrota_cheio.emitting = true

func _on_tentar_novamente_pressed() -> void:
	fader_preto.FadeIn()
	await fader_preto.finished
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_tela_inicial_pressed() -> void:
	fader_preto.FadeIn()
	await fader_preto.finished
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/Menus/menu_principal.tscn")
