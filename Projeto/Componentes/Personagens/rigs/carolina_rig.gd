class_name CarolinaRig extends Node2D

@export var sentada: bool = true
@export var celular: bool = true
@export var inverter_sentada: bool = true

var parent: CharacterBody2D

@onready var rig_1: Node2D = $rig1
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree

func _ready() -> void:
	parent = get_parent()

func _process(_delta: float) -> void:
	if parent and not sentada and not celular:
		var velocidade_animacao = remap(abs(parent.velocity.length()),0.0, 600.0, 0.0, 1.0)
		animation_tree.set("parameters/Velocidade/blend_position", velocidade_animacao)
		animation_tree.set("parameters/Sentada/blend_amount", 0)
		var velocidade = parent.velocity.x
		if velocidade > 0:
			rig_1.scale.x = -abs(rig_1.scale.x)
		elif velocidade < 0:
			rig_1.scale.x = abs(rig_1.scale.x)
	elif not celular and sentada:
		animation_tree.set("parameters/Velocidade/blend_position", 0)
		animation_tree.set("parameters/Sentada/blend_amount", 1)
		if inverter_sentada:
			rig_1.scale.x = -abs(rig_1.scale.x)
		else:
			rig_1.scale.x = abs(rig_1.scale.x)
	elif celular and sentada:
		animation_tree.set("parameters/Velocidade/blend_position", 0)
		animation_tree.set("parameters/Sentada/blend_amount", 1)
		if inverter_sentada:
			rig_1.scale.x = -abs(rig_1.scale.x)
		else:
			rig_1.scale.x = abs(rig_1.scale.x)
	elif celular and not sentada:
		animation_tree.set("parameters/Velocidade/blend_position", 0)
		animation_tree.set("parameters/Sentada/blend_amount", 0)

		
