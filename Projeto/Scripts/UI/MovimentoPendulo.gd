class_name MovimentoPendulo
extends Node2D

@export var alcance : float
@export var velocidade : float
@export var alcance_certo : float

var alcance_atual : float
var tempo_passado : float = 0

func _process(delta: float) -> void:
	tempo_passado += delta

	alcance_atual = sin(tempo_passado * velocidade) * alcance
	position.x = 285 + alcance_atual


func _esta_no_alcance_certo() -> bool:
	return abs(alcance_atual) < alcance_certo
