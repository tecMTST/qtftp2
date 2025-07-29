extends Node2D
class_name MovimentoPendulo

@export var alcance : float
@export var velocidade : float
@export var alcanceCerto : float

var tempoPassado : float = 0
var alcanceAtual : float

func _process(delta: float) -> void:
	tempoPassado += delta
	
	alcanceAtual = sin(tempoPassado * velocidade) * alcance
	position.x = 285 + alcanceAtual

func _estaNoAlcanceCerto() -> bool:
	return abs(alcanceAtual) < alcanceCerto
