class_name CarolinaRig extends Node2D

@export var Sentada : bool = true
@export var InverterSentada : bool = true
@onready var rig_1: Node2D = $rig1
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
var parent :CharacterBody2D

func _ready() -> void:
	parent = get_parent()

func _process(_delta: float) -> void:
	if parent and not Sentada:
		var velocidade_animacao = remap(abs(parent.velocity.length()),0.0, 600.0, 0.0, 1.0)
		animation_tree.set("parameters/Velocidade/blend_position", velocidade_animacao)
		animation_tree.set("parameters/Sentada/blend_amount", 0)
		var velocidade = parent.velocity.x
		if velocidade > 0:
			rig_1.scale.x = -abs(rig_1.scale.x)
		elif velocidade < 0:
			rig_1.scale.x = abs(rig_1.scale.x)
	else:
		animation_tree.set("parameters/Velocidade/blend_position", 0)
		animation_tree.set("parameters/Sentada/blend_amount", 1)
		if InverterSentada:
			rig_1.scale.x = -abs(rig_1.scale.x)
		else:
			rig_1.scale.x = abs(rig_1.scale.x)
		
