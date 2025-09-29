class_name ElzaRig extends Node2D

var segurando : bool = false
var segurando_lucas : bool = false
var amamentando : bool = false
var ativo : bool = true
var rostos : Array[Node] = []

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var cabeca: Polygon2D = $rig1/sprites/cabeca
@onready var rig_1: Node2D = $rig1
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	rostos = cabeca.get_children()

func _process(_delta: float) -> void:
	if ativo:
		var velocidade_animacao = remap(abs(get_parent().velocity.length()),0.0, 600.0, 0.0, 1.0)
		animation_tree.set("parameters/Velocidade/blend_position", velocidade_animacao)
		if segurando:
			animation_tree.set("parameters/Segurar/blend_amount", 1)
		else:
			animation_tree.set("parameters/Segurar/blend_amount", 0)
		if not amamentando:
			animation_tree.set("parameters/AmamentarLucas/blend_amount", 0)
		if not segurando_lucas:
			animation_tree.set("parameters/SegurarLucas/blend_amount", 0)
	else:
		animation_tree.set("parameters/Velocidade/blend_position", 0)

func ajuntar():
	animation_tree.set("parameters/Velocidade/blend_position", 0.0)
	animation_tree.set("parameters/Pegar/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func pegar_lucas():
	segurando_lucas = true
	animation_tree.set("parameters/PegarLucas/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	await get_tree().create_timer(0.5).timeout
	animation_tree.set("parameters/SegurarLucas/blend_amount", 1)

func amamentar():
	if not segurando_lucas:
		return
	animation_tree.set("parameters/InicioMamar/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	await get_tree().create_timer(0.5).timeout
	animation_tree.set("parameters/AmamentarLucas/blend_amount", 1)
	amamentando = true

func largar_lucas():
	animation_tree.set("parameters/AmamentarLucas/blend_amount", 0)
	await get_tree().create_timer(0.5).timeout
	animation_tree.set("parameters/SegurarLucas/blend_amount", 0)
	segurando_lucas = false
	amamentando = false

func mudar_rosto(nome : String):
	for rosto in rostos:
		rosto.visible = rosto.name == nome

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
