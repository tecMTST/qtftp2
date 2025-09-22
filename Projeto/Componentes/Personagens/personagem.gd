class_name Personagem
extends CharacterBody2D

@export var id: String
@export var nome: String
@export var referencia_de_colisao_para_dialogo: CollisionShape2D


func _ready() -> void:
	add_to_group("personagem")
