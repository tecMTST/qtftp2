class_name TioRig  extends Node2D

var ativo : bool = true

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var rig_1: Node2D = $rig1
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _process(_delta: float) -> void:
	if ativo:
		var velocidade_animacao = remap(abs(get_parent().velocity.length()),0.0, 600.0, 0.0, 1.0)
		animation_tree.set("parameters/Velocidade/blend_position", velocidade_animacao)
	else:
		animation_tree.set("parameters/Velocidade/blend_position", 0)

func olhar_para(direcao : String):
	if direcao == "direita":
		rig_1.scale.x = -abs(rig_1.scale.x)
	else:
		rig_1.scale.x = abs(rig_1.scale.x)
		
func animacao_direta(nome : String):
	animation_tree.active = false
	animation_player.play(nome)
	await animation_player.animation_finished
	animation_tree.active = true
