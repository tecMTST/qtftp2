class_name LucasRig extends Node2D

var choramingando : bool = false
var chorando : bool = false

@onready var animation_tree: AnimationTree = $AnimationTree

func _process(_delta: float) -> void:
	if choramingando:
		animation_tree.set("parameters/Choramingando/blend_amount", 1)
	else:
		animation_tree.set("parameters/Choramingando/blend_amount", 0)

	if chorando:
		animation_tree.set("parameters/Chorando/blend_amount", 1)
	else:
		animation_tree.set("parameters/Chorando/blend_amount", 0)
