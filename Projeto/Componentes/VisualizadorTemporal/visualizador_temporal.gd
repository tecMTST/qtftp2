@tool
class_name VisualizadorTemporal
extends Node2D

const QUANTIDADE_DE_PONTOS_NO_CIRCULO := 32

@export var temporizador: Timer:
	set(valor):
		temporizador = valor
		if Engine.is_editor_hint():
			update_configuration_warnings()

@export var radius := 20.0
@export var angulo_inicial := -90
@export var cor := Color("478cbf") # azul
@export var invertido : bool = false

@export_tool_button("Iniciar/Parar timer no editor")
var botao = func():
	if not temporizador:
		return

	if temporizador.is_stopped():
		temporizador.start()
	else:
		temporizador.stop()

var porcentagem := 0.0:
	set(valor):
		porcentagem = valor
		queue_redraw()



func _process(_delta):
	if temporizador == null:
		return

	if temporizador.time_left > 0:
		if not invertido:
			porcentagem = temporizador.time_left / temporizador.wait_time
		else:
			porcentagem = 1 - (temporizador.time_left / temporizador.wait_time)

func desenhar_circulo_de_visualizacao():
	var de_angulo = angulo_inicial
	var ate_angulo = angulo_inicial + (360 * porcentagem)

	var pontos_no_arco = PackedVector2Array()
	pontos_no_arco.push_back(Vector2.ZERO)

	if not invertido:
		for i in range(QUANTIDADE_DE_PONTOS_NO_CIRCULO + 1):
			var angulo_do_ponto = deg_to_rad(
				de_angulo - i * (ate_angulo - de_angulo) / QUANTIDADE_DE_PONTOS_NO_CIRCULO)
			var ponto = Vector2(cos(angulo_do_ponto), sin(angulo_do_ponto)) * radius
			pontos_no_arco.push_back(ponto)
	else:
		for i in range(QUANTIDADE_DE_PONTOS_NO_CIRCULO + 1, -1, -1):
			var angulo_do_ponto = deg_to_rad(
				de_angulo - i * (ate_angulo - de_angulo) / QUANTIDADE_DE_PONTOS_NO_CIRCULO)
			var ponto = Vector2(cos(angulo_do_ponto), sin(angulo_do_ponto)) * radius
			pontos_no_arco.push_back(ponto)

	cor.a = 0.80
	draw_colored_polygon(pontos_no_arco, cor)
	z_index = 99

func _draw():
	if not visible or temporizador == null:
		return

	desenhar_circulo_de_visualizacao()

func _get_configuration_warnings():
	if temporizador == null:
		return ["É necessário definir um Timer"]
	return []
