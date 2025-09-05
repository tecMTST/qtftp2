@tool
class_name VisualizadorPercentual
extends Node2D

const QUANTIDADE_DE_PONTOS_NO_CIRCULO := 32

@export var valor: float:
	set(novo_valor):
		valor = novo_valor
		queue_redraw()
@export var valor_maximo: float = 100
@export var radius := 20.0
@export var angulo_inicial := -90
@export var cor := Color("478cbf")

@export_tool_button("Visualizar no editor")
var botao = func():
	queue_redraw()

func desenhar_circulo_de_visualizacao():
	var angulo = remap(valor, 0, valor_maximo, 0, 360)
	var de_angulo = angulo_inicial
	var ate_angulo = angulo_inicial + angulo

	var pontos_no_arco = PackedVector2Array()
	pontos_no_arco.push_back(Vector2.ZERO)

	for i in range(QUANTIDADE_DE_PONTOS_NO_CIRCULO + 1):
		var angulo_do_ponto = deg_to_rad(
			de_angulo - i * (ate_angulo - de_angulo) / QUANTIDADE_DE_PONTOS_NO_CIRCULO)
		var ponto = Vector2(cos(angulo_do_ponto), sin(angulo_do_ponto)) * radius
		pontos_no_arco.push_back(ponto)

	draw_colored_polygon(pontos_no_arco, cor)

func _draw():
	if not visible:
		return
	desenhar_circulo_de_visualizacao()
