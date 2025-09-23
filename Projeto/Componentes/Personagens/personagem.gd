class_name Personagem
extends CharacterBody2D

@export var id: String
@export var nome: String
@export var referencia_de_colisao_para_dialogo: Node

var posicao_alvo
var lerp_speed = 0.01

func _ready() -> void:
	add_to_group("personagem", true)

func _process(_delta: float) -> void:
	if posicao_alvo:
		_processa_movimento()


func mover_para(_posicao_alvo: Vector2, _lerp_speed: float = 0.01) -> void:
	posicao_alvo = _posicao_alvo
	lerp_speed = _lerp_speed

func _processa_movimento() -> void:
	position = position.lerp(posicao_alvo, lerp_speed)
	if position.distance_to(posicao_alvo) < 1.0:
		position = posicao_alvo
		posicao_alvo = null
