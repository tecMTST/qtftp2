class_name BaguncaCena
extends Node2D

func _on_componente_interagivel_interagir(_jogador):
	if(!_jogador.objeto_agarrado):
		queue_free()
